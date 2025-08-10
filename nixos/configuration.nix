{lib, inputs, config, pkgs, callPackage, ... }:

let
  packagedRStudio = pkgs.rstudioWrapper.override{ packages = with pkgs.rPackages; [ ggplot2 dplyr ghql jsonlite]; };
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#      ./mwc/mwc.nix # Currently borked on unstable branch due to updating scenefx: 0.2.1 -> 0.4.1
    ];

  virtualisation = {
  #  vmware = {
  #   host.enable = true;
  #    guest.enable = true;
  #  };
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  systemd.network.wait-online.enable = false;

  # Service-side configuration for NixOS.
  services = {
    accounts-daemon.enable = true;
    blueman.enable = true;
    flatpak.enable = true;
    greetd = {
      enable = true;
      settings = {
          default_session = {
              command = ''${pkgs.greetd.tuigreet}/bin/tuigreet --cmd niri-session'';
              user = "greeter";
          };
      };
    };
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    logind.lidSwitchExternalPower = "ignore";

    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    }; 
    
    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Enable sound with pipewire.
    pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };

    printing.enable = true;
    tumbler.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    xserver.videoDrivers = [ "vmware" ];
  };

  # Programs-related configuration for NixOS.
  programs = {
    dconf.enable = true;
    direnv.enable = true;

    foot = {
      enable = true;
      settings = {
        main = {
          font="Iosevka:size=12";
        };
      };
      theme = "catppuccin-mocha";
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry.curses;
    };

    niri.enable = true;
    mtr.enable = true;
   # mwc.enable = true;

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };

  security.polkit.enable = true;
  boot = {
    blacklistedKernelModules = [ "hp_wmi" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "transparent_hugepage=never" ]; # Recommended for the use with VMWare.

    # Bootloader.
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
    extraModprobeConfig = ''hid_apple fnmode=0''; # Disable Fn Lock on boot (for external KB) + set up virtual camera.
  };
  
  # Bluetooth turn-on.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  hardware.nvidia-container-toolkit.enable = true;

  networking = {
    dhcpcd.wait = "if-carrier-up"; # shaves off seconds during boot by removing wait.
    hostName = "necoarc";
    enableIPv6 = false;
  
    # proxy = {
      # default = "http://user:password@proxy:port/";
      # noProxy = "127.0.0.1,localhost,internal.domain"; 
    # }
    
    # Enable wireless networking using iwd.
    wireless.iwd = {
      enable = true;
      settings =  {
        Settings = {
          AutoConnect = true;
        };
      };
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "nl_NL.UTF-8";
      LC_IDENTIFICATION = "nl_NL.UTF-8";
      LC_MEASUREMENT = "nl_NL.UTF-8";
      LC_MONETARY = "nl_NL.UTF-8";
      LC_NAME = "nl_NL.UTF-8";
      LC_NUMERIC = "nl_NL.UTF-8";
      LC_PAPER = "nl_NL.UTF-8";
      LC_TELEPHONE = "nl_NL.UTF-8";
      LC_TIME = "nl_NL.UTF-8";
    };

    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
        waylandFrontend = true;
        settings.inputMethod = {
          "Groups/0" = {
            "Name" = "Default";
            "Default Layout" = "us";
            "DefaultIM" = "mozc";
          };
          "Groups/0/Items/0" = {
            "Name" = "keyboard-us";
            "Layout" = null;
          };
          "Groups/0/Items/1" = {
            "Name" = "keyboard-ru";
            "Layout" = null;
          };
          "Groups/0/Items/2" = {
            "Name" = "mozc";
            "Layout" = null;
          };
          "GroupOrder" = {
            "0" = "Default";
          };
        };
      };
    };

    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
      "nl_NL.UTF-8/UTF-8"  
    ];
  };

  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.necoarc = {
    isNormalUser = true;
    description = "Neco-Arc";
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alsa-utils
    appimage-run
    btrfs-assistant
    btop
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    (discord-canary.override {
      withOpenASAR = true;
      withVencord = true;
    })
    distrobox
    evince
    file-roller
    floorp
    foot
    fuzzel
    gimp3
    git
    gparted
    gpu-screen-recorder-gtk
    gnumake
    grim
    helvum
    inputs.listentui.packages.${pkgs.system}.default
    inputs.zen-browser.packages."${system}".beta
    insomnia
    jq
    kdePackages.kdenlive
    killall
    loupe
    libnotify
    lutris
    lxappearance
    nemo
    nix-prefetch-github
    nixpkgs-review
    npins
    #openutau
    packagedRStudio
    pavucontrol
    playerctl
    (prismlauncher.override {
      jdks = [
        graalvm-ce
        zulu
        zulu17
        zulu8
      ];
    })
    protonup-qt
    (python312.withPackages (ps: with ps; [
      jupyterlab
      matplotlib
      pandas
      statsmodels
      scikitlearn
    ]))
    r2modman
    satty
    shared-mime-info
    slurp
    steamtinkerlaunch
    swaybg
    telegram-desktop
    thunderbird
    vlc
    vscode
    wget
    winetricks
    wineWow64Packages.waylandFull
    wl-clipboard
    wl-gammarelay-rs
    xwayland-satellite
    youtube-music
    yt-dlp
  ];

  fonts = {
    packages = with pkgs; [
      iosevka
     nerd-fonts._0xproto
     noto-fonts-emoji
      sarasa-gothic
    ];
    fontconfig = {
      defaultFonts = {
        serif = ["Iosevka Extended" "Sarasa Gothic"];
        sansSerif = ["Iosevka Extended" "Sarasa Gothic"];
        monospace = ["Iosevka Extended" "Sarasa Mono"];
      };
    };
  };

  console = {
    packages = with pkgs; [ terminus_font ];
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      xdg-desktop-portal-wlr
    ];
    config = {
      i3 = {
        default = [ "gtk" ];
      };
      niri = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
      mwc = {
        default = [ "wlr" "gtk" ];
      };
    };
  };

  # Enable SysRq.
  boot.kernel.sysctl."kernel.sysrq" = 1; 
 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  
  system.stateVersion = "24.11"; # Did you read the comment?
  system.userActivationScripts.regenerateTofiCache = {
    text = 
    ''
      tofi_cache="$HOME/.cache/tofi-drun"
      [[ -f "$tofi_cache" ]] && rm "$tofi_cache"
    '';
  };
  
  nix = {
    channel.enable = false;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than-7d";
      persistent = true;
    };

    optimise = {
      automatic = true;
      dates = [ "monthly" ];
      persistent = true;
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
      substituters = [ 
        "https://cuda-maintainers.cachix.org" 
        "https://chaotic-nyx.cachix.org/"
        "https://nix-community.cachix.org"
        "https://prismlauncher.cachix.org"
        ];
      trusted-public-keys = [ 
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c=" ];
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
  };

environment.sessionVariables.NIXOS_OZONE_WL = "1";
environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text = ''
{
    "rules": [
        {
            "pattern": {
                "feature": "procname",
                "matches": "niri"
            },
            "profile": "Limit Free Buffer Pool On Wayland Compositors"
        }
    ],
    "profiles": [
        {
            "name": "Limit Free Buffer Pool On Wayland Compositors",
            "settings": [
                {
                    "key": "GLVidHeapReuseRatio",
                    "value": 0
                }
            ]
        }
    ]
}
'';
}


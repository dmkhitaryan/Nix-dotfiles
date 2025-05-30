# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{lib, inputs, config, pkgs, callPackage, ... }:

let
  mwc = pkgs.callPackage ./package.nix { };
  packagedRStudio = pkgs.rstudioWrapper.override{ packages = with pkgs.rPackages; [ ggplot2 dplyr ghql jsonlite]; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia.nix
      ./prism.nix
      # TUI anime radio.
      ({pkgs, inputs, ...}:
      {
        environment.systemPackages = [ inputs.listentui.packages.${pkgs.system}.default ];
      })
    ];
  virtualisation = {
    vmware = {
      host.enable = true;
      guest.enable = true;
    };
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  services = {
    blueman.enable = true;
    gvfs.enable = true;
    xserver.videoDrivers = [ "vmware" ];
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    udisks2.enable = true;
    #upower.enable = true;
    accounts-daemon.enable = true;
    tumbler.enable = true;

    greetd = {
      enable = true;
      settings = {
          default_session = {
              command = ''${pkgs.greetd.tuigreet}/bin/tuigreet --cmd niri-session'';
              user = "greeter";
          };
      };
    };
  };

  programs = {
    dconf.enable = true;
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry.curses;
    };
    niri.enable = true;
    mtr.enable = true;
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };
    river.enable = true;
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
    #kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.linuxPackages_cachyos;
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

  networking.hostName = "necoarc"; # Define your hostname.
  networking.enableIPv6 = false;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ja_JP.UTF-8/UTF-8"
    "nl_NL.UTF-8/UTF-8"  
];

  i18n.extraLocaleSettings = {
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
  
  i18n.inputMethod = {
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

   # Enable CUPS to print documents.
  services.logind.lidSwitchExternalPower = "ignore";
  services.printing.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.necoarc = {
    isNormalUser = true;
    description = "Neco-Arc";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    appimage-run
    brightnessctl
    btrfs-assistant
    btop
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    (discord-canary.override {
      #withOpenASAR = true;
      #withVencord = true;
    })
    distrobox
    file-roller
    floorp
    flatpak
    foot
    fuzzel
    gh
    git
    gparted
    gpu-screen-recorder-gtk
    gnumake
    grim
    helvum
    inputs.zen-browser.packages."${system}".twilight
    insomnia
    jq
    kdePackages.kdenlive
    kdePackages.kolourpaint
    killall
    lutris
    libnotify
    lxappearance
  #  mwc
  #  nautilus
    nemo
    networkmanagerapplet
    niri
    nix-prefetch-github
    #openutau
    packagedRStudio
    pavucontrol
    playerctl
    protonup-qt
    protonvpn-cli_2
    (python312.withPackages (ps: with ps; [
      jupyterlab
      matplotlib
      pandas
      statsmodels
      scikitlearn
    ]))
    r2modman
    shared-mime-info
    slurp
    swaybg
    telegram-desktop
    thunderbird
    vesktop
    vlc
    vokoscreen-ng
    vscode
    wayfarer
    wget
    winetricks
    wineWowPackages.stagingFull
    wl-clipboard
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

  # Install and set the default editor to Neovim.
  programs.neovim = {
    enable = true;
  };

  console = {
    #font = "${pkgs.cozette}/share/fonts/opentype/CozetteVector.otf";
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
      river = {
        default = [ "wlr" "gtk" ];
      };
    };
  };

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable Flatpak:
  services.flatpak.enable = true;
 
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable SysRq.
  boot.kernel.sysctl."kernel.sysrq" = 1; 
 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  
  system.stateVersion = "24.11"; # Did you read the comment?
  nix = {
    channel.enable = false;
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
      substituters = [ "https://cuda-maintainers.cachix.org" "https://chaotic-nyx.cachix.org/" ];
      trusted-public-keys = [ 
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8=" ];
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
  };

environment.sessionVariables.NIXOS_OZONE_WL = "1";
environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
}


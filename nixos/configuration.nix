# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{lib, inputs, config, pkgs, callPackage, ... }:

let
  mwc = pkgs.callPackage ./package.nix { };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia.nix
      ./prism.nix
      #./dmenu.nix # Obsolete for now as I try out Reverse PRIME.
      #.autorandr.nix # Don't use external monitors currently to consider this.
      #./sway.nix
      ({pkgs, inputs, ...}:
      {
        environment.systemPackages = [ inputs.listentui.packages.${pkgs.system}.default ];
      })
    ];

  virtualisation.podman = {
  enable = true;
  dockerCompat = true;
};

  services = {
    blueman.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    #upower.enable = true;
    accounts-daemon.enable = true;
    tumbler.enable = true;

    # xserver.enable = true;
    # xserver.displayManager.sddm.enable = true;
    # xserver.displayManager.sddm.wayland.enable = true;
    # xserver.desktopManager.plasma6.enable = true;
    # xserver.displayManager.gdm.enable = true;
    # xserver.desktopManager.gnome.enable = true;
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
    niri.enable = true;
  };

  security.polkit.enable = true;
  programs.dconf.enable = true;
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vkcapture
      obs-pipewire-audio-capture
    ];
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_testing;

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
  security.rtkit.enable = false;
  services.pipewire = {
    enable = true;
    # package = (pkgs.pipewire.overrideAttrs (finalAttrs: {
    #   version = "1.4.1";
    # }));
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    wireplumber.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
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
  nix.settings.experimental-features = ["nix-command" "flakes"];
 
  environment.systemPackages = with pkgs; [
    alacritty
    brightnessctl
    btrfs-assistant
    btop
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    (discord-canary.override {
      withOpenASAR = true;
      withVencord = true;
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
    kdePackages.kdenlive
    kdePackages.kolourpaint
    killall
    lutris
    libnotify
    lxappearance
  #  mwc
    nautilus
    networkmanagerapplet
    niri
    nix-prefetch-github
    nvidia-container-toolkit
    pavucontrol
    playerctl
    protonup-qt
    protonvpn-cli_2
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
      # nerdfonts
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
    defaultEditor = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry.curses;
  };

  # Steam setup.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
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
        #  "org.freedesktop.impl.portal.ScreenShot" = [ "gnome" ];
        #  "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
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

  nix.settings = {
  substituters = [
    "https://cuda-maintainers.cachix.org"
  ];
  trusted-public-keys = [
    "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
  ];
};

environment.sessionVariables.NIXOS_OZONE_WL = "1";
environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];

nix.settings.auto-optimise-store = true;

nix.registry.nixpkgs.flake = inputs.nixpkgs;
nix.channel.enable = false;

environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
nix.settings.nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
}


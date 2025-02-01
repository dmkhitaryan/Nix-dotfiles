# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{lib, inputs, config, pkgs, callPackage, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia.nix
      ./prism.nix
      ./dmenu.nix

      ({pkgs, inputs, ...}:
      {
        environment.systemPackages = [ inputs.listentui.packages.${pkgs.system}.default ];
      })
    ];
  
 # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      desktopManager = {
        runXdgAutostartIfNone = true;
        xterm.enable = false;
      };
      displayManager = {
        lightdm.enable = true;
        sessionCommands = ''
          ${pkgs.xorg.xrdb}/bin/xrdb -merge <${pkgs.writeText "Xresources" ''
          Xft.dpi: 144
          ''}
        '';
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3lock
        ];
      };  
    };
    displayManager = {
      defaultSession = "none+i3";
    };
  };


  services = {
    udisks2.enable = true;
    accounts-daemon.enable = true;
    upower.enable = config.powerManagement.enable;
    gvfs.enable = true;
    tumbler.enable = true;
  };

  security.polkit.enable = true;
  programs.dconf.enable = true;
  programs.thunar.enable = true;

  
  boot = {
    kernelPackages = pkgs.linuxPackages;

    # Bootloader.
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };

      efi.canTouchEfiVariables = true;
    };

    kernelModules = [
      "v4l2loopback" # Virtual camera.
      "snd-aloop"    # Virtual microphone.
    ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      hid_apple fnmode=0  
    ''; # Disable Fn Lock on boot (for external KB) + set up virtual camera.
  };
  #boot.kernelPackages = pkgs.linuxPackages_cachyos;
#  services.scx.enable = true;

  environment.pathsToLink = [ "/libexec" ];
  
  # Bluetooth turn-on.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

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
      #waylandFrontend = true;
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
  services.printing.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.necoarc = {
    isNormalUser = true;
    description = "Neco-Arc";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    autotiling
    brightnessctl
    btrfs-assistant
    blueman
    btop
    dunst
    flameshot
    floorp
    flatpak
    file-roller
    gh
    git
    gparted
    gnome-terminal
    gnumake
    obs-studio
    killall
    kitty

    
    (lutris.override {
      extraPkgs = pkgs: [
        proton-ge-bin
      ];
    })
    
    lxappearance
    networkmanagerapplet
    nitrogen
    nix-prefetch-github
    pavucontrol
    playerctl
    protonup-qt
    protonvpn-cli_2
    python311Full
    qbittorrent-enhanced
    telegram-desktop
    thunderbird
    vesktop
    vlc
    vscode
    wget
    winetricks
    wineWowPackages.stagingFull
    xfce.xfce4-power-manager
    xorg.xev
  ];

  fonts = {
    packages = with pkgs; [
      font-awesome
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
    defaultEditor = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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

  # Set up xdg-portals for Flatpak:
  xdg.portal = {
    enable = true;
    #wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [
          "gtk"
        ];
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

  services.picom = {
    enable = true;
    fade = true;
    vSync = true;
#    shadow = true;
    fadeDelta = 4 ;
    inactiveOpacity = 0.8;
    activeOpacity = 1;
    backend = "xrender";
    settings = {
      blur = {
	#method = "dual_kawase";
#	background = true;
	strength = 5;
      };
      corner-radius = 10;
    };
  };

  nix.settings = {
  substituters = [
    "https://cuda-maintainers.cachix.org"
  ];
  trusted-public-keys = [
    "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
  ];
};

  nix.settings.auto-optimise-store = true;

  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.channel.enable = false;

  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
  nix.settings.nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
}


# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{inputs, config, pkgs, callPackage, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia.nix
      ./prism.nix
    ];
  
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  environment.pathsToLink = [ "/libexec" ];

  # Disable Fn Lock on boot (for external KB).
  boot.extraModprobeConfig = "options hid_apple fnmode = 0";
  
  # Bluetooth turn-on.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  networking.hostName = "nixos"; # Define your hostname.
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
  
 # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    dpi = 150;
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    windowManager.i3.enable = true;
  };
  services.displayManager = {
    defaultSession = "xfce+i3";
  };

  environment.xfce.excludePackages = with pkgs; [
    xfce.exo
    xfce.garcon
    xfce.libxfce4ui

    xfce.mousepad
    xfce.parole
    xfce.ristretto
    xfce.xfce4-appfinder
    xfce.xfce4-screenshooter
    xfce.xfce4-session
    xfce.xfce4-settings
    xfce.xfce4-taskmanager
    xfce.xfce4-terminal
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us, ru";
    variant = "";
    options = "grp:win_space_toggle";
  };
  
   # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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
    btrfs-assistant
    blueman
    flameshot
    floorp
    flatpak
    file-roller
    git
    gnumake
    lutris
    nitrogen
    vesktop
    vlc
    wget
    winetricks
    wineWowPackages.stagingFull
    xorg.xev
  ];

  fonts = {
    packages = with pkgs; [
      font-awesome
      iosevka
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
  };

  # Set up xdg-portals for Flatpak:
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-xapp
    ];
    config = {
      common = {
        default = [
          "gtk"
          "xapp"
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
    vSync = false;
#    shadow = true;
    fadeDelta = 4 ;
    inactiveOpacity = 0.8;
    activeOpacity = 1;
    backend = "glx";
    settings = {
      blur = {
	#method = "dual_kawase";
#	background = true;
	strength = 5;
      };
      corner-radius = 10;
    };
  };
}


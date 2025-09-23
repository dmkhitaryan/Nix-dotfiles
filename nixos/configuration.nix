{lib, config, pkgs, callPackage, ... }:
let
  sources = import ../npins;

  flake-compat = import sources.flake-compat;

  aagl = import sources.aagl-gtk-on-nix.outPath;
  zen = import sources.zen-browser-flake.outPath {
    inherit pkgs;
  };
  emacs-overlay = import sources.emacs-overlay;

  listentui_flake = flake-compat.lib.fromFlake { src = sources.listentui; } { nixpkgs =  sources.nixpkgs; };
  listentui = listentui_flake.packages.${pkgs.system}.default;
in
{
  nixpkgs.pkgs = import sources.nixpkgs { config.allowUnfree = true; };
  nixpkgs.overlays = [
    emacs-overlay
  ];

  _module.args = {
    inherit zen emacs-overlay listentui;
  };

  imports = [ 
    aagl.module
    (import "${sources.home-manager}/nixos")
    (import "${sources.nixos-hardware}/lenovo/legion/16achg6/nvidia")
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ./pkgs.nix
    ./misc.nix # Nix-specific configuration.
    #./mwc/mwc.nix # Currently borked on unstable branch due to updating scenefx: 0.2.1 -> 0.4.1
    ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  #home-manager.extraSpecialArgs
  home-manager.users.necoarc = { 
    imports = [
      ../home-manager/home.nix
    ];
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
              command = ''${pkgs.tuigreet}/bin/tuigreet --cmd niri-session'';
              user = "greeter";
          };
      };
    };
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    logind.settings.Login.HandleLidSwitchExternalPower = "ignore";

    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    }; 
    
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
    anime-game-launcher.enable = true;
    dconf.enable = true;
    direnv.enable = true;

    foot = {
      enable = true;
      settings = {
        main = {
          font="Iosevka:size=12";
        };
      };
      theme = "rose-pine-moon";
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry.curses;
    };

    honkers-railway-launcher.enable = true;
    nh.enable = true;
    niri.enable = true;
    mtr.enable = true;
   # mwc.enable = true;

    obs-studio = {
      enable = true;
      package = (
        pkgs.obs-studio.override {
          cudaSupport = true;
        }
      );
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
    kernel.sysctl."kernel.sysrq" = 1; 

    # Bootloader.
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };

    plymouth.enable = true;
    extraModprobeConfig = ''
      options hid_apple fnmode=0 
    ''; # Disable Fn Lock on boot (for external KB).
  };
  
  # Bluetooth turn-on.
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    nvidia-container-toolkit.enable = true;
  };

  # Networking settings.
  networking = {
    dhcpcd.wait = "if-carrier-up"; # shaves off seconds during boot by removing wait.
    hostName = "necoarc";
    enableIPv6 = false;
  
    # Enable wireless networking using iwd.
    wireless.iwd = {
      enable = true;
      settings =  {
        General = {
          EnableNetworkConfiguration = true;
          AddressRandomization = true;
        };
        Settings = {
          AutoConnect = true;
          AlwaysRandomizeAddress = true;
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

    extraLocales = [
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
  
  system.stateVersion = "24.11";
  system.userActivationScripts.regenerateTofiCache = {
    text = 
    ''
      tofi_cache="$HOME/.cache/tofi-drun"
      [[ -f "$tofi_cache" ]] && rm "$tofi_cache"
    '';
  };
  
}


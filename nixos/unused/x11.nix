{config, pkgs, lib, ... }:
  {
  # Enable the X11 windowing system (i3).
  services = {
    xserver = {
      enable = true;
      # desktopManager = {
      #   runXdgAutostartIfNone = true;
      #   xterm.enable = false;
      # };
      displayManager = {
          sessionCommands = ''
          ${pkgs.xorg.xrdb}/bin/xrdb -merge <${pkgs.writeText "Xresources" ''
          Xft.dpi: 96
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

   environment.pathsToLink = [ "/libexec" ]; # from i3 wiki.
  security.pam.services.lightdm.enableGnomeKeyring = true; # if using lightdm again.

#     services.picom = {
#     enable = true;
#     fade = true;
#     vSync = true;
# #    shadow = true;
#     fadeDelta = 4 ;
#     inactiveOpacity = 0.8;
#     activeOpacity = 1;
#     backend = "xrender";
#     settings = {
#       blur = {
# 	#method = "dual_kawase";
# #	background = true;
# 	strength = 5;
#       };
#       corner-radius = 10;
#     };
#   };

  services = {
    gvfs.enable = true;
  };
  programs.thunar.enable = true;


  environment.systemPackages = with pkgs; [ #Xorg packages.
    autotiling # i3
    flameshot
    nitrogen
    x11docker
    xfce.xfce4-power-manager
    xorg.xev
  ];

  # security.pam.services.greetd.enableGnomeKeyring = true;
  # security.pam.services.swaylock = {};
  }

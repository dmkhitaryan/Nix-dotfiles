{config, pkgs, lib, ... }:
# let
#   sessionPackagesPath = "${toString config.services.displayManager.sessionData.desktops}/share/xsessions:${toString config.services.xserver.displayManager.sessionData.desktops}/share/wayland-sessions";
# in
 {
  
  #  programs.sway = {
  #    enable = true;
  #    wrapperFeatures.gtk = true;
  #    extraOptions = [ "--unsupported-gpu" ];
  #     extraSessionCommands = ''
  #       export SDL_VIDEODRIVER=wayland
  #       export QT_QPA_PLATFORM=wayland
  #       export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
  #       export QT_AUTO_SCREEN_SCALE_FACTOR=0
  #       export QT_FONT_DPI=144
  #       export GDK_DPI_SCALE=1.5
  #       # export XDG_CURRENT_DESKTOP=sway
  #       # export XDG_SESSION_DESKTOP=sway
  #       # export XDG_SESSION_TYPE=wayland
  #       export _JAVA_AWT_WM_NONREPARENTING=1
  #   '';
  #  };

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
    autotiling-rs # sway
    flameshot
    nitrogen
    x11docker
    xfce.xfce4-power-manager
    xorg.xev
  ];

  # security.pam.services.greetd.enableGnomeKeyring = true;
  # security.pam.services.swaylock = {};
}

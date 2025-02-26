{config, pkgs, lib, ... }:
{
  # security.polkit.enable = true;
  # services.gnome.gnome-keyring.enable = true;
  # programs.dconf.enable = true;
  
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
    # extraOptions = [ "--unsupported-gpu" ];
    # extraSessionCommands = ''
    #   export SDL_VIDEODRIVER=wayland
    #   export QT_QPA_PLATFORM=wayland
    #   export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    #   export QT_AUTO_SCREEN_SCALE_FACTOR=0
    #   export QT_FONT_DPI=144
    #   export GDK_DPI_SCALE=1.5
    #   export XDG_SESSION_DESKTOP=sway
    #   export _JAVA_AWT_WM_NONREPARENTING=1
    # '';
  };

  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };

  services.greetd = {
    enable = true;
    settings = {
        default_session = {
            command = ''
            ${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd "sway"
            '';
            user = "greeter";
        };
    };
  };

  environment.systemPackages = with pkgs; [
    grim
    mako
    shared-mime-info
    slurp
    tofi
    waybar
    wl-clipboard
  ];

  # security.pam.services.greetd.enableGnomeKeyring = true;
  # security.pam.services.swaylock = {};

}
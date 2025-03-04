{config, pkgs, lib, ... }:
let
  sessionFile = pkgs.writeText "tuigreet-sessions" ''
    niri-session
    mwc
  '';
in
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

  # systemd.user.services.kanshi = {
  #   description = "kanshi daemon";
  #   serviceConfig = {
  #       Type = "simple";
  #       ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
  #   };
  # };
  
  services.greetd = {
    enable = true;
    settings = {
        default_session = {
            command = ''
            ${pkgs.greetd.tuigreet}/bin/tuigreet --time --sessions ${sessionFile}
            '';
            user = "greeter";
        };
    };
  };

  environment.systemPackages = with pkgs; [
    alacritty
    fuzzel
    grim
    shared-mime-info
    slurp
    wofi
    wl-clipboard
  ];

  # security.pam.services.greetd.enableGnomeKeyring = true;
  # security.pam.services.swaylock = {};
}
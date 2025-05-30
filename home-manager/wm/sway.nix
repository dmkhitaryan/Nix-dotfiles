{ config, pkgs, lib, ... }:
let
  sway-dbus-startup = pkgs.writeTextFile {
    name = "dbus-sway";
    executable = true;
    text = ''
      # exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      # systemctl --user import-environment
      # systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      # systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      # exec systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
      # exec hash dbus-update-activation-environment 2>/dev/null && \
      # dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
    '';
  };
in
{ # TODO: Adjust packages to better reflect the currently used ones.
  wayland.windowManager.sway = {
    enable = true;
    package = null;

    config = rec {
      modifier = "Mod4";

      output = {
        "*" = {
          bg = "/home/necoarc/yokune_ruko2.png fill";
        }; 
      };

      fonts = {
        names = [ "Iosevka Extended" ];
        style = "Bold";
        size = 10.0;
      };

      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in lib.mkOptionDefault {
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
          "XF86AudioMute" = "exec wpctl set-mute";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioPause" = "exec playerctl play-pause";
          "XF86AudioPrev" = "exec playerctl previous";
          "XF86AudioNext" = "exec playerctl next";
          "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";

          "${modifier}+Return" = "exec kitty";
          "${modifier}+e" = "exec thunar";
          "${modifier}+Shift+s" = "exec /run/current-system/sw/bin/flameshot gui";

          "${modifier}+d" = "exec tofi-run | xargs swaymsg exec --";
          "${modifier}+Shift+d" = "exec tofi-drun | xargs swaymsg exec --";
        };

      gaps = {
        smartGaps = true;
        smartBorders = "on";
        inner = 5;
        outer = 5;
      };

      startup = [
      #  { command = "${sway-dbus-startup}"; }
        { command = "vesktop"; }
        { command = "nm-applet"; }
        { command = "autotiling-rs"; }
      ];
    };

      extraConfig = ''
      include /home/necoarc/dotfiles/nixos.conf
      output * scale 1.15
      '';
    systemd.xdgAutostart = true;
  };

}
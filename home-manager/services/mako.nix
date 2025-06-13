{ config, pkgs, lib, ... }:
{
  services = {
    dunst = { # for X11.
      enable = false;

      settings = {
        global = {
          origin = "top-right";
          scale = 0;
          transparency = 15;
          frame_color = "#DF3B86";
          height = "(40, 300)";
          width = "(200, 300)";
          background = "#302239";
          format = "<b>%a</b>\n%I%b";
          alignment = "left";
          vertical_alignment = "top";

          max_icon_size = 36;
        };   
      };
    };
    mako = { # for Wayland.
      enable = true;
      settings = {
        background-color = "#302239";
        border-color = "#DF3B86";
        # borderRaius = 10;
        default-timeout = 5000;
        font = "Iosevka Extended 10";
        height = 100;
        ignore-timeout = true;
        layer = "overlay";
        max-visible = 3;
        width = 300;
      };
    };
  };
}
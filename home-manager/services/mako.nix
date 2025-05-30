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

      backgroundColor = "#302239";
      borderColor = "#DF3B86";
      # borderRaius = 10;
      defaultTimeout = 5000;
      font = "Iosevka Extended 10";
      height = 100;
      ignoreTimeout = true;
      layer = "overlay";
      maxVisible = 3;
      width = 300;
    };
  };
}
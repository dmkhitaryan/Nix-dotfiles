{ config, pkgs, lib, ... }:
{
  services.kanshi = {
    enable = true;
    settings = [
      { profile.name = "solo";
        profile.outputs = [
          {
            criteria = "eDP-1";
            mode = "2560x1600@60.008";
            scale = 1.25;
          }
        ];
      }
      { profile.name = "extended";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "*";
            mode = "1920x1080@60.000";
            scale = 1.00;
            position = "0,0";
          }
        ];
      }

      { profile.name = "solo-x11";
        profile.outputs = [
          {
            criteria = "eDP";
            mode = "2560x1600@60.008";
            scale = 1.25;
          }
        ];
      }
      { profile.name = "extended-x11";
        profile.outputs = [
          {
            criteria = "eDP";
            status = "disable";
          }
          {
            criteria = "*";
            mode = "1920x1080@60.000";
            scale = 1.00;
            position = "0,0";
          }
        ];
      }
    ];

    systemdTarget = "graphical-session.target";
  };
}
{ config, pkgs, lib, ... }:
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };

    settings = {
      main = {
        layer = "top";
        position = "top";
        height = 30;

        output = [ "*" ];

        modules-left = [ "niri/workspaces" "group/volume" ];
        modules-center = [ "niri/window" ];
        modules-right = ["clock" "tray"];

        "tray" = {
          icon-size = 24;
          spacing = 5;
        };

        "clock" = {
          format = "{:%H:%M}  ";
          format-alt = " {:%A, %B %d, %Y}  ";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months =     "<span color='#ffead3'><b>{}</b></span>";
              days =       "<span color='#ecc6d9'><b>{}</b></span>";
              weeks =     "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays =   "<span color='#ffcc66'><b>{}</b></span>";
              today =      "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions =  {
            on-click-right = "mode";
           # on-scroll-up = "tz_up";
           # on-scroll-down = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        "cava" = {
          framerate = 30;
          autosens = 1;
          bars = 14;
          lower_cutoff_freq = 50;
          higher_cutoff_freq = 10000;
          method = "pipewire";
          stereo = true;
          reverse = false;
          bar_delimiter = 0;
          monstercat = false;
          waves = false;
          noise_reduction = 0.77;
          input_delay = 2;
          format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
          actions = {
                    on-click-right = "mode";
                    };
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-muted = "";
          format-icons = ["" ""];
          scroll-step = 5;
          on-click-right = "pavucontrol";
        };

        "group/volume" = {
          orientation = "horizontal";
          modules = [ "cava" "pulseaudio" ]; #cava
        };
      };

    };

    style = ''
        window#waybar {
          background-color: #433052;
          color: #ffffff;
        }

        window#waybar.hidden {
            opacity: 0.2;
        }

        #workspaces {
          margin: 0 10 0 0; 
        }

        #workspaces button {
          background-color: #882452;
          border: none;
          border-radius: 0;
          margin: -5 0 -5 0;
        }

        #workspaces button.focused {
          background-color: #DF3B86;
          border: none;
          border-radius: 0;
        }

        #workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
        }

        #clock {
          margin: 0 15 0 15;
        }

        #tray {
          margin: 0 0 0 10;
          padding: 0 10 0 10;
          background: #882452;
        }

        #volume {
          font-family: font-awesome;
          margin: -3 10 -3 10;
          background: #882452;
          border-radius: 20;
        }

        #volume label#cava {
          color: rgba(0, 0, 0, 0.3);
          margin: 0 5 0 0;
          padding: 0 0 0 10;
        }

        #volume label#pulseaudio {
          color:  #FFFFFF;
          margin: 0 0 0 5;
          padding: 0 15 0 0;

        }

        #clock {
          margin: -3 10 -3 0;
          background: #882452;
          border-radius: 20;
          padding: 0 10 0 10;
        }


    '';
  };
}
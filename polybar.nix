{pkgs, ...}:
  let
    colors = rec {
        background = "#F5F5DC";
        foreground = "#5C4033";
        linecolor = "#fb2e22";
        bordercolor = "#555555";
        accent = "#e60053";
      };
  in
{
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
      i3Support = true;
      alsaSupport = true;
      pulseSupport = true;
      };
      script = ''polybar --reload top &'';
      #extraConfig = builtins.readFile ./i3/polybar;
      config = {
        "bar/top" = {
          monitor = "\${env:MONITOR:eDP}";
          width = "100%";
          height = 40;
          radius = 0;
          background = "${colors.background}";
          foreground = "${colors.foreground}";

          underline-color = "${colors.linecolor}";
          underline-size = 1;
          overline-color = "${colors.linecolor}";
          overline-size = 2;

          #border-bottom-size = 1;
          #border-bottom-color = "${colors.bordercolor}";
          #padding-top = 2;
          #padding-bottom = 2;
          padding-left = 0;
          padding-right = 2;
          module-margin-left = 1;
          module-margin-right = 1;

          font-0 = "Iosevka Extended:style:Heavy:pixelsize=16;2";
          font-1 = "0xProto Nerd Font:style=Regular:size=16;2";
          modules-left = "i3";
          modules-center = "xwindow";
          modules-right = "alsa wifi battery filesystem cpu date tray";
        };

        "module/tray" = {
          type = "internal/tray";
          tray-spacing = 4;
          tray-size = "80%";
        };

        "module/alsa" = {
          type = "internal/alsa";
          use-ui-max = true;
          interval = 5;

          master-soundcard = "hw:2,0";
          master-mixer = "PCM";

          #speaker-mixer = "Speaker";
          #headphone-mixer = "Headphone";
          mapped = true;
  
          format-volume = "<label-volume> <bar-volume>";
          label-volume = "Vol: %percentage%%";
          label-muted = " ";
          label-muted-foreground = "#666";

          bar-volume-width = 10;
          bar-volume-foreground-0 = "#55aa55";
          bar-volume-foreground-1 = "#ABF574";
          bar-volume-foreground-2 = "#f5a70a";
          bar-volume-foreground-3 = "#FF8500";
          bar-volume-foreground-4 = "#FF5637";
          bar-volume-foreground-5 = "#ff5555";
          bar-volume-gradient = true;
          bar-volume-indicator = "  ";
          bar-volume-fill = "┃"; 
          bar-volume-fill-font = 2; 
          bar-volume-empty = "┃"; 
          bar-volume-empty-font = 2;
          bar-volume-empty-foreground = "${colors.foreground}"; 
          click-right = "/run/current-system/sw/bin/pavucontrol &";
           
        };

        "module/date" = {
          type = "internal/date";
          internal = 5;
          date = "%d/%m/%y";
          time = "%H:%M";
          label = " : %time%  󰃭 : %date%";
        };

        "module/filesystem" = {
          type = "internal/fs";  
          interval = 15; 
          mount-0 = "/"; 
          fixed-values = true;
          spacing = 4;
          warn-percentage = 80;

          format-mounted = "<label-mounted>";  
          format-unmounted = "<label-unmounted>"; 
        
          label-mounted = "%mountpoint%: %free% of %total%";
          label-unmounted = "%mountpoint%: not mounted";
          label-mounted-foreground = "${colors.foreground}"; 
          label-unmounted-foreground = "#55";
        };

        "module/xwindow" = {
          type = "internal/xwindow";
          format = "<label>";
          format-background = "#DF3B86";
          format-foreground = "${colors.foreground}";
          format-padding = 2;

          label = "%class%";
          label-maxlen = 25;

          label-empty = "  ";
          label-empty-foreground = "${colors.foreground}";
        };

        "module/i3" = {
          type = "internal/i3";
          index-sort = true;
          pin-workspaces = true;
          wrapping-scroll = true;
          strip-wsnumbers = true;

          ws-icon-0 = "1;ᚋ";
          ws-icon-1 = "2;ᚌ";
          ws-icon-2 = "3;ᚍ";
          ws-icon-3 = "4;ᚎ";
          ws-icon-4 = "5;ᚏ"; 

          format = "<label-state> <label-mode>";

          label-mode = "%mode%";
          label-mode-padding = 2;
          label-mode-background = "#e60053";

          label-focused = "%name%";
          label-focused-foreground = "#ffffff";
          label-focused-background = "#DF3B86";
          label-focused-underline = "#fba922";
          label-focused-padding = 4;

          label-unfocused = "%index%";
          label-unfocused-foreground = "#ffffff";
          label-unfocused-background = "#882452";
          label-unfocused-padding = 4;

          label-visible = "%index%";
          label-visible-underline = "#555555";
          label-visible-padding = 4;

          label-urgent = "%index%";
          label-urgent-foreground = "#000000";
          label-urgent-background = "#bd2c40";
          label-urgent-padding = 4;

          label-separator = "|";
          label-separator-padding = 1;
          label-separator-foreground = "${colors.foreground}";
        };

        "module/cpu" = {
          type = "internal/cpu";
          interval = 2;
          label = "󰘚 %percentage%%";
          #format-prefix-foreground 
        };

      };
    };
}
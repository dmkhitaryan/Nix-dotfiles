{ inputs, config, pkgs, lib, ... }:

let 
  kittyConfig = import ./kitty.nix { inherit pkgs; };
  stylesConfig = import ./styles.nix { inherit pkgs; };
  polybarConfig = import ./polybar.nix { inherit pkgs; };

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
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  
  home.username = "necoarc";
  home.homeDirectory = "/home/necoarc";
  
  imports = [ 
    kittyConfig 
    stylesConfig
    polybarConfig 
  ];

  #xdg.configFile."i3/config".source = config.lib.file.mkOutOfStoreSymlink "/home/necoarc/dotfiles/i3/config"; 
  #xdg.configFile."sway/config".source = config.lib.file.mkOutOfStoreSymlink "/home/necoarc/dotfiles/sway/sway.conf";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    xwayland-satellite
    
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
      
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/necoarc/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # XDG_ICON_THEME = "Tela-purple-dark";
    # EDITOR = "emacs";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      nrf = "sudo nixos-rebuild switch --flake /home/necoarc/dotfiles#necoarc";
      ncg = "sudo nix-collect-garbage";
      ncgd = "sudo nix-collect-garbage -d";
    };
  };
  services = {
    dunst = {
      enable = true;

      settings = {
        global = {
          origin = "top-right";
          scale = 3;
          transparency = 15;
          frame_color = "#DF3B86";
          height = "(40, 300)";
          width = "(225, 300)";
          background = "#302239";
          format = "<b>%a</b>\n%I%b";
          alignment = "left";
          vertical_alignment = "top";

          max_icon_size = 36;
        };   
      };
    };
  };

  # wayland.windowManager.sway = {
  #   enable = true;
  #   package = null;

  #   config = rec {
  #     modifier = "Mod4";

  #     output = {
  #       "*" = {
  #         bg = "/home/necoarc/yokune_ruko2.png fill";
  #       }; 
  #     };

  #     fonts = {
  #       names = [ "Iosevka Extended" ];
  #       style = "Bold";
  #       size = 10.0;
  #     };

  #     keybindings =
  #       let
  #         modifier = config.wayland.windowManager.sway.config.modifier;
  #       in lib.mkOptionDefault {
  #         "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
  #         "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
  #         "XF86AudioMute" = "exec wpctl set-mute";
  #         "XF86AudioPlay" = "exec playerctl play-pause";
  #         "XF86AudioPause" = "exec playerctl play-pause";
  #         "XF86AudioPrev" = "exec playerctl previous";
  #         "XF86AudioNext" = "exec playerctl next";
  #         "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
  #         "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";

  #         "${modifier}+Return" = "exec kitty";
  #         "${modifier}+e" = "exec thunar";
  #         "${modifier}+Shift+s" = "exec /run/current-system/sw/bin/flameshot gui";

  #         "${modifier}+d" = "exec tofi-run | xargs swaymsg exec --";
  #         "${modifier}+Shift+d" = "exec tofi-drun | xargs swaymsg exec --";
  #       };

  #     gaps = {
  #       smartGaps = true;
  #       smartBorders = "on";
  #       inner = 5;
  #       outer = 5;
  #     };

  #     startup = [
  #     #  { command = "${sway-dbus-startup}"; }
  #       { command = "vesktop"; }
  #       { command = "nm-applet"; }
  #       { command = "autotiling-rs"; }
  #     ];
  #   };

  #    extraConfig = ''
  #     include /home/necoarc/dotfiles/nixos.conf
  #     output * scale 1.15
  #    '';
  #   systemd.xdgAutostart = true;
  # };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };

    settings = {
      # workspaces = {
      #   layer = "top";
      #   position = "right";
      #   height = 10;
      #   width = 10;

      #   output = [ "eDP-1" ];

      #   modules-center = [ "niri/workspaces" ];
      # };

      main = {
        layer = "top";
        position = "top";
        height = 30;

        output = [ "eDP-1" ];

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
        };

        "group/volume" = {
          orientation = "horizontal";
          modules = [ "cava" "pulseaudio" ];
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

  programs.tofi = {
    enable = true;
     settings = {
        scale = false;
    #   background-color = "#433052";
    #   text-color = "#FFFFFF";
    #   selection-color = "DF3B86";
    #   border-width = 1;
    #   border-color = "#DF3B86";
    #   font = "Iosevka";
    #   num-results = 5;
    #   font-size = 6;
    #   width = 2560;
    #   height = 30;
    #   anchor = "top";
     };
  };

  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "Xwayland outside your Wayland";
      BindsTo = "graphical-session.target";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      Requisite = "graphical-session.target";
    };

    Service = {
      Type = "notify";
      NotifyAccess = "all";
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      StandardOutput = "journal";
    };

    Install.WantedBy = [ "niri.service" ];
  };

  systemd.user.services.swaybg = {
    Unit = {
      Description = "Sets up backgrounds in Wayland";
      BindsTo = "graphical-session.target";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      Requisite = "graphical-session.target";
    };

    Service = {
      ExecStart = ''${pkgs.swaybg}/bin/swaybg -m fill -i "/home/necoarc/yokune_ruko2.png"'';
      Restart = "on-failure";
      StandardOutput = "journal";
    };

    Install.WantedBy = [ "niri.service" ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

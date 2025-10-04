{ config, pkgs, ... }:
let
  display = status: "${pkgs.niri}/bin/niri msg action-power-${status}-monitors";
  lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
in
{
  services = {
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 1800;
          command = "${pkgs.libnotify}/bin/notify-send 'Locking in 1 minute' -t 5000";
        }
        {
          timeout = 1860;
          command = lock;
        }
        {
          timeout = 1870;
          command = display "off";
          resumeCommand = display "on";
        }
        {
          timeout = 5400;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];

      events = [
        {
          event = "before-sleep";
          command = (display "off") + ";" + lock;
        }
        {
          event = "after-resume";
          command = display "on";
        }
        {
          event = "lock";
          command = (display "off") + ";" + lock;
        }
        {
          event = "unlock";
          command = display "on";
        }
      ];
    };
  };
}
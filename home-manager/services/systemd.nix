{ config, pkgs, lib, ... }:
{
  systemd.user.services = {
    xwayland-satellite = {
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

    swaybg = {
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
  };
}
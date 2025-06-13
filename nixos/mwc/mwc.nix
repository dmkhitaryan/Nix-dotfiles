{
  config,
  lib,
  pkgs,
  ...
}:

let
  mwc = pkgs.callPackage ./package.nix { };
  cfg = config.programs.mwc;
in
{
  options.programs.mwc = {
    enable = lib.mkEnableOption "mwc tiling wayland compositor";

    package = lib.mkOption {
      type = lib.types.package;
      default = mwc;
    };

    configFile = {
      default = null;
      type = with lib.types; nullOr path;
    };

    extraPackages = lib.mkOption {
      type = with lib.types; listOf package;
      default = with pkgs; [
        kitty
        rofi
      ];
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment = {
          # etc."mwc/config" = lib.mkIf (cfg.configFile != null) {
          #   source = cfg.configFile;
          # };
          systemPackages = [ cfg.package ] ++ cfg.extraPackages;
        };

        services = {
          displayManager.sessionPackages = [ cfg.package ];
          xserver.desktopManager.runXdgAutostartIfNone = lib.mkDefault true;
        };
        systemd.packages = [ cfg.package ];

        xdg.portal = {
          enable = lib.mkDefault true;
          wlr.enable = lib.mkDefault true;
          configPackages = [ cfg.package ];
          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        };

        programs.dconf.enable = lib.mkDefault true;

      }
    ]
  );
}
{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    (
      emacsWithPackagesFromUsePackage {

        defaultInitFile = false;
        config = ./emacs.el;
        alwaysEnsure = true;
      }
    )
  ];
  services.emacs = {
    enable = true;
    client.enable = true;
    package = pkgs.emacs-unstable-pgtk;
  };

  # xdg.configFile."emacs/" = {
  #   source = config.lib.file.mkOutOfStoreSymlink "./init.el";
  # };
}
# configuration.nix
{ config, pkgs, ... }:
let
  aagl = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
  # Or, if you follow Nixpkgs release 24.11:
  # aagl = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/release-24.11.tar.gz");
in
{
  imports = [
    aagl.module
  ];

  nix.settings = aagl.nixConfig; # Set up Cachix
  #programs.anime-game-launcher.enable = true;
  #programs.anime-games-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
  #programs.honkers-launcher.enable = true;
  #programs.wavey-launcher.enable = true;
  #programs.sleepy-launcher.enable = true;
}

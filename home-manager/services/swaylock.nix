{ config, pkgs, ... }:
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      clock = true;
      effect-blur = "5x2";
      font-size = 32;
      ignore-empty-password = true;
      image = "${config.home.homeDirectory}/dotfiles/home-manager/lock_image.jpg";
      indicator = true;
    };
  };
}
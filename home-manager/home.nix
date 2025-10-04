{ config, pkgs, lib, ... }:
{
  home.username = "necoarc";
  home.homeDirectory = "/home/necoarc";
  
  imports = [ 
    ./appearance/styles.nix
    ./appearance/waybar.nix

    ./services/swayidle.nix
    ./services/swaylock.nix
    ./services/systemd.nix
    ./services/mako.nix
    ./services/tofi.nix

   # ./pkgs/emacs.nix
  ];
  
  #xdg.configFile."i3/config".source = config.lib.file.mkOutOfStoreSymlink "/home/necoarc/dotfiles/i3/config"; 

  home.stateVersion = "24.11"; # Please read the comment before changing.
  home.packages = [ ];
      
  home.file = { };
  home.sessionVariables = { };

  programs.bash = {
    enable = true;
    shellAliases = {
      nrf = "sudo nixos-rebuild switch -I nixos-config=${config.home.homeDirectory}/dotfiles/nixos/configuration.nix";
      nhs = "nh os switch -f '<nixpkgs/nixos>' -- -I nixos-config=${config.home.homeDirectory}/dotfiles/nixos/configuration.nix";
      ncg = "sudo nix-collect-garbage";
      ncgd = "sudo nix-collect-garbage -d";
      sus = "systemctl suspend";
    };
  };

  programs.floorp.enable = true;

  # home.file.".local/share/icons/ruko.png".source = ./ruko.png;
  xdg.desktopEntries.discord-canary = {
    name = "Discord Canary";
    exec = "discordcanary --wayland-text-input-version=3";
    # icon = "${config.home.homeDirectory}/.local/share/icons/ruko.png";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

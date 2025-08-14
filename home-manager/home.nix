{ inputs, config, pkgs, lib, ... }:
# let
#   qt-color-widgets = pkgs.callPackage ./package2.nix {};
#   qhotkey = pkgs.callPackage ./package3.nix {};
#   flameshot13 = pkgs.callPackage ./package.nix { inherit qt-color-widgets qhotkey; };
# in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  
  home.username = "necoarc";
  home.homeDirectory = "/home/necoarc";
  
  
  imports = [ 
  #  kittyConfig 
    ./appearance/styles.nix
    ./appearance/waybar.nix

    ./services/systemd.nix
    ./services/kanshi.nix
    ./services/mako.nix

    ./pkgs/emacs.nix
  #  polybarConfig
  ];
  
  # services.flameshot = {
  #   enable = true;
  #   package = flameshot13;
  # };
  
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
  home.packages = [
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
  home.sessionVariables = { };

  programs.bash = {
    enable = true;
    shellAliases = {
      nrf = "sudo nixos-rebuild switch --flake /home/necoarc/dotfiles#necoarc";
      ncg = "sudo nix-collect-garbage";
      ncgd = "sudo nix-collect-garbage -d";
      sus = "systemctl suspend";
    };
  };

  programs.tofi = {
    enable = true;
     settings = {
      drun-launch = true;
      scale = false;
      horizontal = true;
      result-spacing = 4;
      padding-top = 4;
      padding-bottom = 4;
      outline-width = 0;
      background-color = "#433052";
      text-color = "#FFFFFF";
      selection-color = "DF3B86";
      border-width = 1;
      border-color = "#DF3B86";
      #font = "Iosevka";
      num-results = 0;
      font-size = 10;
      width = 1920;
      height = 30;
      anchor = "top-left";
     };
  };

  home.file.".local/share/icons/hicolor/256x256/apps/ruko.png".source = ./ruko.png;
  xdg.desktopEntries.discord-canary = {
    name = "Not Discord";
    exec = "discordcanary";
    icon = "ruko";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

{ pkgs, ... }:
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-light";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita";
    };
    cursorTheme = {
      name = "BreezeX-RosePineDawn-Linux";
      package = pkgs.rose-pine-cursor;
      size = 24;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    gtk2.extraConfig = ''
      gtk-im-module="fcitx";
    '';
    gtk3.extraConfig = {
      gtk-im-module="fcitx";
    };
    gtk4.extraConfig = {
      gtk-im-module="fcitx";
    };
  };
  
  home.pointerCursor = {
    x11.enable = true;
    name = "BreezeX-RosePineDawn-Linux";
    package = pkgs.rose-pine-cursor;
    size = 24;
  };

  qt = {
    enable = true;
    style = {
      name = "adwaita";
      package = pkgs.adwaita-qt; 
    };
  };
}

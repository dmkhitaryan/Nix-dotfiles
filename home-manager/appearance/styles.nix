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
      #package = pkgs.orchis-theme;
    };
    
    cursorTheme = {
      name = "BreezeX-RosePineDawn-Linux";
      package = pkgs.rose-pine-cursor;
      size = 24;
    };
  };
  
  home.pointerCursor = {
    x11.enable = true;
    name = "BreezeX-RosePineDawn-Linux";
    package = pkgs.rose-pine-cursor;
    size = 24;
  };
}

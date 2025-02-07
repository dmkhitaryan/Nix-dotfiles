{ pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };

    iconTheme = {
      name = "Tela-purple";
      package = pkgs.tela-icon-theme;
    };
    
    cursorTheme = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 48;
    };
  };
  
  home.pointerCursor = {
    x11.enable = true;
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
    size = 48;
  };
}

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
      package = (pkgs.tela-icon-theme.overrideAttrs (oldAttrs: {
        fixupPhase = (oldAttrs.preFixup or "") + ''
          rm -rf $out/share/icons/Tela-light/24/panel/
        '';
      }));
    };
    
    cursorTheme = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 24;
    };
  };
  
  home.pointerCursor = {
    x11.enable = true;
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
    size = 24;
  };
}

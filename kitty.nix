{ pkgs, ...}:
let 
  colors = rec {
    background = "#433052";
    foreground = "#FFFFFF";
    linecolor = "#FB2E22";
    bordercolor = "#555555";
    accent = "#E60053";  
  };
  in
{
  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Extended";
      size = 12;
    };
    settings = {
      #: The basic colors
      background = "${colors.background}"; 
      foreground = "${colors.foreground}";

      # Selected Text
      selection_background = "#882452";
      selection_foreground = "#df3b86";

      #: Cursor colors
      cursor = "#df3b86";
      cursor_text_color = "#e3c714"; #000b1e

      #: URL underline color when hovering with mouse
      url_color = "#4f8ae3";


      #: kitty window border colors and terminal bell colors

      # active_border_color             #00ff00
      # inactive_border_colorrgb(43, 107, 219)
      # bell_border_color               #ff5a00
      # visual_bell_color               none


      #: OS Window titlebar colors

      # wayland_titlebar_color          system
      # macos_titlebar_color            system


      #: Tab bar colors

      # active_tab_foreground           #000
      # active_tab_background           #eee
      # inactive_tab_foreground         #444
      # inactive_tab_background         #999
      # tab_bar_background              none
      # tab_bar_margin_color            none


      #: Colors for marks (marked text in the terminal)

      # mark1_foreground black
      # mark1_background #98d3cb
      # mark2_foreground black
      # mark2_background #f2dcd3
      # mark3_foreground black
      # mark3_background #f274bc


      #: The basic 16 colors

      #: black
      color0 = "#000b1e";
      color8 = "#0E122d";

      #: red
      color1 = "#b0426e";
      color9 = "#fe5f55";

      #: green
      color2  = "#00916e";
      color10 = "#85FF9E";

      #: yellow
      color3  = "#6fcd3c";
      color11 = "#ded945";

      #: blue
      color4  = "#0072A1";
      color12 = "#465688";

      #: magenta
      color5  = "#fe67f7";
      color13 = "#ff85e6";

      #: cyan
      color6  = "#87efff";
      color14 = "#a1fcdf";

      #: white
      color7  = "#E6ABB6";
      color15 = "#caf3f3";


      #: You can set the remaining 240 colors as color16 to color255.

    };
  };
}

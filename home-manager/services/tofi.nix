{ pkgs, ... }:
{
  programs.tofi = {
    enable = true;
     settings = {
      drun-launch = true;
      scale = false;
      horizontal = true;
      result-spacing = 16;
      padding-top = 4;
      padding-bottom = 4;
      outline-width = 0;
      background-color = "#433052";
      text-color = "#FFFFFF";
      selection-color = "DF3B86";
      border-width = 1;
      border-color = "#DF3B86";
      font = "${pkgs.iosevka}/share/fonts/truetype/Iosevka-Extended.ttf";
      num-results = 12;
      font-size = 12;
      width = 1920;
      height = 30;
      anchor = "top-left";
     };
  };
}
{ lib, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      hello
    ];

  username = "necoarc";
  homeDirectory = "/home/necoarc";
  stateVersion = "24.11";
  };
}

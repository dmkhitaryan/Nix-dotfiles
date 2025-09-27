{ config, pkgs, zen, listentui, ... }:
let
  packagedRStudio = pkgs.rstudioWrapper.override { 
    packages = with pkgs.rPackages; [ 
      ggplot2 
      dplyr 
      ghql 
      jsonlite
      ]; 
    };
  pythonSystem = pkgs.python312.withPackages (ps: with ps; [
      jupyterlab
      matplotlib
      pandas
      statsmodels
      scikitlearn
    ]);
  patchedDiscord = pkgs.discord-canary.override {
      withOpenASAR = true;
      withVencord = true;
    };
in
{
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    alsa-utils
    appimage-run
    btrfs-assistant
    btop
    distrobox
    evince # Document viewer.
    file-roller
    foot
    gimp3
    git
    gparted
    gpu-screen-recorder-gtk
    grim
    helvum
    impala
    jq
    kdePackages.kdenlive
    killall
    loupe # Image viewer.
    libnotify
    lutris
    lxappearance
    nemo
    nix-prefetch-github
    npins
    packagedRStudio
    patchedDiscord
    pavucontrol
    playerctl
    prismlauncher
    protonup-qt
    pythonSystem
    r2modman
    satty
    shared-mime-info
    slurp
    steamtinkerlaunch
    swaybg
    telegram-desktop
    thunderbird
    tree
    vlc
    vscode
    wget
    winetricks
    wineWow64Packages.waylandFull
    wl-clipboard
    xwayland-satellite
    youtube-music
    yt-dlp
    zen.beta
  ];
}

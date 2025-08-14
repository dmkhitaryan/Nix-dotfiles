{ config, pkgs, inputs, ... }:
let
  packagedRStudio = pkgs.rstudioWrapper.override{ 
    packages = with pkgs.rPackages; [ 
      ggplot2 
      dplyr 
      ghql 
      jsonlite
      ]; 
    };
in
{
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    alsa-utils
    appimage-run
    btrfs-assistant
    btop
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    (discord-canary.override {
      withOpenASAR = true;
      withVencord = true;
    })
    distrobox
    evince
    file-roller
    foot
    fuzzel
    gimp3
    git
    gparted
    gpu-screen-recorder-gtk
    gnumake
    grim
    helvum
    inputs.listentui.packages.${pkgs.system}.default
    inputs.zen-browser.packages."${system}".beta
    insomnia
    jq
    kdePackages.kdenlive
    killall
    loupe
    libnotify
    lutris
    lxappearance
    nemo
    nix-prefetch-github
    nixpkgs-review
    npins
    #openutau
    packagedRStudio
    pavucontrol
    playerctl
    (prismlauncher.override {
      jdks = [
        graalvm-ce
        zulu
        zulu17
        zulu8
      ];
    })
    protonup-qt
    (python312.withPackages (ps: with ps; [
      jupyterlab
      matplotlib
      pandas
      statsmodels
      scikitlearn
    ]))
    r2modman
    satty
    shared-mime-info
    slurp
    steamtinkerlaunch
    swaybg
    telegram-desktop
    thunderbird
    vlc
    vscode
    wget
    winetricks
    wineWow64Packages.waylandFull
    wl-clipboard
    wl-gammarelay-rs
    xwayland-satellite
    youtube-music
    yt-dlp
  ];
}
{
  lib,
  fetchFromGitHub,
  stdenv,
  meson,
  ninja,
  wayland-protocols,
  wayland-scanner,
  wayland,
  libinput,
  libgbm,
  libGL,
  libdrm,
  pixman,
  pkg-config,
  libxkbcommon,
  wlroots_0_18,
  scenefx,
  mesa,
  libGLU,
  libglvnd,
  makeWrapper,
  seatd,
}:

let
  scenefx_0_2 = scenefx.overrideAttrs (finalAttrs: previousAttrs: {
    version = "0.2";
    src = fetchFromGitHub {
      inherit (previousAttrs.src) owner repo;
      rev = "refs/tags/v${finalAttrs.version}";
      hash = "sha256-kcK57JKbQ+tr0W10ipe2yGvWa9nJD+mLCMo3w2sp8AQ=";
    };

    buildInputs = [
      mesa
      libdrm
      libGL
      libglvnd
      libxkbcommon
      libgbm
      pixman
      wayland
      wayland-protocols
      wlroots_0_18
      libGLU
    ];
  }); 
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "mwc";
    version = "0.1.2";

    src = fetchFromGitHub {
      owner = "dqrk0jeste";
      repo = "mwc";
      rev = "refs/tags/v${finalAttrs.version}";
      hash = "sha256-rTI28cEQPulpku/F9NeuY9KZza89G+S1r/W3hQr3I14=";
    };

    nativeBuildInputs = [  pkg-config meson ninja wayland-scanner makeWrapper ];
    buildInputs = [ wayland-protocols wayland libinput
                    libdrm pixman libxkbcommon wlroots_0_18
                    scenefx_0_2 libglvnd seatd
                  ];

    postPatch = ''
      substituteInPlace meson.build \
        --replace "install_dir: '/usr/share/mwc'" "install_dir: get_option('datadir') / 'mwc'" \
        --replace "install_dir: '/usr/share/licenses/mwc'" "install_dir: get_option('datadir') / 'licenses/mwc'" \
        --replace "install_dir: '/usr/share/wayland-sessions'" "install_dir: get_option('datadir') / 'wayland-sessions'" \
        --replace "install_dir: '/usr/share/xdg-desktop-portal'" "install_dir: get_option('datadir') / 'xdg-desktop-portal'"
    '';

    postFixup = ''
      wrapProgram $out/bin/mwc \
        --set MWC_DEFAULT_CONFIG_PATH "$out/share/mwc/default.conf"
    '';

    # postInstall = ''
    #   install ./mwc.desktop -t $out/share/wayland-sessions
    # '';

    meta = {
      homepage = "https://github.com/dqrk0jeste/mwc";
      description = "A tiling Wayland compositor based on wlroots and scenefx.";
      changelog = "https://github.com/dqrk0jeste/mwc/releases/tag/v${finalAttrs.version}";
      mainProgram = "mwc";

      license = lib.licenses.mit;
      platform = lib.platforms.linux;
      maintainers = with lib.maintainers; [ ];
    };

  })
# package.nix | Packaging for 'mwc'.
{
  fetchFromGitHub,
  lib,
  libdrm,
  libinput,
  libGL,
  libxcb,
  libxkbcommon,
  makeWrapper,
  meson,
  ninja,
  pipewire, # not actually needed, was just testing stuff.
  pixman,
  pkg-config,
  scenefx,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots_0_18,
}:

  stdenv.mkDerivation (finalAttrs: {
    pname = "mwc";
    version = "0.1.2";

    src = fetchFromGitHub {
      owner = "dqrk0jeste";
      repo = "mwc";
      rev = "refs/tags/v${finalAttrs.version}";
      hash = "sha256-DGlgeIb5C5KRoSD8YvFiwfB108dqjyW8DedApCEXKDk=";
    };

    nativeBuildInputs = [ pkg-config makeWrapper meson ninja wayland-protocols wayland-scanner ];
    buildInputs = [ libdrm libGL libinput libxcb libxkbcommon pipewire pixman scenefx wayland wlroots_0_18 ];

    # Resolve the use of harcoded paths that are inaccessible in NixOS via
    # extraciton of the actual directories built by the package on NixOS.
    postPatch = ''
      substituteInPlace meson.build \
        --replace "install_dir: '/usr/share/mwc'" "install_dir: get_option('datadir') / 'mwc'" \
        --replace "install_dir: '/usr/share/licenses/mwc'" "install_dir: get_option('datadir') / 'licenses/mwc'" \
        --replace "install_dir: '/usr/share/wayland-sessions'" "install_dir: get_option('datadir') / 'wayland-sessions'" \
        --replace "install_dir: '/usr/share/xdg-desktop-portal'" "install_dir: get_option('datadir') / 'xdg-desktop-portal'"
    '';

    # Sets the default config file as ... the 'default'. 
    # Otherwise, wouldn't let the launch proceed properly.
    postFixup = ''
      wrapProgram $out/bin/mwc \
        --set MWC_DEFAULT_CONFIG_PATH "$out/share/mwc/default.conf"
    '';

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
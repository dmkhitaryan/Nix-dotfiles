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
    version = "0.1.3";

    src = fetchFromGitHub {
      owner = "dqrk0jeste";
      repo = "mwc";
      rev = "refs/tags/v${finalAttrs.version}";
      hash = "sha256-O/lFdkfAPC9CSXUkDiAEPWwcfdBUZXXNEEXmSriGzB0=";
    };

    nativeBuildInputs = [ scenefx pkg-config makeWrapper meson ninja wayland-protocols wayland-scanner ];
    buildInputs = [ libdrm libGL libinput libxcb libxkbcommon pixman scenefx wayland wlroots_0_18 ];

    passthru.providedSessions = [ "mwc" ];
    # Resolve the use of harcoded paths that are inaccessible in NixOS via
    # extraciton of the actual directories built by the package on NixOS.

    # Sets the default config file as ... the 'default'. 
    # Otherwise, wouldn't let the launch proceed properly.
    # postFixup = ''
    #   wrapProgram $out/bin/mwc \
    #     --set MWC_DEFAULT_CONFIG_PATH "$out/share/mwc/default.conf"
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

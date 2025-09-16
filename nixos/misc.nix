{ config, lib, ... }:
{
  nix = {
    channel.enable = false;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than-7d";
      persistent = true;
    };

    optimise = {
      automatic = true;
      dates = [ "monthly" ];
      persistent = true;
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      #nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
      substituters = [ 
        "https://cuda-maintainers.cachix.org" 
        "https://chaotic-nyx.cachix.org/"
        "https://ezkea.cachix.org"
        "https://nix-community.cachix.org"
        "https://prismlauncher.cachix.org"
        ];
      trusted-public-keys = [ 
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c=" ];
    };
    #registry.nixpkgs.flake = inputs.nixpkgs;
  };

  environment = {
    etc = {
      #"nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
      "nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text = ''
        {
            "rules": [
                {
                    "pattern": {
                        "feature": "procname",
                        "matches": "niri"
                    },
                    "profile": "Limit Free Buffer Pool On Wayland Compositors"
                }
            ],
            "profiles": [
                {
                    "name": "Limit Free Buffer Pool On Wayland Compositors",
                    "settings": [
                        {
                            "key": "GLVidHeapReuseRatio",
                            "value": 0
                        }
                    ]
                }
            ]
        }
      '';
    };
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}
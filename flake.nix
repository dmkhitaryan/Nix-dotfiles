{
  description = "Home Manager configuration of necoarc";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    prismlauncher.url = "github:PrismLauncher/Prismlauncher";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    listentui.url = "github:dmkhitaryan/LISTEN.tui";
    cute-sway-recorder.url = "github:it-is-wednesday/cute-sway-recorder";
    #niri.url = "github:sodiboo/niri-flake";
  };

  outputs = { self, chaotic, nixpkgs, home-manager, prismlauncher, aagl, listentui, cute-sway-recorder, ... }@inputs: {
    nixosConfigurations = {
        necoarc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          chaotic.nixosModules.default
          
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.necoarc = { 
            imports = [
              ./home.nix
              #niri.homeModules.niri
            ];
	    };
          }

          {
            imports = [ aagl.nixosModules.default];
            nix.settings = aagl.nixConfig; 
            programs.honkers-railway-launcher.enable = true;
          }

          (
            { pkgs, ...}:
            {
              environment.systemPackages = [ prismlauncher.packages.${pkgs.system}.prismlauncher ];
            }
          )
        ];
      };
    };
  };
}

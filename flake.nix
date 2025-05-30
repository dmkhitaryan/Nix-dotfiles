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

    
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    cute-sway-recorder.url = "github:it-is-wednesday/cute-sway-recorder";
    listentui.url = "github:dmkhitaryan/LISTEN.tui";
    prismlauncher.url = "github:PrismLauncher/Prismlauncher";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
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
              ./home/home.nix
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

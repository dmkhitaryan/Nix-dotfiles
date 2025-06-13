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
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    #niri.url = "github:sodiboo/niri-flake";
  };

  outputs = { chaotic, nixpkgs, home-manager, aagl, listentui, cute-sway-recorder, ... }@inputs: {
    nixosConfigurations = {
        necoarc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        
        modules = [
          ./nixos/configuration.nix
          aagl.nixosModules.default
          chaotic.nixosModules.default
          nix-flatpak.nixosModules.nix-flatpak

          {
            nix.settings = aagl.nixConfig; 
            programs.honkers-railway-launcher.enable = true;
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.necoarc = { 
            imports = [
              ./home-manager/home.nix
              #niri.homeModules.niri
            ];
	    };
          }
        ];
      };
    };
  };
}

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

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
    };

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    listentui.url = "github:dmkhitaryan/LISTEN.tui";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    #niri.url = "github:sodiboo/niri-flake";
  };

  outputs = { self, chaotic, nixpkgs, home-manager, aagl, listentui, nix-flatpak, nixos-hardware, emacs-overlay, ... }@inputs: {
    nixosConfigurations = {
        necoarc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        
        modules = [
          {
            nixpkgs = {
              overlays = [ emacs-overlay.overlay ];
            };
          }

          ./nixos/configuration.nix
          nixos-hardware.nixosModules.lenovo-legion-16achg6-nvidia
          aagl.nixosModules.default
          chaotic.nixosModules.default
          nix-flatpak.nixosModules.nix-flatpak

          {
            nix.settings = aagl.nixConfig; 
            programs.honkers-railway-launcher.enable = true;
            programs.sleepy-launcher.enable = true;
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

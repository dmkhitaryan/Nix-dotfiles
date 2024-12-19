{
  description = "Home Manager configuration of necoarc";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system;};
    in {
      homeConfigurations = {
        necoarc = home-manager.lib.homeManagerConfiguration {
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
         inherit pkgs;
         modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        };
      };
    };
}

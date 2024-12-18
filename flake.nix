{
  description = "The initial Home-Manager setup";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { nixpkgs, home-manager, ... }:
    let 
      lib = nixpkgs.lib;
      system = "x86_64_linux";
      pkgs = import nixpkgs {inherit system};
    in {
      homeConfigurations = {
        necoarc = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [./home.nix];
        };
      };
    };
}

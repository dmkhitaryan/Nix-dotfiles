# /etc/nixos/flake.nix
{
  inputs = {
    # NOTE: Replace "nixos-23.11" with that which is in system.stateVersion of
    # configuration.nix. You can also use latter versions if you wish to
    # upgrade.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs";
  
    prismlauncher.url = "github:PrismLauncher/Prismlauncher";
  };
  outputs = inputs@{ self, nixpkgs, aagl, nixos-hardware, prismlauncher, ... }: {
    # NOTE: 'nixos' is the default hostname set by the installer
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      # NOTE: Change this to aarch64-linux if you are on ARM
      system = "x86_64-linux";
      modules = [ 
         #nixos-hardware.nixosModules.lenovo-legion-16achg6-hybrid
         #nixos-hardware.nixosModules.lenovo-legion-16achg6-nvidia
        ./configuration.nix
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
}

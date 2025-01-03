{
  description = "sample darwin system";

  inputs = {
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
#    fenix = {
#      url = "github:nix-community/fenix";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, darwin, home-manager, fenix, nixpkgs }:
  let
    system = "aarch64-darwin";
    overlays = [ fenix.overlays.default ];

    defaultPackage.aarch64-darwin = fenix.packages.aarch64-darwin.minimal.toolchain;
    pkgs = import nixpkgs {
      inherit overlays system;
    };

  in {
    darwinConfigurations."heimdall" = darwin.lib.darwinSystem {
      inherit pkgs system;
 
      modules = [
        home-manager.darwinModules.home-manager
        ./configuration.nix
      ];
    };
  };

}

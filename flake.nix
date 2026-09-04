{
  description = "My home-manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs =
    {
      nixgl,
      nixpkgs,
      home-manager,
      self,
      ...
    }@inputs:
    let
      mkHome =
        {
          system,
          username,
          hostname,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ (import ./overlays) ];
          };
          extraSpecialArgs = { inherit inputs hostname; };
          modules = [
            ./modules/default.nix
            ./users/${username}
            ./hosts/${hostname}
          ];
        };
    in
    {
      homeConfigurations = {
        "tls123@channel-9158" = mkHome {
          system = "x86_64-linux";
          username = "tls123";
          hostname = "channel-9158";
        };
      };
    };
}

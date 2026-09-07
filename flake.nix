{
  description = "My home-manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
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
      plasma-manager,
      self,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      mkHome =
        {
          system,
          username,
          hostname,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              (import ./overlays)
              nixgl.overlay
            ];
          };
          extraSpecialArgs = { inherit inputs hostname username; };
          modules =
            (lib.optional (builtins.pathExists (./users + "/${username}")) (./users + "/${username}"))
            ++ (lib.optional (builtins.pathExists (./hosts + "/${hostname}")) (./hosts + "/${hostname}"))
            ++ lib.optional (builtins.pathExists (./users + "/${username}@${hostname}")) (
              ./users + "/${username}@${hostname}"
            )
            ++ [
              ./modules
              plasma-manager.homeModules.plasma-manager
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

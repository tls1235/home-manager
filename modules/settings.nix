{
  username,
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.configPath = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/.config/home-manager";
    description = "Directory of this flake. Also registered as `nixconfig` in the Nix registry, which nixd uses.";
  };

  config = {
    manual.json.enable = true;
    programs.home-manager.enable = true;

    home = {
      username = username;
      homeDirectory = "/home/${username}";
      stateVersion = "26.11";
    };

    nix.package = lib.mkDefault pkgs.nix;
    nix.registry.nixconfig.to = {
      type = "path";
      path = config.my.configPath;
    };
  };
}

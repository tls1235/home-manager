{ config, pkgs, ... }:
{
  imports = [
    ../../modules/nixgl.nix
  ];

  home.packages = with pkgs; [
    (config.lib.nixGL.wrap krita)
  ];

  kitty = {
    enable = true;
  };
}

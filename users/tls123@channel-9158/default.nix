{ config, pkgs, ... }:
{
  imports = [
    ../../extra/nixgl.nix
  ];

  home.packages = with pkgs; [
    # (config.lib.nixGL.wrap krita)
  ];

  kitty = {
    enable = true;
  };
}

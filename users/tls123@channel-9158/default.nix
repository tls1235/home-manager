{ config, pkgs, ... }:
{
  imports = [
  ];

  home.packages = with pkgs; [
    krita
  ];

  kitty = {
    enable = true;
  };
}

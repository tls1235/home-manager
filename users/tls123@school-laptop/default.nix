{ config, pkgs, ... }:
{
  imports = [
  ];

  home.packages = with pkgs; [
  ];

  kitty = {
    enable = true;
    height = 600;
    width = 1050;
    background_brightness = 10;
  };
}

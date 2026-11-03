{ config, pkgs, ... }:
{
  imports = [
  ];

  home.packages = with pkgs; [
  ];

  kitty = {
    enable = true;
    height = 600;
    background_brightness = 5;
  };

  easyeffects.enable = true;
}

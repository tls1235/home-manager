{ config, pkgs, ... }:
{
  imports = [
    ./uni-programs/default.nix
    ./apps/default.nix
  ];

  home = {
    username = "tls123";
    homeDirectory = "/home/tls123";
    stateVersion = "26.11";
  };

  home.packages = with pkgs; [
    statix
    nixd
    nixfmt
    zsh-forgit
    manix
  ];

  kitty = {
    wallpaper = "/home/tls123/Pictures/wallpapers/kitty-background.png";
    enable = true;
  };

  manual.json.enable = true;
  programs.home-manager.enable = true;
}

{ config, pkgs, ... }:
{
  imports = [
    ./modules/zsh.nix
    ./modules/kitty.nix
    ./nixvim.nix
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

  manual.json.enable = true;
  programs.home-manager.enable = true;
}

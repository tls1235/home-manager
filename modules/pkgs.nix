{ pkgs, ... }:
{
  home.packages = with pkgs; [
    statix
    nixd
    nixfmt
    zsh-forgit
    manix
    eza
  ];
}

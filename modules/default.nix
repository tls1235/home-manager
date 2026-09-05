{ ... }:
{
  imports = [
    ./pkgs.nix
    ./direnv.nix
    ./devenv.nix
    ./zsh.nix
    ./kitty.nix
  ];
  manual.json.enable = true;
  programs.home-manager.enable = true;
}

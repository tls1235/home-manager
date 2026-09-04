{ config, pkgs, ... }:
{
  imports = [
  ];

  home = {
    username = "tls123";
    homeDirectory = "/home/tls123";
    stateVersion = "26.11";
  };

  home.packages = with pkgs; [
    krita
  ];

  kitty = {
    enable = true;
  };

  manual.json.enable = true;
  programs.home-manager.enable = true;
}

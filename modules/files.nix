{ config, pkgs, ... }:
{
  home.file = {
    ".local/share/easyeffects".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/files/configs/.local.share.easyeffects";
    ".config/easyeffects".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/files/configs/.config.easyeffects";
  };
}

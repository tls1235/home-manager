{ config, lib, ... }:
let
  cfg = config.easyeffects;
  repo = "${config.my.configPath}/files/configs";
in
{
  options.easyeffects.enable = lib.mkEnableOption "EasyEffects config symlinks";

  config = lib.mkIf cfg.enable {
    home.file = {
      ".local/share/easyeffects".source =
        config.lib.file.mkOutOfStoreSymlink "${repo}/.local.share.easyeffects";
    };
  };
}

{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.kitty;
in
{
  options.kitty = {
    wallpaper = lib.mkOption {
      type = lib.types.str;
      default = "~/.config/home-manager/extras/default-kitty-background.png";
      description = "path to kitty wallpaper";
    };
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "whether to enable";
    };
    width = lib.mkOption {
      type = lib.types.int;
      default = 1200;
      description = "the width of the kitty terminal";
    };
    height = lib.mkOption {
      type = lib.types.int;
      default = 700;
      description = "the height of the kitty terminal";
    };
    text_size = lib.mkOption {
      type = lib.types.float;
      default = 11.0;
      description = "the size of the text of the terminal";
    };
    background_brightness = lib.mkOption {
      type = lib.types.int;
      default = 5;
      description = "how bright you want the wallpaper to be";
    };
  };

  config.programs.kitty = {
    enable = cfg.enable;
    package = null;
    font = {
      size = cfg.text_size;
      name = "JetBrainsMono Nerd Font";
    };
    settings = {
      background_image = cfg.wallpaper;
      background_image_layout = "scaled";
      background_tint = 1 - cfg.background_brightness / 100.0;
      remember_window_size = false;
      initial_window_width = cfg.width;
      initial_window_height = cfg.height;
      sync_to_monitor = false;
      repaint_delay = 8;
    };
  };
}

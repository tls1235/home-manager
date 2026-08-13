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
      default = "";
      description = "path to kitty wallpaper";
    };
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "whether to enable";
    };
  };

  config.programs.kitty = {
    enable = cfg.enable;
    package = pkgs.symlinkJoin {
      name = "kitty-gl";
      paths = [ pkgs.kitty ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        rm $out/bin/kitty
        makeWrapper ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL $out/bin/kitty \
        --add-flags "${pkgs.kitty}/bin/kitty"
      '';
    };
    font = {
      size = 11.0;
      name = "JetBrainsMono Nerd Font";
    };
    settings = {
      background_image = cfg.wallpaper;
      background_image_layout = "scaled";
      background_tint = 0.91;
      remember_window_size = false;
      initial_window_width = 1200;
      initial_window_height = 700;
      sync_to_monitor = false;
      repaint_delay = 8;
    };
  };
}

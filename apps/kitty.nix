{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
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
      name = "FiraMono Nerd Font Mono";
    };
    settings = {
      background_image = "/home/tls123/Pictures/wallpapers/kitty-background.png";
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

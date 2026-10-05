{
  pkgs,
  ...
}:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    baseIndex = 1;
    historyLimit = 5000;
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    keyMode = "vi";
    escapeTime = 0;
    extraConfig = ''
      set -g status off
      set -g focus-events on
      set -ga terminal-overrides ",*256col*:RGB"
      set -g allow-passthrough on
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
    '';
  };
}

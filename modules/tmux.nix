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
      set -s extended-keys on
      set -as terminal-features ',xterm-kitty:extkeys'
      bind -n C-S-Up if -F '#{pane_in_mode}' 'send-keys -X scroll-up' 'copy-mode ; send-keys -X scroll-up'
      bind -n C-S-Down if -F '#{pane_in_mode}' 'send-keys -X scroll-down'
    '';
  };
}

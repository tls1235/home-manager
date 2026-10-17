{ ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    baseIndex = 1;
    historyLimit = 50000;
    terminal = "tmux-256color";
    keyMode = "vi";
    escapeTime = 10;
    aggressiveResize = true;
    extraConfig = ''
      set -g status off
      set -g focus-events on
      set -g allow-passthrough on
      set -g set-clipboard on
      set -g renumber-windows on

      # Truecolor, undercurl and colored underlines (kitty)
      set -as terminal-features ',xterm-kitty:RGB:extkeys'
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'

      # Extended keys
      set -s extended-keys on
      set -s extended-keys-format csi-u

      # Scroll: copy mode in shells, pass through in Neovim
      bind -n C-S-Up if -F '#{pane_in_mode}' 'send-keys -X scroll-up' 'if -F "#{alternate_on}" "send-keys C-S-Up" "copy-mode ; send-keys -X scroll-up"'
      bind -n C-S-Down if -F '#{pane_in_mode}' 'send-keys -X scroll-down' 'send-keys C-S-Down'

      # Splits keep the current directory
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Vi-style copy mode
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';
  };
}
# { pkgs, ... }:
# {
#   programs.tmux = {
#     enable = true;
#     mouse = true;
#     baseIndex = 1;
#     historyLimit = 50000;
#     terminal = "tmux-256color";
#     shell = "/bin/zsh";
#     keyMode = "vi";
#     escapeTime = 10;
#     aggressiveResize = true;
#     extraConfig = ''
#       set -g status off
#       set -g focus-events on
#       set -g allow-passthrough on
#       set -g set-clipboard on
#
#       # Truecolor, undercurl and colored underlines (kitty)
#       set -as terminal-features ',xterm-kitty:RGB:extkeys'
#       set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
#       set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
#
#       # Extended keys
#       set -s extended-keys on
#       set -s extended-keys-format csi-u
#
#       bind -n C-S-Down if -F '#{pane_in_mode}' 'send-keys -X scroll-down'
#       bind -n C-S-Up if -F '#{||:#{alternate_on},#{pane_in_mode}}' 'send-keys C-S-Up' 'copy-mode ; send-keys -X scroll-up'
#     '';
#   };
# }

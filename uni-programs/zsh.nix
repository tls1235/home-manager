# zsh.nix
{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
    DISABLE_MAGIC_FUNCTIONS = "true";
    ENABLE_CORRECTION = "true";
    COMPLETION_WAITING_DOTS = "true";
    HISTORY_IGNORE = "(&|[bf]g|c|clear|history|exit|q|pwd|* --help)";
    LESS_TERMCAP_md = "$(tput bold 2>/dev/null; tput setaf 2 2>/dev/null)";
    LESS_TERMCAP_me = "$(tput sgr0 2>/dev/null)";
  };
  home.sessionPath = [ "$HOME/.dotnet/tools" ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      strategy = [
        "completion"
        "history"
      ];
    };
    syntaxHighlighting.enable = true;
    completionInit = "autoload -Uz compinit && compinit";
    defaultKeymap = "emacs";

    history = {
      size = 10000;
      save = 10000;
      share = true;
      append = true;
    };

    shellAliases = {
      hms = "home-manager switch --impure";
      zzz = "systemctl suspend & sleep 1";
      soft = "systemctl soft-reboot";
      hard = "shutdown now";
      nix-gc = "nix-collect-garbage -d";
      v = "nvim";
      make = "make -j`nproc`";
      ninja = "ninja -j`nproc`";
      n = "ninja";
      c = "clear";
      fixpacman = "sudo rm /var/lib/pacman/db.lck";
      update = "sudo pacman -Syu";
      tb = "nc termbin.com 9999";
      cleanup = "sudo pacman -Rsn $(pacman -Qtdq)";
      jctl = "journalctl -p 3 -xb";
      rip = "expac --timefmt='%Y-%m-%d %T' '%l\\t%n %v' | sort | tail -200 | nl";
    };

    oh-my-zsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
      plugins = [
        "git"
        "sudo"
      ];
      theme = "";
    };

    plugins = [
      {
        name = "Powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
    ];

    initContent = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      fi

      # pkgfile "command not found" handler (Arch/CachyOS system package, no Nix equivalent)
      [[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      zstyle ':completion:*:git-checkout:*' sort false
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':completion:*' menu no
      #zstyle ':fzf-tab:complete:*:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || cat $realpath 2>/dev/null'
      zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2
      zstyle ':fzf-tab:*' use-fzf-default-opts yes
      zstyle ':fzf-tab:*' switch-group '<' '>'
      setopt nobeep
      setopt interactivecomments
      setopt AUTO_LIST
      setopt AUTO_MENU
      setopt ALWAYS_TO_END
      zstyle ':completion:*' matcher-list \
        'm:{a-z}={A-Z}' \
        'r:|[._-]=* r:|=*' \
        'l:|=* r:|=*'
      mn() {
      tmp=$(mktemp)
      manix "$@" > "$tmp"
      nvim "$tmp"
      rm "$tmp"}
      source ~/.functions.sh
    '';
  };
}

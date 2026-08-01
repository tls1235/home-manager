{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;

    # --- Sane baseline ---
    viAlias = true;
    vimAlias = true;

    opts = {
      number = true;
      relativenumber = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      smartindent = true;
      termguicolors = true;
    };

    # --- Treesitter: syntax highlighting/parsing for Nix ---
    plugins.treesitter = {
      enable = true;
      settings.ensure_installed = [ "nix" ];
    };

    # --- LSP: nixd for hover, completion, diagnostics ---
    plugins.lsp = {
      enable = true;
      servers.nixd = {
        enable = true;
        settings = {
          nixpkgs.expr = "import <nixpkgs> { }";
          formatting.command = [ "nixfmt" ];
        };
      };
    };

    # --- Completion menu ---
    plugins.blink-cmp = {
      enable = true;
      settings = {
        keymap.preset = "default";
        sources.default = [
          "lsp"
          "path"
          "buffer"
        ];
      };
    };

    # --- Format-on-save with nixfmt ---
    plugins.conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft.nix = [ "nixfmt" ];
        format_on_save = {
          timeout_ms = 500;
          lsp_format = "fallback";
        };
      };
    };

    extraPackages = with pkgs; [ nixfmt-rfc-style ];
  };
}

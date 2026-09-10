{ config, pkgs, lib, ... }:

let
  # Bump this one line each season — reused in the URL and the extension's
  # own version metadata below.
  wpilibVersion = "2026.2.1";

  # WPILib's Marketplace listing is abandoned, but their GitHub releases DO
  # publish a real .vsix as a release asset — just not through the Marketplace
  # API, so it has to be fetched directly and wrapped manually.
  wpilibVsix = pkgs.fetchurl {
    url = "https://github.com/wpilibsuite/vscode-wpilib/releases/download/v${wpilibVersion}/vscode-wpilib-${wpilibVersion}.vsix";
    sha256 = "sha256-Qj9CHQk8ODZiILGEbhBdBl5wLpAf9RsYa7avYT4ns7Y=";
  };

  wpilibExtension = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-wpilib";
      publisher = "wpilibsuite";
      version = wpilibVersion;
    };
    vsix = wpilibVsix;
  };
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      extensions = (with pkgs.vscode-extensions; [
        # Java toolchain (WPILib's robot code is Java/Gradle-based)
        redhat.java
        vscjava.vscode-java-debug
        vscjava.vscode-java-test
        vscjava.vscode-java-dependency
        vscjava.vscode-gradle

        # C++ toolchain (for C++ robot projects)
        ms-vscode.cpptools

        # Python (WPILib also supports Python robot projects)
        ms-python.python

        # Vim keybindings (LazyVim-style modal editing)
        vscodevim.vim

        # AI code completion. If either attribute doesn't exist for your
        # nixpkgs channel, comment it out (nix eval will just error clearly,
        # unlike the marketplace-fetch failures above).
        github.copilot
        github.copilot-chat
      ]) ++ [
        wpilibExtension
      ];

      userSettings = {
        # Mirrors WPILib VSCode's default settings.json
        "java.home" = "${pkgs.jdk17}/lib/openjdk";
        "java.jdt.ls.java.home" = "${pkgs.jdk17}/lib/openjdk";
        "java.configuration.runtimes" = [
          {
            name = "JavaSE-17";
            path = "${pkgs.jdk17}/lib/openjdk";
            default = true;
          }
        ];
        "java.server.launchMode" = "Standard";
        "java.compile.nullAnalysis.mode" = "automatic";
        "files.exclude" = {
          "**/.git" = true;
          "**/.gradle" = true;
          "**/bin" = true;
          "**/build" = true;
        };
        "editor.formatOnSave" = true;
        "editor.tabSize" = 2;
        "editor.rulers" = [ 100 ];
        "telemetry.telemetryLevel" = "off";

        # Vim / LazyVim-like feel
        "vim.leader" = "<space>";
        "vim.whichwrap" = ""; # h/l and arrow keys stop at line edges, no wrap (like real vim)
        "vim.hlsearch" = true;
        "vim.incsearch" = true;
        "vim.useSystemClipboard" = true;
        "vim.sneak" = true; # s/S two-char jump, similar to LazyVim's flash.nvim
        "editor.lineNumbers" = "relative";
        "editor.cursorSurroundingLines" = 8; # like LazyVim's scrolloff
        "editor.scrollBeyondLastLine" = false;
        # Let Vim own its own keys instead of VS Code intercepting them first
        "extensions.experimental.affinity" = {
          "vscodevim.vim" = 1;
        };
        "extensions.autoCheckUpdates" = false;
        "extensions.autoUpdate" = false;
        "update.mode" = "none";
      };
    };
  };

  # WPILib projects call the system 'gradlew' wrapper which needs a JDK on PATH.
  home.packages = [ pkgs.jdk17 ];

  # By default home-manager symlinks settings.json into the read-only Nix
  # store, so VS Code errors ("Unable to write into user settings...") the
  # moment any extension tries to persist a setting on its own. Swap the
  # symlink for a real writable copy right after it's generated: your Nix
  # settings above still apply as the baseline on every switch, but VS Code
  # itself (and extensions) can write to the file at runtime in between.
  home.activation.vscodeSettingsWritable = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    settingsPath="${config.home.homeDirectory}/.config/Code/User/settings.json"
    if [ -L "$settingsPath" ]; then
      target="$(readlink -f "$settingsPath")"
      rm -f "$settingsPath"
      cp "$target" "$settingsPath"
      chmod u+w "$settingsPath"
    fi
  '';
}

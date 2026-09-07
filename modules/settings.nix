{ username, ... }: {
  manual.json.enable = true;
  programs.home-manager.enable = true;

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "26.11";
  };
}

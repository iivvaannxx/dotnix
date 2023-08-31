{ home, lib, pkgs, upkgs, profile, ... } @ args: {

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This two options default to the username already, but I find it better to leave them for clarity.
  home.username = profile.username;
  home.homeDirectory = "/home/${profile.username}";

  home.stateVersion = "23.05";
}
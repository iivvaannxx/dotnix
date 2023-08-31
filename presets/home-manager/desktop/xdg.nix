# -------------------------------------------------------------------------------------------------
#
#   Configuration preset for the XDG module.
#
#   See: https://wiki.archlinux.org/title/XDG_Base_Directory
#   Module: https://github.com/nix-community/home-manager/blob/master/modules/misc/xdg.nix
#
# -------------------------------------------------------------------------------------------------

{ config, lib, pkgs, ... } @ args: {

  xdg = {

    enable = true;
    userDirs = {

      enable = true;
      createDirectories = true;

      desktop = "${config.home.homeDirectory}/System/Desktop";
      publicShare = "${config.home.homeDirectory}/System/Public";
      templates = "${config.home.homeDirectory}/System/Templates";

      music = "${config.home.homeDirectory}/Media/Music";
      pictures = "${config.home.homeDirectory}/Media/Pictures";
      videos = "${config.home.homeDirectory}/Media/Videos";

      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      extraConfig = {

        XDG_MISC_DIR = "${config.home.homeDirectory}/Misc";
        XDG_PROJECTS_DIR = "${config.home.homeDirectory}/Projects";
      };
    };
  };
}
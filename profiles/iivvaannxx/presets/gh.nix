{ home, lib, pkgs, upkgs, profile, ... } @ args: let

  inherit (lib) mkDefault;

  inherit (profile) fullName;
  inherit (profile.github) noReplyEmail;

in {

  # See: https://github.com/nix-community/home-manager/blob/master/modules/programs/gh.nix
  programs.gh = {

    enable = true;

    settings = {

      git_protocol = "ssh";
      editor = "code";
    };
  }
}
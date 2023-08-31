# -------------------------------------------------------------------------------------------------
#
#   Configuration preset for the GitHub CLI client.
#
#   See: https://cli.github.com
#   Module: https://github.com/nix-community/home-manager/blob/master/modules/programs/gh.nix
#
# -------------------------------------------------------------------------------------------------

{ home, lib, pkgs, upkgs, ... } @ args: let

  inherit (lib) mkDefault;

in {

  programs.gh = {

    enable = true;
    enableGitCredentialHelper = mkDefault true;

    # See: https://cli.github.com/manual/gh_config
    settings = {

      git_protocol = mkDefault "ssh";
      editor = mkDefault "code";
    };
  };
}
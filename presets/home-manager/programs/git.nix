# -------------------------------------------------------------------------------------------------
#
#   Configuration preset for the Git CLI.
#
#   See: https://git-scm.com
#   Module: https://github.com/nix-community/home-manager/blob/master/modules/programs/git.nix
#
# -------------------------------------------------------------------------------------------------

{ home, lib, pkgs, upkgs, profile, ... } @ args: let

  inherit (lib) mkDefault;

in {

  programs.git = {

    enable = true;
    package = mkDefault pkgs.gitFull;

    userName = profile.fullName;
    userEmail = profile.github.noReplyEmail;

    extraConfig = {

      init.defaultBranch = mkDefault "main";

      # Enable commit signing.
      commit.gpgSign = true;
      user.signingkey = "~/.ssh/git-commit.pub";

      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };
  };
}

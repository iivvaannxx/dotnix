{ home, lib, pkgs, upkgs, profile, ... } @ args: let

  inherit (lib) mkDefault;

  inherit (profile) fullName;
  inherit (profile.github) noReplyEmail;

in {

  # See: https://github.com/nix-community/home-manager/blob/master/modules/programs/git.nix
  programs.git = {

    enable = true;
    package = mkDefault pkgs.gitFull;

    userName = fullName;
    userEmail = noReplyEmail;

    extraConfig = {

      init.defaultBranch = "main";

      # Enable commit signing.
      commit.gpgSign = true;
      user.signingkey = "~/.ssh/git-commit.pub";

      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };
  }
}
# -------------------------------------------------------------------------------------------------
#
#     Configuration preset for the OpenSSH module.
#
#     See: https://www.ssh.com/ssh/config/
#     Module: https://github.com/nix-community/home-manager/blob/master/modules/programs/ssh.nix
#
# -------------------------------------------------------------------------------------------------

{ home, lib, pkgs, upkgs, ... } @ args: let

  inherit (lib) mkDefault;

in {

  # See: https://github.com/nix-community/home-manager/blob/master/modules/programs/ssh.nix
  programs.ssh = {

    enable = true;
    extraConfig = mkDefault ''

      # For GitHub specify the SSH key to use.
      Host github.com
        IdentityFile ~/.ssh/github-iivvaannxx.pub
        IdentitiesOnly yes

      # Used by the 1Password SSH agent.
      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
  };

  home.file.".ssh/allowed_signers".text = ''
  
    * ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKidr1O1e1cSzEaMTuYu6I7MPwTR9xog4bThF85GUvaH Git-Commit
  '';
}
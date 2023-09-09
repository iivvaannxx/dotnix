{ config, lib, pkgs, upkgs, profile, ... } @ args: let

  inherit (builtins) fetchGit;
  
  # As a reminder, if this fails, double-check the SSH_AUTH_SOCK env variable.
  repo = fetchGit {

    ref = "main";
    name = "dotnix-secrets";

    # This is a private repo. SSH access is needed.
    url = "git@github.com:iivvaannxx/dotnix-secrets.git";
    rev = "c399529aefd82a868dce8520378ced646dc53de4";

  };

in {

  home.file.".test2".source = "${repo}/examplefile.txt";
}
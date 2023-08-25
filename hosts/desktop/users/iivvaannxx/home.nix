{ home, lib, pkgs, upkgs, ... } @ args: let

  # Import the profile information.
  profile = import ./profile.nix args;

in {

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This two options default to the username already, but I find it better to leave them for clarity.
  home.username = profile.username;
  home.homeDirectory = "/home/${profile.username}";

  home.packages = with pkgs; [

    alacritty
    brave

    neofetch
  ];

  programs.gpg.enable = true;
  services.gpg-agent = {

    enable = true;

    enableFishIntegration = true;
    enableBashIntegration = true;

    pinentryFlavor = "curses";
  };

  programs.git = {

    enable = true;
    package = pkgs.gitFull;

    userName = profile.fullName;
    userEmail = "47715589+iivvaannxx@users.noreply.github.com";
    extraConfig = {

      init.defaultBranch = "main";
      credential.helper = "${

        pkgs.git.override { withLibsecret = true; }

      }/bin/git-credential-libsecret";

      commit.gpgsign = true;
      user.signingkey = "0CA69F169D20F056";
    };
  };

  programs.gh = {

    enable = true;
    enableGitCredentialHelper = true;

    settings = {

      git_protocol = "ssh";
      editor = "code";
    };
  };

  programs.vscode = {

    enable = true;
    enableUpdateCheck = false;
  };

  programs.ssh.enable = true;
  programs.ssh.extraConfig = ''

      Host *
          IdentityAgent ~/.1password/agent.sock
  '';

  home.stateVersion = "23.05";
}
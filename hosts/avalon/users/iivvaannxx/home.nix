{ home, lib, pkgs, upkgs, ... } @ args: let

  # Import the profile information.
  profile = import ./profile.nix args;
  withPreset = preset: "${profile.presetPath/${preset}}";

in {

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = enable;

  # This two options default to the username already, but I find it better to leave them for clarity.
  home.username = profile.username;
  home.homeDirectory = "/home/${profile.username}";

  imports = [

  ];

  home.packages = with pkgs; [

    alacritty
    brave

    neofetch

  ] ++ [

    upkgs.vscode
  ];

  

  home.file.".ssh/allowed_signers".text = "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKidr1O1e1cSzEaMTuYu6I7MPwTR9xog4bThF85GUvaH dev.ivanporto@gmail.com";

  programs.gh = {

    enable = true;
    enableGitCredentialHelper = true;

    settings = {

      git_protocol = "ssh";
      editor = "code";
    };
  };

  programs.ssh.enable = true;
  programs.ssh.extraConfig = ''

      Host *
          IdentityAgent ~/.1password/agent.sock
  '';

  home.stateVersion = "23.05";
}
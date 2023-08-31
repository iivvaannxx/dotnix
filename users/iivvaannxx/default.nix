{ home, lib, pkgs, upkgs, profile, presetsPath, configsPath, ... } @ args: {

  imports = [

    "${configsPath}/base/home-manager.nix"

    # Import the different presets for each module.
    "${presetsPath}/backend/node.nix"
    "${presetsPath}/packaging/pnpm.nix"
    "${presetsPath}/programs/gh.nix"
    "${presetsPath}/programs/git.nix"
    "${presetsPath}/programs/ssh.nix"
  ];


  home.packages = with pkgs; [

    alacritty
    brave
    neofetch

  ] ++ [

    upkgs.vscode
  ];
}
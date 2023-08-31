{ home, lib, pkgs, upkgs, profile, presetsPath, configsPath, ... } @ args: {

  # Import the different reusable configs/presets.
  imports = [

    "${configsPath}/base/home-manager.nix"

    "${presetsPath}/backend/node.nix"
    "${presetsPath}/packaging/pnpm.nix"

    "${presetsPath}/desktop/xdg.nix"

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
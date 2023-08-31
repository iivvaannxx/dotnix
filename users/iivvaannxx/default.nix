{ home, lib, pkgs, upkgs, profile, presetsPath, configsPath, ... } @ args: let 

  # Shorthands to include reusable configs/presets.
  withPreset = preset: ("${presetsPath}/${preset}.nix");
  withConfig = config: ("${configsPath}/${config}.nix");

in {

  imports = [

    (withConfig "base/home-manager")

    (withPreset "backend/node")
    (withPreset "packaging/pnpm")

    (withPreset "desktop/xdg")

    (withPreset "programs/gh")
    (withPreset "programs/git")
    (withPreset "programs/ssh")

    (withPreset "shells/zsh")
    (withPreset "shells/starship")
    (withPreset "terminals/alacritty")
  ];

  home.packages = with pkgs; [

    brave
    neofetch

  ] ++ [

    upkgs.vscode
  ];
}
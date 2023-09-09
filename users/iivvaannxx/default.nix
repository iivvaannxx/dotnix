{ home, lib, pkgs, upkgs, profile, presetsPath, configsPath, ... } @ args: let 

  # Shorthands to include reusable configs/presets.
  withPreset = preset: ("${presetsPath}/${preset}");
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

    (withPreset "shell/zsh")
    (withPreset "shell/starship")
    (withPreset "terminals/alacritty")
  ];

  home.packages = with pkgs; [

    brave
    neofetch

  ] ++ [

    upkgs.vscode
  ];

  programs.neovim.enable = true;

  # TODO: Abstract into a module.
  xdg.configFile."1Password/ssh/agent.toml".text = ''
  
    [[ssh-keys]]
    vault = "Developer"
  '';
}

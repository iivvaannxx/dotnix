{ home, lib, customPkgs, pkgs, upkgs, profile, presetsPath, configsPath, ... } @ args: let 

  inherit (lib) attrValues;

  # Shorthands to include reusable configs/presets.
  withPreset = preset: ("${presetsPath}/${preset}");
  withConfig = config: ("${configsPath}/${config}.nix");

  # The packages defined at the flake outputs.
  selfPackages = attrValues customPkgs;

in {

  imports = [

    (withConfig "base/home-manager")

    (withPreset "backend/node")
    (withPreset "packaging/pnpm")

    (withPreset "desktop/xdg")

    (withPreset "programs/gh")
    (withPreset "programs/git")
    (withPreset "programs/ssh")
    # (withPreset "programs/vscode")

    (withPreset "shell/zsh")
    (withPreset "shell/starship")
    (withPreset "terminals/alacritty")

    ./secrets.nix
  ];

  home.packages = with pkgs; [

    brave
    neofetch
    obs-studio
    vlc
    firefox
    blender
    google-chrome
    deno
    inkscape
    figma-linux
    figma-agent

  ] ++ [

    upkgs.vscode
    upkgs.discord

  ] ++ selfPackages;

  home.sessionVariables = {
    
    SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
  };

  programs.neovim.enable = true;

  # TODO: Abstract into a module.
  xdg.configFile."1Password/ssh/agent.toml".text = ''
  
    [[ssh-keys]]
    vault = "Developer"
  '';

  programs.direnv = {

    enable = true;
    
    enableZshIntegration = true;
    nix-direnv.enable = true;

    config = {

      global.disable_stdin = true;
    };
  };

  home.sessionVariables = {

    # Temporal.
    DIRENV_LOG_FORMAT = "";
  };
}

{ home, lib, customPkgs, pkgs, upkgs, profile, presetsPath, configsPath, ... } @ args: let 

  inherit (lib) attrValues;

  # Shorthands to include reusable configs/presets.
  withPreset = preset: ("${presetsPath}/${preset}");
  withConfig = config: ("${configsPath}/${config}.nix");

  # The packages defined at the flake outputs.
  selfPackages = attrValues customPkgs;

  # Tweaks to make Rider work with Unity. See: https://huantian.dev/blog/unity3d-rider-nixos/
  # TODO: Abstract into a module.
  extra-path = with pkgs; [

    dotnetCorePackages.sdk_6_0
    dotnetPackages.Nuget
    mono
    msbuild

    # Extra binaries for Rider.
  ];

  extra-libs = with pkgs; [

    # Extra libraries for Rider.
  ];

  rider = pkgs.jetbrains.rider.overrideAttrs (attrs: {

    postInstall = ''

      # Wrap rider with extra tools and libraries
      mv $out/bin/rider $out/bin/.rider-toolless
      makeWrapper $out/bin/.rider-toolless $out/bin/rider \
        --argv0 rider \
        --prefix PATH : "${lib.makeBinPath extra-path}" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extra-libs}"

      # Making Unity Rider plugin work!
      # The plugin expects the binary to be at /rider/bin/rider,
      # with bundled files at /rider/
      # It does this by going up two directories from the binary path
      # Our rider binary is at $out/bin/rider, so we need to link $out/rider/ to $out/
      shopt -s extglob
      ln -s $out/rider/!(bin) $out/
      shopt -u extglob

    '' + attrs.postInstall or "";
  });

in {

  imports = [

    (withConfig "base/home-manager")
    (withPreset "desktop/xdg")
    (withPreset "backend/node")

    (withPreset "programs/gh")
    (withPreset "programs/git")
    (withPreset "programs/ssh")
    # (withPreset "programs/vscode")

    (withPreset "shell/starship")
    (withPreset "shell/bash")
    (withPreset "terminals/alacritty")

    ./secrets.nix
  ];

  home.packages = with pkgs; [

    brave
    neofetch
    obs-studio
    blesh
    vlc
    firefox
    blender
    google-chrome
    deno
    inkscape
    figma-linux
    figma-agent
    unityhub
    rider
    jetbrains.idea-ultimate
    anydesk

  ] ++ [

    upkgs.vscode
    upkgs.discord
    upkgs.obsidian

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
    
    enableBashIntegration = true;
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

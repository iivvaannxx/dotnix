# -------------------------------------------------------------------------------------------------
#
#     Configuration preset for the VS Code module.
#
#     See: https://code.visualstudio.com/
#     Module: https://github.com/nix-community/home-manager/blob/master/modules/programs/vscode.nix
#
# -------------------------------------------------------------------------------------------------

{ home, lib, pkgs, upkgs, ... } @ args: let

  inherit (lib) mkDefault;

in {

  programs.vscode = {

    enable = true;

    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;

    extensions = with pkgs.vscode-extensions; [

      astro-build.astro-vscode
      formulahendry.auto-close-tag
      formulahendry.auto-rename-tag
      catppuccin.catppuccin-vsc
      ms-azuretools.vscode-docker
      usernamehw.errorlens
      dbaeumer.vscode-eslint
      github.copilot
      ms-vscode.hexeditor
      wix.vscode-import-cost
      ritwickdey.liveserver
      pkief.material-product-icons
      bbenoist.nix
      zhuangtongfa.material-theme
      christian-kohler.path-intellisense
      ms-vscode-remote.remote-ssh
      svelte.svelte-vscode
      bradlc.vscode-tailwindcss

      # Not available at the moment.
      # atommaterial.a-file-icon-vscode
      # aaron-bond.better-comments
      # EditorConfig.EditorConfig
      # PeterSchmalfeldt.explorer-exclude
      # miguelsolorio.fluent-icons
      # github.copilot-chat
      # VisualStudioExptTeam.vscodeintellicode
      # AykutSarac.jsoncrack-vscode
      # miguelsolorio.min-theme
      # monokai.theme-monokai-pro-vscode
      # yoavbls.pretty-ts-errors
      # mutantdino.resourcemonitor
      # meganrogge.template-string-converter
      # antfu.unocss
    ];
  };
}
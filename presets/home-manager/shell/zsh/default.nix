# -------------------------------------------------------------------------------------------------
#
#   Configuration preset for the ZSH module.
#
#   See: https://nixos.wiki/wiki/Zsh
#   Module: https://github.com/nix-community/home-manager/blob/master/modules/programs/zsh.nix
#
# -------------------------------------------------------------------------------------------------

{ config, lib, pkgs, upkgs, profile, ... } @ args: let

  inherit (builtins) baseNameOf;
  inherit (lib) mkDefault concatStringsSep mapAttrsToList;

  # Some manually fetched sources (themes, scripts...).
  sources = import ./sources.nix args;

  sourcePlugins = import ./plugins.nix args;
  sourceAbbreviations = import ./abbreviations.nix args;

in {

  programs.zsh = {

    enable = true;
    enableCompletion = mkDefault true;
    enableAutosuggestions = mkDefault true;
    enableSyntaxHighlighting = mkDefault true;

    # The path where the ZSH configuration files are stored. ($HOME is prepended by default).
    dotDir = mkDefault "${baseNameOf config.xdg.configHome}/zsh";

    # See: https://github.com/zsh-users/zsh-syntax-highlighting
    autocd = mkDefault true;
    shellAliases = import ./aliases.nix;

    plugins = sourcePlugins;
    initExtra = sourceAbbreviations + ''
    
      # Source the ZSH theme.
      source "${sources.catppuccinSyntaxHighlighting}/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh"

      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word
    '';

    history = {

      path = mkDefault "${config.xdg.dataHome}/zsh/zsh_history";

      extended = mkDefault true;
      ignoreDups = mkDefault true;
    };
  };
}
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

  # The plugins to source into ZSH.
  zshPlugins = import ./plugins.nix args;

  sourceAbbreviations = let 

    aliases = import ./abbreviations.nix;
    transform = name: value: "abbr --session ${name}=\"${value}\" &>/dev/null";

  in concatStringsSep "\n" (mapAttrsToList transform aliases);

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
    plugins = zshPlugins;

    shellAliases = import ./aliases.nix;
    initExtra = sourceAbbreviations;

    history = {

      path = mkDefault "${config.xdg.dataHome}/zsh/zsh_history";

      extended = mkDefault true;
      ignoreDups = mkDefault true;
    };
  };
}
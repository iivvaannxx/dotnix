# -------------------------------------------------------------------------------------------------
#
#   Configuration preset for the ZSH module.
#
#   See: https://nixos.wiki/wiki/Zsh
#   Module: https://github.com/nix-community/home-manager/blob/master/modules/programs/zsh.nix
#
# -------------------------------------------------------------------------------------------------

{ config, osConfig, lib, pkgs, upkgs, profile, ... } @ args: let

  inherit (builtins) baseNameOf;
  inherit (lib) mkDefault;

in {

  programs.zsh = {

    enable = true;
    enableCompletion = mkDefault true;
    enableAutosuggestions = mkDefault true;

    # The path where the ZSH configuration files are stored. ($HOME is prepended by default).
    dotDir = mkDefault "${baseNameOf config.xdg.configHome}/zsh";

    # See: https://github.com/zsh-users/zsh-syntax-highlighting
    autocd = mkDefault true;

    history = {

      path = mkDefault "${config.xdg.dataHome}/zsh/zsh_history";

      extended = mkDefault true;
      ignoreDups = mkDefault true;
    };
  };
}
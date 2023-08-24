# This module abstracts out security configurations related to root permissions.

{ config, lib, ... }: let 

  inherit (lib) mkForce mkOverride mkIf mkMerge;
  inherit (lib.custom) mkBoolOption;

  # The current values for the root security module options.
  cfg = config.modules.security.root;

in {

  options.modules.security.root = {

    # Forcefully disables sudo and enables doas.
    useDoasInsteadOfSudo = mkBoolOption false "Whether to replace `sudo` with `doas`. This will effectively disable the `sudo` command.";
  };

  config = { } // mkIf (cfg.useDoasInsteadOfSudo) { 
      
    security.sudo.enable = mkOverride 0 false; 
    security.doas.enable = mkForce true;
  };
}
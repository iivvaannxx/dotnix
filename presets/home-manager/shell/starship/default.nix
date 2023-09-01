# -------------------------------------------------------------------------------------------------
#
#   Configuration preset for the Starship module.
#
#   See: https://starship.rs/
#   Module: https://github.com/nix-community/home-manager/blob/master/modules/programs/starship.nix
#
# -------------------------------------------------------------------------------------------------

{ config, home, lib, pkgs, upkgs, ... } @ args: let

  inherit (lib) mkDefault;

  # Import the configuration options.
  starshipConfig = (import ./config.nix args);

in {

  programs.starship = {

    enable = true;

    # Enable the integrations only if the respective shell is enabled.
    enableFishIntegration = mkDefault config.programs.fish.enable;
    enableZshIntegration = mkDefault config.programs.zsh.enable;
    enableBashIntegration = mkDefault config.programs.bash.enable;
    enableNushellIntegration = mkDefault config.programs.nushell.enable;
    enableIonIntegration = mkDefault config.programs.ion.enable;

    settings = mkDefault starshipConfig;
  };
}
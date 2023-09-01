# -------------------------------------------------------------------------------------------------
#
#   Configuration preset for the Alacritty module.
#
#   See: https://github.com/alacritty/alacritty
#   Module: https://github.com/nix-community/home-manager/blob/master/modules/programs/alacritty.nix
#
# -------------------------------------------------------------------------------------------------

{ config, home, lib, pkgs, upkgs, ... } @ args: let

  inherit (lib) mkDefault;

  # Import the configuration options.
  alacrittyConfig = (import ./config.nix args);

in {

  programs.alacritty = {

    enable = true;
    settings = mkDefault alacrittyConfig;
  };
}
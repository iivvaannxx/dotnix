# -------------------------------------------------------------------------------------------------
#
#   Configuration preset for the PNPM package manager module.
# 
#   See: https://pnpm.io/
#   Module: https://github.com/iivvaannxx/motherflake/blob/main/presets/home-manager/packaging/pnpm.nix
#
# -------------------------------------------------------------------------------------------------

{ config, lib, pkgs, upkgs, ... } @ args: {
    
  modules.packaging.pnpm = {

    enable = true;
    package = upkgs.nodePackages_latest.pnpm;
  };
}
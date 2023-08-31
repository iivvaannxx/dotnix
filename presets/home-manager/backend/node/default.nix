# -------------------------------------------------------------------------------------------------
#
#   Configuration preset for the NodeJS JavaScript runtime module.
#
#   See: https://nodejs.org/en/
#   Module: https://github.com/iivvaannxx/motherflake/blob/main/presets/home-manager/backend/node.nix
#
# -------------------------------------------------------------------------------------------------

{ config, lib, pkgs, ... } @ args: {
    
  modules.backend.nodejs = {

    enable = true;
    package = pkgs.nodejs-slim;

    # The global Node packages to install through Nix.
    globalPackages = [ ];
  };
}
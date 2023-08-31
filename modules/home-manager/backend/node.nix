# -------------------------------------------------------------------------------------------------
#
#     Home Manager module for the Node.js JavaScript runtime.
#     See: https://nodejs.org/en/
#
# -------------------------------------------------------------------------------------------------

{ config, lib, pkgs, upkgs, ... } @ args: let 

  inherit (builtins) attrNames elem filter length concatStringsSep;

  inherit (lib) mkEnableOption mkPackageOption hasInfix hasAttrByPath forEach getName mkIf;
  inherit (lib.custom) mkPackageListOption commaSeparatedList;

  # The current configuration values.
  cfg = config.modules.backend.nodejs;

in {

  options.modules.backend.nodejs = {

    # Whether to enable the NodeJS package.
    enable = mkEnableOption "Node.js® the cross-platform JavaScript runtime environment.";

    # The package to be installed.
    package = mkPackageOption pkgs "NodeJS" { default = [ "nodejs" ]; };

    # A list with all the global Node packages to be installed.
    globalPackages = mkPackageListOption [ ] "A list of Node packages to be installed globally.";
  };

  config = let

    # The names of all the Node packages available in the current Nixpkgs.
    nodePackages = pkgs.nodePackages 
      // pkgs.nodePackages_latest
      // upkgs.nodePackages 
      // upkgs.nodePackages_latest;

    # Get the names of all the packages that are requested.
    requestedPackages = forEach cfg.globalPackages (p:

      if hasAttrByPath [ "packageName" ] p 
        then p.packageName 
        else (getName p)
    );

    # Retrieve all the non-Node packages from the given ones.
    nonNodePackages = filter (p: !(elem p (attrNames nodePackages))) requestedPackages;
    isSlimPackage = hasInfix "slim" cfg.package.name;

  in mkIf (cfg.enable) {

    # The assertions to be checked for the module to work properly.
    assertions = [

      {
        assertion = length nonNodePackages == 0;
        message = ''
            
          The following packages: ${commaSeparatedList nonNodePackages} do not exist in the current Node Packages subset.
          You should check the packages specified in the 'programs.nodejs.globalPackages' option.
        '';
      }

      (mkIf (hasAttrByPath [ "modules" "packaging" "npm" ] config && config.modules.packaging.npm.enable) {

        assertion = isSlimPackage;
        message = ''
            
            The 'modules.packaging.npm.enable' option is set to true, but the 'modules.backend.nodejs.package' option is set to a non-slim version of NodeJS.
            Non-slim versions already include NPM, to avoid collisions you should set the 'modules.backend.nodejs.package' option to a slim version of NodeJS.
        '';
      })
    ];

    home.packages = [ cfg.package ] ++ cfg.globalPackages;
  };
}
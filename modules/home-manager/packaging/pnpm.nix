# -------------------------------------------------------------------------------------------------
#
#     Home Manager module for the Performant Node Package Manager (pnpm).
#     See: https://pnpm.io/
#
# -------------------------------------------------------------------------------------------------

{ config, lib, pkgs, upkgs, ... } @ args: let 

  inherit (lib) mkEnableOption mkPackageOption mkIf;
  inherit (lib.custom) mkSubmoduleOption mkStrOption;

  # The current configuration values.
  cfg = config.modules.packaging.pnpm;

in {

  options.modules.packaging.pnpm = mkSubmoduleOption { } "The PNPM package manager options." {

    enable = mkEnableOption "the Performant Node Package Manager.";
    package = mkPackageOption pkgs "PNPM" { default = [ "nodePackages.pnpm"]; };

    homeDirectory = mkStrOption ".local/share/pnpm" ''

      The path to the pnpm home. Relative to the user's home directory.
      This directory gets exported to the PNPM_HOME environment variable and added to the PATH.
    '';
  };

  config = let 

    # The global installation directory of the npm packages.
    pnpmHomeDir = "${config.home.homeDirectory}/${cfg.homeDirectory}";

    # Dummy files used to create "empty" directories.
    keepFile = { text = "# This is an automatically generated file used to keep the directory."; };
    
  in mkIf (cfg.enable) {

    # Install the npm package and create the configuration file.
    home.packages = [ cfg.package ];
    home.file."${pnpmHomeDir}/.keep" = keepFile;

    # PNPM needs the home directory to be set as an environment variable.
    home.sessionVariables = { "PNPM_HOME" = pnpmHomeDir; };
    
    # Also add the global folders to the PATH in order for the binaries to be found.
    home.sessionPath = [ pnpmHomeDir ];
  };
}
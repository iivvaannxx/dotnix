{ lib }: let

  inherit (lib.custom) stringWithSuffix;
  paths = {

    # The path to the common folder.
    commonBase = ../common;

    commonProfiles = "${paths.commonBase}/profiles";
    commonConfigs = "${paths.commonBase}/configs";
  };

in {

  # Imports a profile file given it's name.
  importCommonProfile = profileFile: let 

    profilePath = stringWithSuffix profileFile ".nix";
    profile = import "${paths.commonProfiles}/${profilePath}";

  in profile;

  # Imports a config file given it's name.
  importCommonConfig = configFile: let 

    configPath = stringWithSuffix configFile ".nix";
    config = import "${paths.commonConfigs}/${configPath}";

  in config;
}
  
{ lib, ... } @ args: let

  inherit (builtins) pathExists;
  inherit (lib) concatStringsSep throwIf;
  
in rec {

  # Imports a package source and returns a package set.
  mkPkgs = sourcePkgs: { system, unfree ? false, overlays ? [ ] }: import sourcePkgs {

    inherit system overlays;
    config.allowUnfree = unfree;
  };

  # Imports a package source and returns a package set with unfree packages enabled.
  mkUnfreePkgs = sourcePkgs: { system, overlays ? [ ] }: let

    unfreePkgs = mkPkgs sourcePkgs {
      
      inherit system overlays;
      unfree = true;
    };

  in unfreePkgs;

  # Creates a full path from a source path and a sub path. Throws the given error if the path does not exist.
  mkPath = sourcePath: subPath: notFoundError: let

    fullPath = concatStringsSep "/" [sourcePath subPath];
    isMissing = (! pathExists fullPath);

  in (throwIf isMissing notFoundError fullPath);
}
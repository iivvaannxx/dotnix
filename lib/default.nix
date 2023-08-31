{ lib }: let

  includeLib = customLib: import customLib  { inherit lib; };

  # Include every function lib file.
  conditionals = includeLib ./conditionals.nix;
  filesystem = includeLib ./filesystem.nix;
  generators = includeLib ./generators.nix;
  global = includeLib ./global.nix;
  make = includeLib ./make.nix;
  nixos = includeLib ./nixos.nix;
  options = includeLib ./options.nix;
  validation = includeLib ./validation.nix;

in {

  inherit (conditionals)

    nullUnless
    nullUnlessHasAttr
    tryGetAttr

    mkIfElse
    mkIfHasAttr
    mkUnless
  ;

  inherit (filesystem)

    getSubfolders
  ;

  inherit (generators)

    commaSeparatedList
    stringWithSuffix
  ;

  inherit (global) 
  
    importProfile 
    importConfig
  ;

  inherit (make) 

    mkPath
    mkPkgs
    mkUnfreePkgs
  ;

  inherit (nixos)

    mkHost
  ;

  inherit (options) 
  
    mkStrOption 
    mkStrListOption

    mkSubmoduleOption
    mkDynamicAttrsetOption 

    mkPackageListOption
  ;

  inherit (validation) 
  
    stringIsEmpty 
    stringIsNonEmpty 
    stringIsNullOrEmpty
    listContainsAny 
  ;
}
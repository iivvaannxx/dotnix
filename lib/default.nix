{ lib }: let

  includeLib = customLib: import customLib  { inherit lib; };

  # Include every function lib file.
  attrsets = includeLib ./attrsets.nix;
  conditionals = includeLib ./conditionals.nix;
  filesystem = includeLib ./filesystem.nix;
  make = includeLib ./make.nix;
  nixos = includeLib ./nixos.nix;
  options = includeLib ./options.nix;
  parsers = includeLib ./parsers.nix;
  strings = includeLib ./strings.nix;
  validation = includeLib ./validation.nix;

in {

  inherit (attrsets)

    mapAndFilterAttrs
    attrKeysRecursive
  ;

  inherit (conditionals)

    nullUnless
    nullUnlessHasAttr
    tryGetAttr

    mkIfElse
    mkIfHasAttr
    mkUnless
  ;

  inherit (filesystem)

    readDirRecursive
    readDirRecursive'

    getModulesRecursive
    mapModulesRecursive
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
    mkSubmoduleListOption
    mkDynamicAttrsetOption 

    mkPackageListOption
  ;

  inherit (parsers)

    fromJSON'
  ;

  inherit (strings)

    commaSeparatedList
    stringWithSuffix

    removeAllChars
  ;

  inherit (validation) 
  
    stringIsEmpty 
    stringIsNonEmpty 
    stringIsNullOrEmpty
    listContainsAny 
  ;
}
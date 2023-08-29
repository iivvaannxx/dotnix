{ lib }: let

  includeLib = customLib: import customLib  { inherit lib; };

  # Include every function lib file.
  global = includeLib ./global.nix;
  conditionals = includeLib ./conditionals.nix;
  filesystem = includeLib ./filesystem.nix;
  generators = includeLib ./generators.nix;
  nixos = includeLib ./nixos.nix;
  options = includeLib ./options.nix;
  validation = includeLib ./validation.nix;

in {

  inherit (global) 
  
    importProfile 
    importCommonConfig
  ;

  inherit (conditionals)

    nullUnless
    nullUnlessHasAttr

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

  inherit (nixos)

    mkHost
    mkHostConfig
  ;

  inherit (options) 
  
    mkBoolOption 
    mkStrOption 
    mkStrListOption
    mkDynamicAttrsetOption 
  ;

  inherit (validation) 
  
    stringIsEmpty 
    stringIsNonEmpty 
    stringIsNullOrEmpty
    listContainsAny 
  ;
}
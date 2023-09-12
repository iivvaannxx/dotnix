{ lib, pkgs, ... } @ args: let 
  
  inherit (builtins) baseNameOf listToAttrs;

  inherit (lib) removeSuffix;
  inherit (lib.custom) mapModulesRecursive;

  # Contains all the paths to each package.
  currentPath = ./.;
  importPackage = path: let 
  
    packageName = removeSuffix ".nix" (baseNameOf path);
    package = import "${currentPath}/${path}" args;

  in { name = packageName; value = package; };

  # All the custom defined packages.
  allPackages = mapModulesRecursive currentPath importPackage;

in listToAttrs allPackages

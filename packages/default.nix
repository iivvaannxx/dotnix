{ lib, pkgs, ... } @ args: let 
  
  inherit (builtins) baseNameOf;
  inherit (lib.custom) mapModulesRecursive;

  # Contains all the paths to each package.
  currentPath = ./.;
  importPackage = path: let 
  
    packageName = baseNameOf path;
    package = pkgs.callPackage "${currentPath}/${path}" { };

  in { "${packageName}" = package; };

  # All the custom defined packages.
  allPackages = mapModulesRecursive currentPath importPackage;

in allPackages

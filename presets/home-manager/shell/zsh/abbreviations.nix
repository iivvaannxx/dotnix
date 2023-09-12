{ lib, pkgs, ... } @ args: let 

  inherit (lib) concatStringsSep mapAttrsToList;

  transform = name: value: "abbr --session ${name}=\"${value}\" &>/dev/null";
  abbreviations = {

    gs = "git status";
  };

in concatStringsSep "\n" (mapAttrsToList transform abbreviations)
{ lib }: let 

  inherit (builtins) filter isAttrs;
  inherit (lib) filterAttrs mapAttrs' mapAttrsToList concatLists;

in {

  # Maps the given function to the given attribute set. Then filters the result based on the given predicate.
  mapAndFilterAttrs = pred: fn: attrs: filterAttrs pred (mapAttrs' fn attrs);

  # Returns all the keys of the given attribute set, recursively.
  attrKeysRecursive = attrs: let

    getKeys = prefix: attrs: concatLists (mapAttrsToList (key: value: let
      
      fullKey = if prefix == "" then key else "${prefix}.${key}";

      # If the current value is another attrset, recurse into it.
      recursedKeys = if isAttrs value 
        then [fullKey] ++ getKeys fullKey value
        else [fullKey];

    in recursedKeys) attrs);

  in getKeys "" attrs;
}
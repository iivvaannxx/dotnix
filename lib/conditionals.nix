{ lib }: let 

  inherit (builtins) isAttrs hasAttr;
  inherit (lib) mkIf mkMerge;

in {

  # Returns null unless the given predicate is true, in which case returns the given value.
  nullUnless = pred: val: if (! pred) then val else null;

  # Returns null unless the the given set contains the given attribute, in which case it returns that attribute.
  nullUnlessHasAttr = attr: set: let

    hasAttribute = hasAttr attr set;
    value = if hasAttribute then set.${attr} else null;

  in value;

  # If the given set contains the given attribute, that value is returned. Otherwise the fallback value is returned.
  tryGetAttr = attr: set: fallback: let

    hasAttribute = hasAttr attr set;
    value = if hasAttribute then set.${attr} else fallback;

  in value;

  # Makes either one value or another depending on the given predicate.
  mkIfElse = pred: truthy: falsy: mkMerge [
    
    (mkIf pred truthy)
    (mkIf (! pred) falsy)
  ];

  # Makes the given attribute in the given set only if exists.
  mkIfHasAttr = attr: set: let 
  
    hasAttribute = hasAttr attr set;
    value = if hasAttribute then set.${attr} else null;

  in (mkIf (hasAttribute) value);
  
  # Makes the given value unless the given predicate is true.
  mkUnless = pred: val: (mkIf (! pred) val);
}
{ lib, ... } @ args: let

  inherit (builtins) elem stringLength;
  inherit (lib) any intersectLists concatStringsSep;
  
in {

  # Checks if a given string is empty.
  stringIsEmpty = str: (stringLength str == 0);

  # Checks if a given string is non-empty.
  stringIsNonEmpty = str: (stringLength str > 0);

  # Checks if the given string is null or empty.
  stringIsNullOrEmpty = str: (str == null || str == "");

  # Checks that a list contains forbidden elements based on a given list of forbidden items.
  listContainsAny = forbidden: list: let 
  
    # Check if a given item is inside the forbidden item list.
    isForbiddenItem = item: elem item forbidden;

  in (any isForbiddenItem list);
}
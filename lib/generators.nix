{ lib }: let 

  inherit (lib) hasSuffix concatStringsSep;

in {

  # Dumps the given list into a comma-separated string list.
  commaSeparatedList = list: "[${concatStringsSep ", " list}]";

  # Ensures that a given string contains a given suffix.
  stringWithSuffix = str: suffix: let 

    containsSuffix = hasSuffix suffix str;

  in if containsSuffix then str else "${str}${suffix}";
}
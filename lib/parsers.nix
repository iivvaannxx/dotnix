{ lib }: let 

  inherit (builtins) pathExists readFile fromJSON;
  inherit (lib) hasSuffix;

in {

  # Same as 'fromJSON' but allows paths as an input.
  fromJSON' = source: let

    # Check if it's a file, if so, read it.
    isFilepath = (pathExists source) && hasSuffix ".json" source;
    jsonContent = if isFilepath then (readFile source) else (source);

    # Parse the json contents.
    parsedJSON = fromJSON jsonContent;

  in parsedJSON;
}
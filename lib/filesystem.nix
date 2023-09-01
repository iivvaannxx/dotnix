{ lib }: let 

  inherit (builtins) readDir filter pathExists baseNameOf;
  inherit (lib) mapAttrsToList concatLists filterAttrs hasPrefix hasSuffix;

  # Read the content of a directory recursively and return a list of files and directories.
  readDirRec = dirPath: filterFn: maxDepth: let

    readRecursive = fullPath: prefix: currentDepth: let

      # Read the content of the current directory
      dirContent = if currentDepth > 0 || maxDepth == -1 then (readDir fullPath) else { };
      filteredDirs = filterAttrs filterFn dirContent;

      recurse = (name: type: let

        # Full path to recursively read other dirs.
        nextFullPath = "${fullPath}/${name}";

        # Relative path to store in the output.
        relativePath = if prefix == "" then name else "${prefix}/${name}";
        current = [{ inherit type; path = relativePath; }];

        # If the current directory is a directory, then recursively read it.
        output = if type == "directory" 
          then current ++ readRecursive nextFullPath relativePath (currentDepth - 1)
          else current;

      in output);

    in concatLists (mapAttrsToList recurse filteredDirs);

  in readRecursive dirPath "" maxDepth;

in rec {

  # Reads the contents of the given directory recursively. Allows to speciify a max depth and whether to include hidden files and directories.
  readDirRecursive' = dirPath: { maxDepth ? -1, includeHidden ? false }: let

    # Filter function to exclude hidden files and directories.
    filterFn = if includeHidden then (_: _: true) else (name: _: (! hasPrefix "." name));
    contents = readDirRec dirPath filterFn maxDepth;

  in contents;

  # Reads the contents of the entire given directory recursively.
  readDirRecursive = dirPath: (readDirRecursive' dirPath { }); 

  # Retrieves all the paths of non 'default.nix' files in the given folder.
  getModulesRecursive = dirPath: let

    # Read the content of the directory recursively.
    contents = readDirRecursive dirPath;

    # Filter out files that are not modules.
    modules = filter ({ type, path }: let 
    
      # It's a file, it's not a default.nix and it has a .nix extension.
      isModule = type == "regular" && (baseNameOf path) != "default.nix" && hasSuffix ".nix" path;

    in isModule) contents;

  in map ({ type, path }: path) modules;

  # Maps the given function to all the modules in the given directory.
  mapModulesRecursive = dirPath: fn: let

    # Get all the modules in the given directory.
    modules = getModulesRecursive dirPath;

    # Map the given function to each module.
    mapped = map (path: fn path) modules;

  in mapped;
}
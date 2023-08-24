{ lib }: let 

  inherit (builtins) foldl' hasAttr pathExists baseNameOf;

  inherit (lib) nixosSystem recursiveUpdate throwIf optionalAttrs mkMerge mkIf;
  inherit (lib.custom) getSubfolders mkIfHasAttr nullUnlessHasAttr;

  # Traverses the given users folder and creates the users options for a system.
  mkUsers = usersFolder: homeManagerModules: let

    # Each subfolder is a user.
    subfolders = getSubfolders usersFolder;
    baseUsers = { systemConfig = { }; homeConfig = { }; };

  in foldl' (acc: folder: let 

    mkPath = path: let 

      # Construct the full path to the given file.
      fullPath = "${usersFolder}/${folder}/${path}";
      isMissing = (! pathExists fullPath); 

    in (throwIf isMissing "For user '${folder}': Each user must define a 'home.nix' and 'profile.nix' files." fullPath);

    profile = import (mkPath "profile.nix") { inherit lib; };
    homeModule = mkPath "home.nix";

    # Set fallbacks for these properties:
    username = if (hasAttr "username" profile) then profile.username else folder;
    fullName = if (hasAttr "fullName" profile) then profile.fullName else username;

  in {

    # The system configuration for the users.
    systemConfig = recursiveUpdate acc.systemConfig  {

      users.users.${username} = {

        name = username;
        description = fullName;
        extraGroups = mkIfHasAttr "extraGroups" profile;

        isNormalUser = true;
      };
    };

    # The home configuration for the users.
    homeConfig = recursiveUpdate acc.homeConfig {

      ${username} = {

        imports = homeManagerModules ++ [ homeModule ];
      };
    };

  }) baseUsers subfolders; 

  # Creates a system configuration.
  mkSystem = { system, configPath, usersPath, modules, home-manager, extraSpecialArgs ? { } }: let 

    # Make the users for this system.
    users = mkUsers usersPath modules.homeManagerModules;

  in nixosSystem {

    inherit system lib;
    modules = modules.nixosModules ++ [

      configPath
      users.systemConfig

      # Add the HM module. See: https://github.com/nix-community/home-manager/
      home-manager.nixosModules.home-manager {

        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
          
        home-manager.extraSpecialArgs = { } // extraSpecialArgs;
        home-manager.users = users.homeConfig;
      }
    ];
  };
  
in {

  # Creates a host definition ready to use in a flake as a nixosConfiguration.
  mkHost = { system, hostPath, modules, inputs, extraArgs ? { } } @ args: let 

    hostName = baseNameOf hostPath;
    mkPath = path: isFile: let

      fullPath = "${hostPath}/${path}";
      isMissing = (! pathExists fullPath);
      resource = if isFile then "file" else "folder";

    in (throwIf isMissing "For host '${hostName}': A '${path}' ${resource} must be created for the host to be built." fullPath);

    # Creates a preconfigured Nix package provider.
    mkPkgs = system: pkgs: let

      pkgsSource = import pkgs {

        inherit system;
        config.allowUnfree = true;
      };
   
    in pkgsSource;

    # The two paths needed by mkSystem.
    configPath = mkPath "configs/system.nix" true;
    usersPath = mkPath "users" false;

    nixpkgs = nullUnlessHasAttr "nixpkgs" inputs;
    unstablepkgs = nullUnlessHasAttr "unstablepkgs" inputs;
    pkgs = optionalAttrs (nixpkgs != null) (mkPkgs system nixpkgs);
    upkgs = optionalAttrs (unstablepkgs != null) (mkPkgs system unstablepkgs);

    # Ensure home-manager is inside the inputs.
    home-manager = throwIf (! hasAttr "home-manager" inputs) 
      "For host '${hostName}': 'home-manager' is required to build the host. Please make sure is inside the flake inputs."
      inputs.home-manager;

    # Pass the inputs as extra args together with the given ones.
    extraSpecialArgs = ((mkMerge [
      
      { inherit inputs; }

      # Only include the packages if the input is correctly defined.
      (if (nixpkgs != null) then { inherit pkgs; } else { })
      (if (unstablepkgs != null) then { inherit upkgs; } else { })

    ]) // extraArgs);

  in (mkSystem { inherit system configPath usersPath modules extraSpecialArgs home-manager; });
}
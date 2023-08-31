{ lib }: let 

  inherit (builtins) baseNameOf listToAttrs;

  inherit (lib) nixosSystem;
  inherit (lib.custom) mkUnfreePkgs mkPath;

  # Retrieves the profile of a user.
  getProfile = userPath : let 

    # Import the profile of the user.
    profilePath = mkPath userPath "profile.nix" "For user '${baseNameOf userPath}': Each user must define a 'profile.nix' file.";
    profile = (import profilePath);

  in profile;

  # Generates entries for each system user.
  mkSystemUsers = users: {
    
    users.users = (listToAttrs (map (userPath: let 

      # The profile of the current user.
      profile = getProfile userPath;

    in {

      name = profile.username;
      value = { 

        name = profile.username;
        description = profile.fullName;
        isNormalUser = true;

      } // profile.systemUserOverride;

    }) users));
  };

  # Generates entries for each home manager user.
  mkHomeUsers = homeUsers: (listToAttrs (map (userPath: let 

    # The profile of the current user.
    profile = getProfile userPath;

  in {

    name = profile.username;
    value = { 
      
      _module.args.profile = profile;
      imports = [ userPath ];
    };

  }) homeUsers));

in {

  # Creates a host from the given arguments.
  mkHost = { hostPath, system, users, inputs, lib, nixpkgs, unstablepkgs, home-manager }: let

    inherit (lib) nixosSystem;
    inherit (lib.custom) readJSON;

    # The path where all the source code is located.
    rootPath = ../.;
    configsPath = "${rootPath}/configs";

    # The package sets.
    pkgs = mkUnfreePkgs nixpkgs { inherit system; };
    upkgs = mkUnfreePkgs unstablepkgs { inherit system; };
    
    # Resources used within NixOS configurations.
    nixosModules = (import "${rootPath}/modules/nixos");
    nixSystemRegistry = {
      
      nix = { registry = (readJSON "${rootPath}/registry.json"); };
    };

    nixosUsers = mkSystemUsers users;
    nixosSpecialArgs = {

      inherit inputs configsPath pkgs upkgs;
      presetsPath = "${rootPath}/presets/nixos";
    };

    # Resources used within Home Manager configurations.
    homeManagerModules = (import "${rootPath}/modules/home-manager");
    homeManagerUsers = mkHomeUsers users;
    homeManagerSpecialArgs = {

      inherit inputs configsPath pkgs upkgs;
      presetsPath = "${rootPath}/presets/home-manager";
    };
    
  in nixosSystem {

    inherit system lib;

    specialArgs = nixosSpecialArgs;
    modules = nixosModules ++ [ 
      
      hostPath 

      nixSystemRegistry
      nixosUsers

      home-manager.nixosModules.home-manager {

        home-manager = {

          useGlobalPkgs = true;
          useUserPackages = true;

          users = homeManagerUsers;
          sharedModules = homeManagerModules;
          extraSpecialArgs = homeManagerSpecialArgs;
        };
      }
    ];
  };
}
{
  description = "My personal NixOS system configuration.";

  inputs = {

    flake-parts.url = "github:hercules-ci/flake-parts";
    
    # Only used to avoid dependency duplication (Multiple inputs use flake-utils).
    flake-utils.url = "github:numtide/flake-utils";

    # The package sets to use.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    unstablepkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # HM to manage home directories.
    home-manager = {

      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # To generate easy ISOs.
    nixos-generators = {

      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { flake-parts, nixpkgs, unstablepkgs, home-manager, ... } @ inputs: let 
  
    # Extend the default library with our own set of functions.
    lib = (inputs.nixpkgs.lib.extend (import ./overlays/lib.nix));

    # Shorthand function to create a host.
    createHost = system: hostPath: users: (lib.custom.mkHost { 
      
      inherit hostPath system users inputs lib
        nixpkgs unstablepkgs home-manager; 
    });
    
  in flake-parts.lib.mkFlake { inherit inputs; } {

    imports = [ ];

    # The systems tested at the moment.
    systems = [ "x86_64-linux" ];
    perSystem = { config, self', inputs', pkgs, upkgs, system, ... } @ args: let 

    in {

      # Allow unfree packages.
      _module.args.pkgs = lib.custom.mkUnfreePkgs nixpkgs { inherit system; };
      _module.args.upkgs = lib.custom.mkUnfreePkgs unstablepkgs { inherit system; };

      # Import all the custom packages.
      # packages = import ./packages args;
    };

    flake = {

      nixosConfigurations.avalon = createHost "x86_64-linux" ./hosts/avalon [ ./users/iivvaannxx ];
    };
  };
}

{
  description = "Description for the project";

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

    rust-overlay = {

      url = "github:oxalica/rust-overlay";

      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { flake-parts, home-manager, ... } @ inputs: let 
  
    # Extend the default library with our own set of functions.
    lib = (inputs.nixpkgs.lib.extend (import ./overlays/lib.nix));

    # Creates a host configuration.
    createHostConfig = hostPath: system: let
    
      args = { 

        inherit system hostPath inputs;

        modules = import ./modules;
        extraArgs = { };
      };

    in (lib.custom.mkHostConfig args);

    # Creates a host with the given host path and system.
    createHost = hostPath: system: let

      # Generate the configuration.
      host = (createHostConfig hostPath system);

    in (lib.custom.mkHost host);
  
  in flake-parts.lib.mkFlake { inherit inputs; } {

    imports = [ ];

    # The systems tested at the moment.
    systems = [ "x86_64-linux" ];

    perSystem = { config, self', inputs', pkgs, upkgs, system, ... } @ args: let 

      # Shorthand to re-import the nixpkgs of the current system (with unfree packages).
      mkPkgs = pkgsSource: overlays: import pkgsSource { 
        
        inherit system overlays; 
        config.allowUnfree = true;
      };

      shellPkgs = mkPkgs inputs.nixpkgs [ (import inputs.rust-overlay) ];
      toolchain = shellPkgs.rust-bin.fromRustupToolchainFile ./toolchain.toml;

    in {

      # Allow unfree packages.
      _module.args.pkgs = mkPkgs inputs.nixpkgs [ ];
      _module.args.upkgs = mkPkgs inputs.unstablepkgs [ ]; 

      # Include commonly used shells.
      devShells.default = pkgs.mkShell {

        packages = [ toolchain ];
      };
    };

    flake = {

      nixosConfigurations.avalon = createHost ./hosts/avalon "x86_64-linux";
    };
  };
}

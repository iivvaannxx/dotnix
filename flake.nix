{
  description = "Description for the project";

  inputs = {

    flake-parts.url = "github:hercules-ci/flake-parts";

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
      mkPkgs = pkgsSource: import pkgsSource { 
        
        inherit system; 
        config.allowUnfree = true;
      };

    in {

      # Allow unfree packages.
      _module.args.pkgs = mkPkgs inputs.nixpkgs;
      _module.args.upkgs = mkPkgs inputs.unstablepkgs;
    };

    flake = {

      nixosConfigurations.desktop = createHost ./hosts/desktop "x86_64-linux";
    };
  };
}

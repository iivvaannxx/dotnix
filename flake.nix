{
  description = "My personal NixOS system configuration.";
  outputs = { self, flake-parts, nixpkgs, unstablepkgs, home-manager, ... } @ inputs: let 
  
    # Extend the default library with our own set of functions.
    lib = (inputs.nixpkgs.lib.extend (import ./overlays/lib.nix));

    # Shorthand function to create a host.
    createHost = system: hostPath: users: (lib.custom.mkHost { 
      
      inherit hostPath system users inputs lib
        nixpkgs unstablepkgs home-manager self;

      # Add here the modules received in the flake inputs (except HM, which is handled automatically).
      extraNixosModules = [ 
        inputs.sops-nix.nixosModules.sops
      ];
    });
    
  in flake-parts.lib.mkFlake { inherit inputs; } {

    imports = [
      inputs.devshell.flakeModule
    ];

    # The systems tested at the moment.
    systems = [ "x86_64-linux" ];
    perSystem = { config, self', inputs', pkgs, upkgs, system, ... } @ args: {

      # Allow unfree packages.
      _module.args.pkgs = lib.custom.mkUnfreePkgs nixpkgs { inherit system; };
      _module.args.upkgs = lib.custom.mkUnfreePkgs unstablepkgs { inherit system; };

      # Import all the custom packages.
      packages = import ./packages (args // { inherit lib; });
      devshells.default = args.devshell.mkShell {

        devshell.startup.shellHook.text = ''
          source ./helpers.sh
        '';
      };
    };

    flake = {
      nixosConfigurations.atlas = createHost "x86_64-linux" ./hosts/atlas [ ./users/iivvaannxx ];
    };
  };

  inputs = {

    # Only used to avoid dependency duplication (Multiple inputs use flake-utils).
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";

    # The package sets to use.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    unstablepkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # To manage devshells.
    devshell = {

      url = "github:numtide/devshell";

      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # HM to manage home directories.
    home-manager = {

      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # To generate easy ISOs.
    nixos-generators = {

      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # To manage secrets.
    sops-nix = {

      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

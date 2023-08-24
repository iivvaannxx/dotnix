{
  description = "My personal NixOS Flake system configuration.";
  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    unstablepkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {

      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, unstablepkgs, home-manager, ... } @ inputs: let

    # The systems where this flake was tested.
    testedSystems = {

      x86_64-linux = "x86_64-linux";
    };

    # Extend the default library with our own set of functions.
    lib = (nixpkgs.lib.extend (import ./overlays/lib.nix)) // home-manager.lib;
    
    # Creates a host using the configuration in the given path.
    createHost = hostPath: system: lib.custom.mkHost { 

      inherit system hostPath inputs;

      modules = import ./modules;
      extraArgs = { };
    };

  in {

    nixosConfigurations = {

      # Home Desktop Computer.
      desktop = createHost ./hosts/desktop testedSystems.x86_64-linux;
    };
  };
}
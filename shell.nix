# Creates a simple shell with Git and Nix Flakes enabled.

{ pkgs ? import <nixpkgs> { } }: let

  # Create a nix binary with flakes enabled.
  nixBin = pkgs.writeShellScriptBin "nix" ''
    ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';

in pkgs.mkShell {

  # Include git in the shell environment.
  buildInputs = with pkgs; [ git ];
  shellHook = ''
    export PATH="${nixBin}/bin:$PATH"
    source ./helpers.sh
  '';
}
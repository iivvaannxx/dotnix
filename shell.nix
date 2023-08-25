{ pkgs ? import <nixpkgs> {} }:

  let nixBin = pkgs.writeShellScriptBin "nix" ''
    ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';

in pkgs.mkShell {

  buildInputs = [ pkgs.git ];
  shellHook = ''
    export PATH="${nixBin}/bin:$PATH"
  '';
}
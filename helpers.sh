#!/usr/bin/env bash

repl () {

  nix repl --expr "rec { \
    \
    nixpkgs = import <nixpkgs> { };\
    lib = nixpkgs.lib;\
    customLib = (import ./lib { inherit lib; });\
  }"
}

rebuild () {

  mode=${1:-switch}
  host=${2:-avalon}

  sudo nixos-rebuild $mode --flake .#$host
}
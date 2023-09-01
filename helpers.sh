#!/usr/bin/env bash

repl () {

  nix repl --expr "rec { \
    \
    nixpkgs = import <nixpkgs> { };\
    lib = nixpkgs.lib;\
    customLib = (import ./lib { inherit lib; });\
  }"
}
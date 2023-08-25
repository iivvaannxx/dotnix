{ config, lib, pkgs, ... } @ args: let

  inherit (lib) mkDefault;

in {

  networking.wireless.enable = false;
}
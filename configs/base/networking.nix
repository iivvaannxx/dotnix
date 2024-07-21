{ lib, pkgs, ... } @ args: let 

  inherit (lib) mkDefault;

in {

  # Whether to use NetworkManager to obtain an IP address and other configuration for all network interfaces that are not manually configured.
  # If enabled, a group 'networkmanager' will be created. Add all users that should have permission to change network settings to this group.
  networking.networkmanager.enable = mkDefault true;
  networking.useDHCP = mkDefault true;

  # Enable the firewall by default.
  networking.firewall.enable = mkDefault true;

  networking.extraHosts = ''
    140.82.114.3 github.com github.io
  '';
}
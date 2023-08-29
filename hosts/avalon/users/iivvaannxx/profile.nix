{ lib, ... } @ args: let 

  # Import the global 'iivvaannxx' profile.
  inherit (lib.custom) importProfile;
  details = importProfile "iivvaannxx";

in details // { 

  extraGroups = [ "wheel" "networkmanager" ];
}
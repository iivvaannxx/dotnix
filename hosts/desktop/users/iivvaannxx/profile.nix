{ lib, ... } @ args: let 

  # Import the common 'ivan' profile.
  inherit (lib.custom) importCommonProfile;
  details = importCommonProfile "ivan";

in details // { 

  extraGroups = [ "wheel" "networkmanager" ];
}
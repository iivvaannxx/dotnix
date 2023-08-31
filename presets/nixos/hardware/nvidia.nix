# -------------------------------------------------------------------------------------------------
#
#   Configuration preset which enables the use of NVIDIA graphic cards.
#
#   See: https://nixos.wiki/wiki/Nvidia
#   Module: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/hardware/video/nvidia.nix
#
# -------------------------------------------------------------------------------------------------


{ config, lib, ... } @ args: let

  inherit (lib) mkDefault;

in {

  hardware.nvidia = {

    nvidiaSettings = mkDefault false;
    forceFullCompositionPipeline = mkDefault true;
  };

  hardware.opengl = {

    enable = mkDefault true;
    driSupport = mkDefault true;
    driSupport32Bit = mkDefault true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
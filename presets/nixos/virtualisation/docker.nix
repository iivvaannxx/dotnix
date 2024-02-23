# -------------------------------------------------------------------------------------------------
#
#   Configuration preset which enables the use of the Docker CLI.
#
#   See: https://nixos.wiki/wiki/Docker
#   Module: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/docker.nix
#
# -------------------------------------------------------------------------------------------------

{ config, lib, ... } @ args: let

  inherit (builtins) elem;
  inherit (lib) mkDefault;

  # Check if the X server video drivers contain the "NVIDIA" string.
  nvidiaIsEnabled = elem "nvidia" config.services.xserver.videoDrivers;

in {

  virtualisation.docker = {

    enable = true;

    # Enable on boot. Forbid rootless mode.
    enableOnBoot = mkDefault true;
    rootless.enable = mkDefault true;

    autoPrune = {

      # Weekly prune all dangling and unused images and containers.
      enable = mkDefault true;
      dates = mkDefault "weekly";
      flags = mkDefault [ "--all" "--force" ];
    };

    # If the NVIDIA module is enabled, allow NVIDIA support inside Docker containers.
    enableNvidia = nvidiaIsEnabled;
  };
}
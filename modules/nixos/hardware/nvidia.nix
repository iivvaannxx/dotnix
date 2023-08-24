# This module abstracts out the configuration of the NVIDIA configuration options.

{ config, lib, options, pkgs, ... } @ args: let

  inherit (lib) mkEnableOption mkIf;
  inherit (lib.custom) mkBoolOption;

  # The current values for the NVIDIA module options.
  cfg = config.modules.hardware.nvidia;

in {

  options.modules.hardware.nvidia = {

    enable = mkEnableOption "the NVIDIA drivers";
    enableSettings = mkBoolOption true "Whether to enable the NVIDIA X Server Settings.";

    useInDocker = mkBoolOption false "Whether to enable support for NVIDIA GPUs inside docker containers.";

    # See: https://search.nixos.org/options?channel=23.05&show=hardware.nvidia.forceFullCompositionPipeline
    tryFixTearing = mkBoolOption false "Whether to enable the full composition pipeline to fix screen tearing issues.";
  };

  # See: https://nixos.wiki/wiki/Nvidia
  config = mkIf (cfg.enable) {

    hardware.nvidia = {

      nvidiaSettings = cfg.enableSettings;
      forceFullCompositionPipeline = cfg.tryFixTearing;
    };

    hardware.opengl = {

      enable = true;

      driSupport = true;
      driSupport32Bit = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];
    virtualisation.docker.enableNvidia = cfg.useInDocker;
  };
}

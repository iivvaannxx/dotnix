{ config, lib, pkgs, modulesPath, ... } @ args: let

  inherit (lib) mkDefault;

in {

  imports = [ 
    
    (modulesPath + "/installer/scan/not-detected.nix")
    ./filesystem.nix
  ];


  boot.extraModulePackages = [ ];
  boot.initrd.kernelModules = [ ];

  boot.kernelModules = [ "kvm-intel" ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  
  # Auto-generated settings. Better to not touch them.
  powerManagement.cpuFreqGovernor = mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;

  # Enable NVIDIA drivers. Try fix screen flickering (happens sometimes).
  modules.hardware.nvidia.enable = true;
  modules.hardware.nvidia.tryFixTearing = true;
}

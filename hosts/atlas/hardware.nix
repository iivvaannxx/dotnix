{ config, lib, pkgs, modulesPath, presetsPath, ... } @ args: let

  inherit (lib) mkDefault;

in {

  imports = [ 
    
    "${modulesPath}/installer/scan/not-detected.nix"
    "${presetsPath}/hardware/nvidia.nix"
  ];

  boot.extraModulePackages = [ ];
  boot.initrd.kernelModules = [ ];

  boot.kernelModules = [ "kvm-intel" ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];

  boot.supportedFilesystems = [ "ext4" "vfat" "ntfs" "btrfs" ];
  
  # Auto-generated settings. Better to not touch them.
  powerManagement.cpuFreqGovernor = mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;

  hardware.logitech.wireless.enable = true;
}
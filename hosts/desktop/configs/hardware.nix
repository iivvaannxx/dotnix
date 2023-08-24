{ config, lib, pkgs, modulesPath, ... } @ args: let

in {

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = { 
    
    device = "/dev/disk/by-uuid/745067bc-0dec-42bc-b85e-10c273a7bd2d";
    fsType = "ext4";
  };

  fileSystems."/boot" = { 
    
    device = "/dev/disk/by-uuid/FC14-3DD4";
    fsType = "vfat";
  };

  swapDevices = [ ];

  modules.hardware.nvidia.enable = true;
  modules.hardware.nvidia.tryFixTearing = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
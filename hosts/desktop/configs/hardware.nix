{ config, lib, pkgs, modulesPath, ... } @ args: let

in {

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/boot" = {    
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
  };

  modules.hardware.nvidia.enable = true;
  modules.hardware.nvidia.tryFixTearing = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;


  fileSystems."/" =
    { device = "/dev/disk/by-label/NixOS";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/NixOS";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/NixOS";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; }
    ];
}

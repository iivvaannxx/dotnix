{ ... }: {

  # Point to the EFI system partition.
  fileSystems."/boot" = {    

    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
  };

  # Point to the root BTRFS subvolume (NixOS partition).
  fileSystems."/" = { 
    
    fsType = "btrfs";

    device = "/dev/disk/by-label/NixOS";
    options = [ "subvol=root" "compress=zstd" ];
  };

  # Point to the home BTRFS subvolume (NixOS partition).
  fileSystems."/home" = { 
    
    fsType = "btrfs";
  
    device = "/dev/disk/by-label/NixOS";
    options = [ "subvol=home" "compress=zstd" ];    
  };

  # Point to the Nix Store BTRFS subvolume (NixOS partition).
  fileSystems."/nix" = { 
    
    fsType = "btrfs";
  
    device = "/dev/disk/by-label/NixOS";
    options = [ "subvol=nix" "compress=zstd" ];
  };

  # Include here any swap partitions.
  swapDevices = [ 
    
    { device = "/dev/disk/by-label/swap"; } 
  ];
}

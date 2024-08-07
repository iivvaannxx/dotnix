{ config, lib, inputs, pkgs, upkgs, presetsPath, configsPath, ... } @ args: let

  system = "x86_64-linux";

in {

  imports = [ 

    ./hardware.nix 
    ./networking.nix
    ./filesystem.nix

    "${configsPath}/base/system.nix"
    "${presetsPath}/virtualisation/docker.nix"
  ];

  # Boot configuration.
  boot.loader.timeout = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use systemd-boot as the default bootloader. See: https://nixos.wiki/wiki/Bootloader
  boot.loader.systemd-boot = {

    enable = true;
    editor = false;
    configurationLimit = 5;
  };

  # Configure keymap in X11
  services.xserver = {

    enable = true;
    
    displayManager = {

      gdm.enable = true;
    };

    desktopManager = {

      gnome.enable = true;
      xterm.enable = false;
    };

    layout = "es";
    xkbVariant = "";

    exportConfiguration = true;
  };

  fonts.packages = with pkgs; [

    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  services.gnome.core-utilities.enable = false;
  environment.gnome.excludePackages = (with pkgs; [

    gnome-tour
  ]);

  services.printing.enable = false;
  sound.enable = true;

  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {

    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = system;

  environment.systemPackages = with pkgs; [

    gnome.nautilus
    gnome.seahorse
    gnome.dconf-editor
    gnome.gnome-tweaks

    cached-nix-shell
    wineWowPackages.stable
  ];

  modules.tools.onepassword = {

    gui = {

      enable = true;
      package = pkgs._1password-gui;
      polkitPolicyOwners = [ "iivvaannxx" ];
    };
  };

  programs.zsh.enable = false;
  environment.shells = [ pkgs.bash ];

  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "iivvaannxx" ];

  services.openssh = {

    # Disable until XZ backdoor is fixed.
    enable = false;

    # This opens port 22 automatically.
    openFirewall = false;
    startWhenNeeded = false;

    settings = {

      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  modules.tools.cachix.enable = true;

  nix = {
	
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    
    settings = {

      auto-optimise-store = true;
    };

    gc = {

      automatic = true;
      dates = "weekly";
      
      options = "--delete-older-than-7d";
    };
  };
}

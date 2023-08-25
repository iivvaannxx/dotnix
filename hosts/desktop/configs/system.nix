{ config, lib, inputs, pkgs, upkgs, ... } @ args: let

  inherit (lib.custom) importCommonConfig;

  # The base configuration for every system.
  commonSystemConfig = importCommonConfig "system";

in {

  imports = [ 

    ./hardware.nix 
    ./networking.nix

    commonSystemConfig
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

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.desktopManager.xterm.enable = false;

  # Configure keymap in X11
  services.xserver = {

    layout = "es";
    xkbVariant = "";
  };

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
  environment.systemPackages = with pkgs; [

    gnome.nautilus
    gnome.seahorse
    gnome.dconf-editor
    gnome.gnome-tweaks
  ];

  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = [ "iivvaannxx" ];

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
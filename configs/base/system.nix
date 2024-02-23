# Here we define the shared system-wide configuration for each and every host.
{ lib, pkgs, ... } @ args: let

  inherit (lib) mkDefault;
  esLocale = "es_ES.UTF-8";

in {

  imports = [ ./networking.nix ];

  # Don't install the docs in the system. See: https://nixos.org/manual/nixos/stable/
  documentation.nixos.enable = mkDefault false;
  nixpkgs.config.allowUnfree = mkDefault true;

  # Settings to use for the different TTY's.
  console = {

    earlySetup = mkDefault true;
    keyMap = mkDefault "es";
    
    packages = with pkgs; [ terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
  };

  # At least an editor to edit the configuration.
  environment.systemPackages = with pkgs; [ nano ];
  environment.pathsToLink = [ "/share/bash-completion" ];
  environment.variables = {

    EDITOR = mkDefault "nano";
    VISUAL = mkDefault "nano";
  };

  # Use English as language but Spanish units and currencies.
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  i18n.extraLocaleSettings = {

    LC_NAME = mkDefault esLocale;
    LC_TIME = mkDefault esLocale;
    LC_PAPER = mkDefault esLocale;
    LC_ADDRESS = mkDefault esLocale;
    LC_NUMERIC = mkDefault esLocale;
    LC_MONETARY = mkDefault esLocale;
    LC_TELEPHONE = mkDefault esLocale;
    LC_MEASUREMENT = mkDefault esLocale;
    LC_IDENTIFICATION = mkDefault esLocale;
  };

  nix.settings = {
    
    # Ensure flakes and the new Nix CLI are enabled.
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = mkDefault true;
  };

  nix.gc.automatic = mkDefault true;
  nix.optimise.automatic = mkDefault true;

  # Only allow 'wheel' group members to use sudo.
  security.sudo.enable = mkDefault true;
  security.sudo.execWheelOnly = mkDefault true;

  # Avoid problems if dual-booting with Windows.
  time.hardwareClockInLocalTime = mkDefault true;
  time.timeZone = mkDefault "Europe/Madrid";

  # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were taken. 
  # It‘s perfectly fine and recommended to leave this value at the release version of the first install of this system. Before changing this value read the documentation for this option.
  system.stateVersion = mkDefault "23.05";
}
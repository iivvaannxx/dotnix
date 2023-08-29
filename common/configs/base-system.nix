# Here we define the shared system-wide configuration for each and every host.
{ lib, pkgs, ... } @ args: let

  inherit (lib) mkDefault;

in {

  imports = [ ./base-networking.nix ];

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
  environment.variables = {

    EDITOR = mkDefault "nano";
    VISUAL = mkDefault "nano";
  };

  # Use English as language but Spanish units and currencies.
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  i18n.extraLocaleSettings = {

    LC_NAME = mkDefault "es_ES.UTF-8";
    LC_TIME = mkDefault "es_ES.UTF-8";
    LC_PAPER = mkDefault "es_ES.UTF-8";
    LC_ADDRESS = mkDefault "es_ES.UTF-8";
    LC_NUMERIC = mkDefault "es_ES.UTF-8";
    LC_MONETARY = mkDefault "es_ES.UTF-8";
    LC_TELEPHONE = mkDefault "es_ES.UTF-8";
    LC_MEASUREMENT = mkDefault "es_ES.UTF-8";
    LC_IDENTIFICATION = mkDefault "es_ES.UTF-8";
  };

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
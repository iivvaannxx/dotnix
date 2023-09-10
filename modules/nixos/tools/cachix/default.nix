# -------------------------------------------------------------------------------------------------
#
#     Home Manager module for the 1Password password manager.
#     See: https://cachix.org
#
# -------------------------------------------------------------------------------------------------

{ config, lib, pkgs, upkgs, ... } @ args: let 

  inherit (lib) mkEnableOption mkIf mkBefore;

  # The current configuration values.
  cfg = config.modules.tools.cachix;

in {

  options.modules.tools.cachix = {

    enable = mkEnableOption "the Cachix binary cache.";
  };

  config = mkIf (cfg.enable) {

    environment.systemPackages = [ pkgs.cachix ];
    nix.settings = {

      trusted-users = [ "iivvaannxx" ];
      substituters = mkBefore [ 
        
        "https://dotnix.cachix.org"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = mkBefore [ 
        
        "dotnix.cachix.org-1:RPod1Hou5kRivWRdxQ4dHnPU5r/5M28oTOrF+VKqWqY="      
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" 
      ];
    };
  };
}
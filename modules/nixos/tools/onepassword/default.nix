# -------------------------------------------------------------------------------------------------
#
#     Home Manager module for the Performant Node Package Manager (pnpm).
#     See: https://pnpm.io/
#
# -------------------------------------------------------------------------------------------------

{ config, lib, pkgs, upkgs, ... } @ args: let 

  inherit (builtins) map fromToml concatStringsSep;

  inherit (lib) mkEnableOption mkPackageOption mkIf;
  inherit (lib.custom) mkSubmoduleOption mkSubmoduleListOption mkStrOption;

  # The current configuration values.
  cfg = options.modules.tools.onepassword;

in {

  options.modules.tools.onepassword = {

    gui = mkSubmoduleOption { } "Options for the 1Password GUI." {

      enable = mkEnableOption "the 1Password password manager GUI.";
      package = mkPackageOption "1Password GUI" { default = [ "_1password-gui" ] };

      polkitPolicyOwners = mkStrListOption [ ] "The users that should be able to integrate 1Password with polkit-based authentication mechanisms.";
    };

    cli = mkSubmoduleOption { } "Options for the 1Password CLI." {

      enable = mkEnableOption "the 1Password password manager CLI.";
      package = mkPackageOption "1Password CLI" { default = [ "_1password" ] };
    };

    # See: https://developer.1password.com/docs/ssh/agent/config
    agentConfig = mkSubmoduleListOption [ ] "The config to write to the 1Password 'agent.toml' file." {

      item = mkStrOption "" "The item name or ID";
      vault = mkStrOption "" "The vault name or ID";
      account = mkStrOption "" "The account name or ID";
    };
  };

  config = let 

    agentSections = (map (config: concatStringsSep "\n" [

      "[[ssh-keys]]"

      # Add each key-value pair as a separate line (if present).
      (mkIf (config.item != "") ''item = "${config.item}"'')
      (mkIf (config.vault != "") ''vault = "${config.vault}"'')
      (mkIf (config.account != "") ''account = "${config.account}"'')
    ]));

    # The agent config file.
    agentToml = concatStringsSep "\n\n" agentSections;
    
  in mkIf (cfg.gui.enable || cfg.cli.enable) {

    # Configuration for the 1Password CLI.
    programs._1password.enable = cfg.cli.enable;
    programs._1password.package = cfg.cli.package;

    # Configuration for the 1Password GUI.
    programs._1password-gui.enable = cfg.gui.enable;
    programs._1password-gui.package = cfg.gui.package;
    programs._1password-gui.polkitPolicyOwners = cfg.gui.polkitPolicyOwners;
  };
}
# -------------------------------------------------------------------------------------------------
#
#     NixOS Module to manage Dynamic DNS updates with Duck DNS.
#     See: https://www.duckdns.org
#
# -------------------------------------------------------------------------------------------------

{ config, lib, pkgs, upkgs, ... } @ args: let 

  inherit (builtins) all map listToAttrs attrValues;

  inherit (lib) mkEnableOption mkIf mkDefault;
  inherit (lib.custom) mkSubmoduleWithConfigOption mkSubmoduleListOption  mkStrOption;

  # The current configuration values.
  cfg = config.modules.networking.duckdns;

in {

  options.modules.networking.duckdns = {

    enable = mkEnableOption "the Duck DNS module";
    domains = mkSubmoduleListOption [ ] "The Duck DNS registered domains" {

      name = mkStrOption "" "The Duck DNS domain name.";
      token = mkStrOption "" "The Duck DNS token.";
      update = mkSubmoduleWithConfigOption { } "The Duck DNS update configuration." { 

        automatic = mkEnableOption "whether to update the domain automatically.";
        interval = mkStrOption "hourly" "the update interval (see `man systemd.time` for the format).";

      } {

        # The default values for the update configuration.
        automatic = mkDefault true;
        interval = mkDefault "hourly";
      };
    };
  };

  config = let 

    # Creates a script which updates a single domain.
    makeUpdateScript = domain: let 
    
      name = domain.name;
      token = domain.token;

    in pkgs.writeShellScriptBin "duckdns.update.${name}" ''

        echo -ne "\n"
        curl -k -o /tmp/duckdns-${name}.log "https://www.duckdns.org/update?domains=${name}&token=${token}&ip="

        echo -e "\nDuck DNS update for '${name}' executed at '$(date)'."
        log_content=$(cat /tmp/duckdns-${name}.log)

        if [[ "$log_content" == "OK" ]]; then
          echo "Log: $log_content - Successful Update"
        elif [[ "$log_content" == "KO" ]]; then
          echo "Log: $log_content - Something went wrong"
        fi
    '';

    # Creates a service which executes the update script for a single domain.
    makeService = domain: updateScript: {

      name = "duckdns.auto-updater.${domain.name}";
      value = mkIf domain.update.automatic {

        script = "${pkgs.bash}/bin/bash ${updateScript}/bin/duckdns.update.${domain.name}";
        unitConfig = {
        
          # Make sure it runs after the network is up.
          Description = "Duck DNS auto-updater for '${domain.name}.duckdns.org'";
          After = [ "network.target" ];
        };

        serviceConfig = {

          # The service should run once as root.
          Type = "oneshot";
          User = "nobody";
        };
      };
    };

    # Creates a timer which executes the update service for a single domain.
    makeTimer = domain: {

      name = "duckdns.auto-updater.${domain.name}";
      value = mkIf domain.update.automatic {

        wantedBy = [ "timers.target" ];
        timerConfig = {

          # Also run it once on boot (after 1 minute).
          OnBootSec = "1min";
          Persistent = true;

          # Use the configured interval to run the Updater Service.
          OnCalendar = domain.update.interval;
          Unit = "duckdns.auto-updater.${domain.name}.service";
        };
      };
    };

    # Generates an update script, a timer and a service for each domain.
    updaterConfigs = let 

      makeConfig = domain: {

        name = domain.name;
        value = rec {

          script = makeUpdateScript domain;
          service = makeService domain script;
          timer = makeTimer domain;
        };
      };

    in listToAttrs (map makeConfig cfg.domains);

    # Collect all the generated configuration values.
    scripts = map (config: config.script) (attrValues updaterConfigs);
    services = listToAttrs (map (config: config.service) (attrValues updaterConfigs));
    timers = listToAttrs (map (config: config.timer) (attrValues updaterConfigs));

  in mkIf (cfg.enable) {

    # Ensure all the domains have the required values.
    assertions = [

      { 
        assertion = (all (domain: domain.name != "") cfg.domains); 
        message = "There are domains in the Duck DNS configuration without a name."; 
      }

      { 
        assertion = (all (domain: domain.token != "") cfg.domains); 
        message = "There are domains in the Duck DNS configuration without a token."; 
      }    
    ];

    # Define a system user and group to run the updater service.
    environment.systemPackages = scripts;
    systemd.services = services;
    systemd.timers = timers;
  };
}
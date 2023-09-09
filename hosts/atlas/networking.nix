{ config, lib, pkgs, ... } @ args: let

  inherit (lib) mkDefault;

in {

  modules.networking.duckdns = {

    enable = false;
    domains = [

      {
        name = "the name of the duckdns domain";
        token = "fill this when secrets are ready.";
      }
    ];
  };

  networking = {

    wireless.enable = false;
    hostName = "atlas";

    defaultGateway = "192.168.25.1";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    
    interfaces = {

      eno2.ipv4.addresses = [

        {
          address = "192.168.25.50";
          prefixLength = 24;
        }
      ];
    };

  };
}
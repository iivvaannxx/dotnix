{ config, lib, pkgs,... } @ args: let 

  # Import the theme definitions.
  themes = import ./themes.nix args;
  currentTheme = themes.catppuccin.mocha;

in {

  import = [

    currentTheme
  ];
  
  shell = {

    program = "${pkgs.bashInteractive}/bin/bash";
    args = [ "-l" ];
  };

  window = {

    padding = {
      
      x = 12;
      y = 12;
    };

    opacity = 0.95;
    startup_mode = "Windowed";
  };

  font = {

    normal = {
      
      family = "FiraCode Nerd Font";
      style = "Medium";
    };

    bold = {
      
      family = "FiraCode Nerd Font";
      style = "Bold";
    };
  };

  cursor = {

    style = {

      shape = "Beam";
      blinking = "Always";
      
      thickness = 0.25;
    };
  };

  live_config_reload = false;
}
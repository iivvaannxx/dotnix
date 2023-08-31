{ config, lib, ... } @ args: {
  
  shell = {

    program = "${config.programs.zsh.package}/bin/zsh";
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
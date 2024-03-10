{ config, lib, ... } @ args: let 

  inherit (lib.custom) removeAllChars;

  # Default value for disabled configuration modules.
  disabledConfig = { disabled = true; };
  unicode = ''\'' + "u";

in {

  format = lib.concatStrings [
  
    "[┌───](bold white)"
    "[ ░▒▓](#596bd2)"
    "(bg:#596bd2 fg:#ffffff)$env_var$time"
    "[ ](#596bd2)$all"
    "[│](bold white)\n"
    "[└─](bold white)$character"
  ];

  add_newline = true;

  character = {

    success_symbol = "[ >>>](bold white)";
    error_symbol = "[ >>>](bold red)";
  };

  username = {

    format = "[$user]($style) ";
    style_user = "white bold";
    style_root = "red bold";
  };

  time = {

    format = "[ $time ]($style)";
    time_format = "%R";

    style = "bg:#596bd2 fg:#ffffff";
  };

  directory = {
    
    format = "[at $path]($style)[$read_only]($read_only_style) ";
    style = "bold #ff4d4d";

    read_only = "  ";
    read_only_style = "197";
    truncation_length = 3;
    truncation_symbol = "…/";
  };

  nix_shell = {

    symbol = "❄️ ";
  };

  custom.direnv = {

    format = "[\\[direnv\\]]($style) ";
    style = "fg:yellow dimmed";
    when = "env | grep -E '^DIRENV_FILE='";
  };

  package = disabledConfig;
  container = disabledConfig;
}

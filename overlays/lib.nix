# This overlay defines an extended set of functions of the general Nix 'lib' functions.
final: prev: { 
  
  # All our custom functions are defined in the 'custom' attribute of the lib.
  custom = import ../lib { 
    lib = final; 
  }; 
}
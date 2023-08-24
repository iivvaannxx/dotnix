# This overlay defines an extended set of functions of the general Nix 'lib' functions.
final: prev: { 
  
  custom = import ../lib { 
    
    lib = final; 
  }; 
}
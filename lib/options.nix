{ lib }: let

  # See: https://ryantm.github.io/nixpkgs/functions/library/options/#sec-functions-library-options
  inherit (lib) mkOption types;

in {
  
  # Shorthand for creating boolean options in custom modules.
  mkBoolOption = default: description: (

    mkOption {

      inherit default description;
      type = types.bool;
    }
  );

  # Shorthand for creating string options in custom modules.
  mkStrOption = default: description: (

    mkOption {

      inherit default description;
      type = types.str;
    }
  );

  # Shorthand for creating string lists options in custom modules.
  mkStrListOption = default: description: (

    mkOption {

      inherit default description;
      type = types.listOf types.str;
    }
  );

  # Shorthand for creating dynamic submodules in custom modules. (ex: my.module.<anything here>)
  mkDynamicAttrsetOption = default: description: mkSubmodule: (

    mkOption {

      inherit default description;
      type = types.attrsOf (types.submodule mkSubmodule);
    }
  );
}
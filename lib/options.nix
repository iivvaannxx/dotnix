{ lib }: let

  # See: https://ryantm.github.io/nixpkgs/functions/library/options/#sec-functions-library-options
  inherit (lib) mkOption types;

in {
  
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

  # Shorthand for creating submodule options in custom modules.
  mkSubmoduleOption = default: description: submodule: (

    mkOption {

      inherit default description;
      type = types.submodule { options = submodule; };
    }
  );

  # Shorthand for creating submodule options in custom modules.
  mkSubmoduleWithConfigOption = default: description: submodule: config: (

    mkOption {

      inherit default description;
      type = types.submodule { inherit config; options = submodule; };
    }
  );

  # Shorthand for creating submodule lists options in custom modules.
  mkSubmoduleListOption = default: description: submodule: (

    mkOption {

      inherit default description;
      type = types.listOf (types.submodule { options = submodule; });
    }
  );

  # Shorthand for creating dynamic submodules in custom modules. (ex: my.module.<anything here>)
  mkDynamicAttrsetOption = default: description: mkSubmodule: (

    mkOption {

      inherit default description;
      type = types.attrsOf (types.submodule mkSubmodule);
    }
  );

  # Shorthand for creating package lists options in custom modules.
  mkPackageListOption = default: description: (

    mkOption {

      inherit default description;
      type = types.listOf types.package;
    }
  );
}
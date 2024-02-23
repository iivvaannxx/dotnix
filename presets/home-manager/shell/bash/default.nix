# -------------------------------------------------------------------------------------------------
#
#   Configuration preset for the Bash module.
#
#   See: https://nixos.wiki/wiki/Bash
#   Module: https://github.com/nix-community/home-manager/blob/master/modules/programs/bash.nix
#
# -------------------------------------------------------------------------------------------------

{ config, lib, pkgs, upkgs, profile, ... } @ args: let

  inherit (lib) mkDefault concatStringsSep mapAttrsToList;
  sourceAbbreviations = import ../abbreviations.nix;

  transformAbbr = name: value: "ble-sabbrev ${name}=\"${value}\"";
  abbreviations = concatStringsSep "\n" (mapAttrsToList transformAbbr sourceAbbreviations);

in {

  programs.bash = {

    enable = mkDefault true;
    enableCompletion = mkDefault true;

    historyControl = mkDefault [ "ignoredups" ];
    shellAliases = import ../aliases.nix;

    # TODO: Move Ble.sh to a separate module.
    initExtra = ''

      source "${pkgs.blesh}/share/blesh/ble.sh" --rcfile "$HOME/.blerc"
      
      # We need to start starship after ble.sh has been sourced and before attaching. TODO: Do it in a better way.
      eval "$(/etc/profiles/per-user/iivvaannxx/bin/starship init bash --print-full-init)"

      [[ ''${BLE_VERSION-} ]] && ble-attach
    '';
  };

  home.file.".blerc".text = abbreviations + ''

    ble-face auto_complete=fg=#777,bg=transparent
    ble-face command_builtin='fg=teal'
    ble-face syntax_error='fg=203,bg=transparent'

    # See R5: https://github.com/akinomyoga/ble.sh/wiki/Recipes
    function ble/widget/my/magic-space-auto-appender {
      local my_oei=''${_ble_edit_ind}   # Old Edit Index
      _ble_edit_ind=''${#_ble_edit_str}
      ble/widget/magic-space
      _ble_edit_ind=$my_oei
      "''${@/#/ble/widget/}"
    }

    # Assuming you were using the default bindings for C-m at the start:
    ble-bind -m 'vi_imap' -f 'C-m' 'my/magic-space-auto-appender accept-single-line-or-newline'
    ble-bind -m 'vi_nmap' -f 'C-m' 'my/magic-space-auto-appender accept-single-line-or vi-command/forward-first-non-space'
  '';
}
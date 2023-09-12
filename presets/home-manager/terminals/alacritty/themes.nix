{ lib, pkgs, ... } @ args: let 

  inherit (lib) fakeSha256;

  # See: https://github.com/catppuccin/alacritty
  catppuccinFlavours = pkgs.fetchFromGitHub {

    owner = "catppuccin";
    repo = "alacritty";

    rev = "406dcd431b1e8866533798d10613cdbab6568619";
    sha256 = "RyxD54fqvs0JK0hmwJNIcW22mhApoNOgZkyhFCVG6FQ=";
  };

in {

  catppuccin = {

    latte = "${catppuccinFlavours}/catppuccin-latte.yml";
    mocha = "${catppuccinFlavours}/catppuccin-mocha.yml";
    frappe = "${catppuccinFlavours}/catppuccin-frappe.yml";
    macchiato = "${catppuccinFlavours}/catppuccin-macchiato.yml";
  };
}
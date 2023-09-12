{ lib, pkgs, ... }: let

  # See: https://github.com/vigneshwaranr/bd
  source = pkgs.fetchFromGitHub {

    owner = "vigneshwaranr";
    repo = "bd";

    rev = "4277ad8483357ccfa95264f4084fff9cf7887097";
    sha256 = "Trdp9z4eDVK4ZiB3iRgXNj2csaJgMmyOndZGsvsMDXQ=";
  };

in pkgs.writeShellScriptBin "bd" (builtins.readFile "${source}/bd")

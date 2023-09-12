{ lib, pkgs, ... } @ args: {

  catppuccinSyntaxHighlighting = pkgs.fetchFromGitHub {

    owner = "catppuccin";
    repo = "zsh-syntax-highlighting";

    rev = "06d519c20798f0ebe275fc3a8101841faaeee8ea";
    sha256 = "Q7KmwUd9fblprL55W0Sf4g7lRcemnhjh4/v+TacJSfo=";
  };
}
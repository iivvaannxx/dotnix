{ lib, pkgs, ...} @ args: [

  { 
    name = "zsh-abbr";
    src = pkgs.fetchFromGitHub {

      owner = "olets";
      repo = "zsh-abbr";

      rev = "b3a851eb373778a5556f09e57e1006febb5f6c74";
      sha256 = "SPE6BILF0BERZvxqXUkxbAFTNDzecRyqlIpTIuclIKA=";
    };
  }
]
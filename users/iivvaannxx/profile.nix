{
  # The general data of this user.
  username = "iivvaannxx";
  fullName = "Ivan Porto Wigner";
  email = "dev.ivanporto@gmail.com";

  github = {

    noReplyEmail = "47715589+iivvaannxx@users.noreply.github.com";
  };

  # Override the system options for 'users.users.iivvaannxx'.
  systemUserOverride = {

    extraGroups = [ "wheel" "networkmanager" "docker" ];
    openssh.authorizedKeys.keys = [

      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPshwMIRwRubSwCXEvwIfozcKefxEqFHFlgR0Dq+Mxet iivvaannxx@atlas"
    ];
  };
}
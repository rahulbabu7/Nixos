{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  users.users.rahul = {
    isNormalUser = true;
    extraGroups = [ "wheel" "power" "video" "audio" "networkmanager" ];
  };
}

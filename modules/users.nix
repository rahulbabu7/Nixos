{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  users.users.rahul = {
    isNormalUser = true;
    extraGroups = [ "wheel" "power" "video" "audio" "networkmanager" ];

    # Only system-critical packages here
    # User packages managed by Home Manager
    packages = with pkgs; [
      flatpak
    ];
  };
}

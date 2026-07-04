# /etc/nixos/modules/boot.nix
{ config, pkgs, lib, ... }:
{
  boot.loader.systemd-boot.enable = lib.mkForce false ;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  environment.systemPackages = with pkgs; [
    sbctl
  ];
  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
}

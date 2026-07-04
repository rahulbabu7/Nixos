# /etc/nixos/modules/boot.nix
{ config, pkgs, lib, ... }:
{
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.limine.enable = true;
  environment.systemPackages = [ pkgs.sbctl ];

  

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
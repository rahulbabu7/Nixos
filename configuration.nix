# /etc/nixos/configuration.nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/boot.nix
    ./modules/networking.nix
    ./modules/locale.nix
    ./modules/audio.nix
    ./modules/bluetooth.nix
    ./modules/desktop.nix
    ./modules/flatpak.nix
    ./modules/garbage.nix
    ./modules/git.nix
    ./modules/users.nix
    ./modules/packages.nix
    ./modules/fonts.nix
    ./modules/shell.nix
    # ./modules/nvidia.nix
  ];

  # Unstable channel overlay — gives access to pkgs.unstable.*
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import <nixpkgs-unstable> {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    })
  ];

  # Point nixos-rebuild at this repo so `sudo nixos-rebuild switch` works
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/rahul/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  # Firewall
  networking.firewall.enable = true;

  # SSH
  services.openssh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Do NOT change this value
  system.stateVersion = "25.11";
}

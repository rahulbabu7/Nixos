# /etc/nixos/configuration.nix
{
  config,
  lib,
  pkgs,
  ...
}:

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
    # ./modules/git.nix
    ./modules/users.nix
    ./modules/nvidia.nix
  ];

  # Firewall
  networking.firewall.enable = true;

  # SSH
  services.openssh.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Do NOT change this value
  system.stateVersion = "25.11";
}

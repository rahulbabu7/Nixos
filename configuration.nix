# Shared base config — imported by all hosts
{ ... }:

{
  imports = [
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
    ./modules/fonts.nix
  ];

  networking.firewall.enable = true;
  # services.openssh.enable = true;  # enable only if you need to SSH into this machine
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Do NOT change this value
  system.stateVersion = "26.05";
}

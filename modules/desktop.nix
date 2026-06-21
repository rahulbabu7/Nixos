# /etc/nixos/modules/desktop.nix
{ config, pkgs, ... }:

{
  # Niri Wayland compositor
  programs.niri.enable = true;

  # Display manager
  services.displayManager.ly.enable = true;

  # Touchpad support
  services.libinput.enable = true;

  # XDG portals for Wayland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # DBus (required for Wayland sessions)
  services.dbus.enable = true;

  # Required by Noctalia shell
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}

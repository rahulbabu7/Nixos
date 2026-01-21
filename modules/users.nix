# /etc/nixos/modules/users.nix
{ config, pkgs, ... }:

# let
#   unstable = import <nixos-unstable> {
#     config = { allowUnfree = true; };
#   };
# in
{
  nixpkgs.config.allowUnfree = true;
  users.users.rahul = {
    isNormalUser = true;
    extraGroups = [ "wheel" "power" "video" "audio" "networkmanager" ];
    packages = with pkgs; [
#       tree
#       niri
#       waybar
      flatpak
#       kitty
#       fuzzel
#       xdg-desktop-portal-gtk
#       xdg-desktop-portal-gnome
#       xdg-desktop-portal-kde
#       ly
      nano
      fastfetch
#       kdePackages.dolphin
      stow
#       swaylock
#       swaybg
      unstable.zed-editor
#       kdePackages.breeze
#       kdePackages.breeze-icons
      #libsForQt5.qt5ct
#       kdePackages.qt6ct
#       nwg-look
#       brightnessctl
#       pulseaudio
#       pavucontrol
#       mako
#       libnotify
#       playerctl
      python313
      nodejs_24
      emacs
      lazygit
      btop
      ripgrep
      fd
      uv

#       nvtop
    ];
  };
}

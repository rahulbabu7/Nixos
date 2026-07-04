# AMD + NVIDIA laptop
{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nvidia.nix
    # ./secureboot-windows.nix
  ];

  
  networking.hostName = "nixos";
  nixpkgs.hostPlatform = "x86_64-linux";
}

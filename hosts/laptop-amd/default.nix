# AMD only laptop
{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixosBtw";
  nixpkgs.hostPlatform = "x86_64-linux";
}

# /etc/nixos/modules/locale.nix
{ config, ... }:

{
  # Set your time zone
  time.timeZone = "Asia/Kolkata";
  services.timesyncd.enable = true;
  time.hardwareClockInLocalTime = true;
  i18n.defaultLocale = "en_US.UTF-8";

  boot.blacklistedKernelModules = [ "acpi_tad" ];



  # sudo flatpak override --env=TZ=Asia/Kolkata
  # sudo flatpak override --filesystem=/etc/localtime:ro
  # sudo flatpak override --filesystem=/etc/zoneinfo:ro
  #
  # Do this to get IST timing on apps
}

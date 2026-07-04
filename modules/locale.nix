# /etc/nixos/modules/locale.nix
{ config, ... }:

{
  # Set your time zone
  time.timeZone = "Asia/Kolkata";
  time.hardwareClockInLocalTime = true;
  i18n.defaultLocale = "en_US.UTF-8";
}

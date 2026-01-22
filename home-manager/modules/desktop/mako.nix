{ config, pkgs, ... }:

{
  services.mako = {
    enable = true;
    catppuccin.enable = true;
    defaultTimeout = 5000;
    groupBy = "app-name";
    maxVisible = 5;
    anchor = "top-right";
    borderRadius = 10;
    borderSize = 2;
    padding = "12";
    margin = "12";
  };
}

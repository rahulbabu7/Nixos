{ config, pkgs, ... }:

{
  # Link to your existing niri config in ~/Config
  xdg.configFile."niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Config/niri/.config/niri/config.kdl";
}

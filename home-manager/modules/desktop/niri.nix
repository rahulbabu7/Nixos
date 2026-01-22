{ config, pkgs, ... }:

{
  xdg.configFile."niri/config.kdl" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Config/niri/.config/niri/config.kdl";
    force = true;  # This forces Home Manager to overwrite
  };
}

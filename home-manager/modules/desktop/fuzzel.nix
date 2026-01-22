{ config, pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    catppuccin.enable = true;

    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        prompt = "❯ ";
        lines = 10;
        width = 40;
        horizontal-pad = 20;
        vertical-pad = 12;
        inner-pad = 10;
      };
      border = {
        width = 2;
        radius = 10;
      };
    };
  };
}

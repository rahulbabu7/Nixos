{ config, ... }:

let
  home = config.home.homeDirectory;
  link = path: config.lib.file.mkOutOfStoreSymlink "${home}/Config/${path}";
in
{
  # Symlink configs directly from ~/Config — edit files there, changes apply immediately

  xdg.configFile = {
    "kitty".source    = link "kitty/.config/kitty";
    "niri".source     = link "niri/.config/niri";
    "noctalia".source = link "noctalia/.config/noctalia";
    "zed".source      = link "zed/.config/zed";
    "helix".source    = link "helix/.config/helix";
    "fuzzel".source   = link "fuzzel/.config/fuzzel";
    "mako".source     = link "mako/.config/mako";
  };

  # tmux config lives at ~/.tmux.conf in your Config folder
  xdg.configFile."tmux/tmux.conf".source = link "tmux/.tmux.conf";
}

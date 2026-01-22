{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    catppuccin.enable = true;
    prefix = "C-a";
    mouse = true;
    baseIndex = 1;
    terminal = "screen-256color";

    extraConfig = ''
      # Easier splitting
      bind h split-window -h
      bind v split-window -v

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      # Move between panes with Alt + arrow keys
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Move between windows
      bind -n C-Left previous-window
      bind -n C-Right next-window
    '';
  };
}

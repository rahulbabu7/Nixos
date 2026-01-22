{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    catppuccin.enable = true;

    font = {
      name = "Lilex";
      size = 15.0;
    };

    settings = {
      linux_display_server = "wayland";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      disable_ligatures = "never";
      cursor_shape = "beam";
      cursor_blink_interval = 0;
      scrollback_lines = 10000;
      repaint_delay = 6;
      sync_to_monitor = "yes";
      window_padding_width = 6;
      confirm_os_window_close = 0;
      tab_bar_style = "fade";
      tab_fade = 1;
      active_tab_font_style = "bold";
      inactive_tab_font_style = "bold";
      enable_audio_bell = "no";
      visual_bell_duration = "0.1";
      background_opacity = "0.95";
    };
  };
}

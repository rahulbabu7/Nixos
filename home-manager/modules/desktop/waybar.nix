{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    catppuccin.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        height = 30;
        spacing = 4;

        modules-left = [ "niri/workspaces" "custom/media" ];
        modules-center = [ "niri/window" ];
        modules-right = [
          "pulseaudio" "network" "backlight"
          "battery" "clock" "tray"
        ];

        "niri/workspaces" = {
          all-outputs = false;
          format = "{index}";
        };

        "niri/window" = {
          format = "{}";
          max-length = 50;
        };

        clock = {
          format = "🕐 {:%H:%M}";
          format-alt = "📅 {:%d-%m-%Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        battery = {
          states = { warning = 30; critical = 15; };
          format = "{icon} {capacity}%";
          format-full = "🔋 {capacity}%";
          format-charging = "⚡ {capacity}%";
          format-plugged = "🔌 {capacity}%";
          format-icons = [ "🪫" "🔋" ];
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [ "🔅" "🔆" ];
        };

        network = {
          format-wifi = "📶 {essid} ({signalStrength}%)";
          format-ethernet = "🌐 {ipaddr}/{cidr}";
          format-disconnected = "❌ Disconnected";
        };

        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = { default = [ "🔈" "🔉" "🔊" ]; };
          on-click = "pavucontrol";
        };

        "custom/media" = {
          format = "{text}";
          return-type = "json";
          max-length = 40;
          escape = true;
          exec = "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' 2>/dev/null || echo '{\"text\":\"\"}'";
          interval = 1;
          on-click = "playerctl play-pause";
        };

        tray = { spacing = 10; };
      };
    };

    style = ''
      @define-color base   #1e1e2e;
      @define-color text   #cdd6f4;
      @define-color surface0 #313244;
      @define-color surface2 #585b70;

      * {
        font-family: "JetBrainsMono Nerd Font", sans-serif;
        font-size: 14px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: @base;
        color: @text;
      }

      #workspaces button {
        padding: 2px 8px;
        margin: 0 4px;
        background-color: transparent;
        color: @surface2;
        border-radius: 6px;
      }

      #workspaces button.active {
        background-color: @surface0;
        color: @text;
      }

      #clock, #battery, #backlight, #network, #pulseaudio, #tray, #custom-media {
        padding: 0 10px;
        margin: 0 2px;
        background-color: @surface0;
        color: @text;
        border-radius: 6px;
      }
    '';
  };
}

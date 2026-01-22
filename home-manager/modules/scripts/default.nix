{ config, pkgs, ... }:

{
  home.file = {

    # =========================
    # Timeshift backup script
    # =========================
    ".local/bin/backup-timeshift" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        # Create a Timeshift system backup
        sudo timeshift \
          --create \
          --comments "Full Backup with /home" \
          --tags O \
          --snapshot-device /dev/sda1
      '';
    };

    # =========================
    # Rsync home backup
    # =========================
    ".local/bin/backup-home-rsync" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        # Back up /home
        sudo rsync -a --progress /home/ /mnt/home_backup/
      '';
    };

    # =========================
    # Sway idle script
    # =========================
    ".local/bin/sway-idle" = {
      executable = true;
      text = ''
        #!/usr/bin/env sh

        # Start swayidle with custom lock script
        swayidle -w \
          timeout 300 "$HOME/.local/bin/swaylock-pic-and-wallpaper sleep" \
          timeout 600 'swaymsg "output * dpms off"' \
          resume 'swaymsg "output * dpms on"' \
          before-sleep "$HOME/.local/bin/swaylock-pic-and-wallpaper sleep"

        exit 0
      '';
    };

    # =========================
    # Swaylock with wallpaper
    # =========================
    ".local/bin/swaylock-pic-and-wallpaper" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        WALLPAPER="$HOME/Pictures/Wallpapers/japan-background-digital-art.jpg"

        if [ ! -f "$WALLPAPER" ]; then
          echo "Wallpaper file does not exist: $WALLPAPER"
          exit 1
        fi

        if [ "$1" != "sleep" ] && [ "$1" != "hibernate" ]; then
          echo "Usage: $0 {sleep|hibernate}"
          exit 1
        fi

        if pgrep -x swaylock > /dev/null; then
          pkill swaylock
          sleep 1
        fi

        swaylock \
          -i "$WALLPAPER" \
          --indicator-radius 50 \
          --indicator-thickness 4 \
          --indicator-idle-visible \
          --indicator-caps-lock \
          --ring-color 000000FF \
          --inside-color 222222FF \
          --key-hl-color FF0000FF \
          --bs-hl-color 00FF00FF \
          --line-color 444444FF \
          --separator-color 888888FF \
          --daemonize &

        sleep 1

        if [ "$1" = "sleep" ]; then
          systemctl suspend
        else
          systemctl hibernate
        fi
      '';
    };

    # =========================
    # Auto Bluetooth connect
    # =========================
    ".local/bin/auto-bluetooth-connect" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        DEVICE="72:37:2D:07:AD:F0"
        TIMEOUT=30
        START_TIME=$(date +%s)

        bluetoothctl << EOF
        power on
        agent on
        scan on
        EOF

        while true; do
          if bluetoothctl devices | grep -q "$DEVICE"; then
            echo "Device found, connecting..."
            bluetoothctl connect "$DEVICE"
            break
          fi

          CURRENT_TIME=$(date +%s)
          if [ $((CURRENT_TIME - START_TIME)) -ge "$TIMEOUT" ]; then
            echo "Timeout reached. Device not found."
            break
          fi

          sleep 1
        done
      '';
    };

    # =========================
    # Random swaybg wallpaper
    # =========================
    ".local/bin/swaybg-random" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash

        WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

        # Ensure wallpaper directory exists
        if [ ! -d "$WALLPAPER_DIR" ]; then
          mkdir -p "$WALLPAPER_DIR"
          echo "Wallpaper directory created at $WALLPAPER_DIR"
          echo "Add some wallpapers and run again."
          exit 0
        fi

        # Kill existing swaybg instances
        pkill -x swaybg 2>/dev/null

        # Pick a random wallpaper
        RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \
          \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)

        if [ -z "$RANDOM_WALLPAPER" ]; then
          echo "No wallpapers found in $WALLPAPER_DIR"
          exit 1
        fi

        # Set wallpaper for all outputs
        swaybg -i "$RANDOM_WALLPAPER" -m fill &

        echo "🖼️  Wallpaper set: $RANDOM_WALLPAPER"

        exit 0
      '';
    };


  };
}

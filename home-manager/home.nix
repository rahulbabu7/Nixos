{
  config,
  pkgs,
  nixpkgs-unstable,
  ...
}:

{
  imports = [
    ./modules/shell/bash.nix
    ./modules/shell/git.nix
    ./modules/editors/doom-emacs.nix
    ./modules/editors/zed.nix
    ./modules/terminal/kitty.nix
    ./modules/terminal/tmux.nix
    ./modules/desktop/kde.nix
    # ./modules/desktop/niri.nix
    # ./modules/desktop/waybar.nix
    # ./modules/desktop/mako.nix
    # ./modules/desktop/fuzzel.nix
    # ./modules/scripts/default.nix
  ];

  home = {
    username = "rahul";
    homeDirectory = "/home/rahul";
    stateVersion = "25.11";

    packages = with pkgs; [
      # System utilities
      fastfetch
      btop
      nano
      stow

      cifs-utils
      # Development
      python313
      nodejs_24
      uv
      ripgrep
      fd
      lazygit
      # emacs
      home-manager
      # Wayland tools
      wl-clipboard
      wl-clipboard-x11
      grim
      slurp
      swappy

      # Media & System controls
      playerctl
      brightnessctl
      pavucontrol
      home-manager
      # Wallpaper tools
      # swaybg
      # swaylock

      # Fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      noto-fonts
      noto-fonts-color-emoji
      lilex
      liberation_ttf
      font-awesome
    ];

    sessionVariables = {
      EDITOR = "emacsclient -c -a emacs";
      VISUAL = "emacsclient -c -a emacs";
      TERMINAL = "kitty";
      PATH = "$HOME/.local/bin:$HOME/.emacs.d/bin:$PATH";
      CARGO_HOME = "$HOME/.cargo";
    };
  };

  # Global Catppuccin theme
  catppuccin = {
    enable = true;
    flavor = "mocha"; # Change to "latte" for light theme
    accent = "blue";
  };

  # XDG directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      templates = "${config.home.homeDirectory}/Templates";
      publicShare = "${config.home.homeDirectory}/Public";
    };
  };

  programs.home-manager.enable = true;
}

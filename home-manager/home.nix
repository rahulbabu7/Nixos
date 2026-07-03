{ config, pkgs, ... }:

{
  imports = [
    ./modules/shell/bash.nix
    ./modules/shell/git.nix
    ./modules/editors/zed.nix
    ./modules/terminal/kitty.nix
    ./modules/terminal/tmux.nix
    ./modules/configs.nix
  ];

  home = {
    username = "rahul";
    homeDirectory = "/home/rahul";
    stateVersion = "26.05";

    packages = with pkgs; [
      # System utilities
      fastfetch
      btop
      nano
      cifs-utils

      # Development
      python313
      nodejs_24
      uv
      ripgrep
      fd
      helix

      # Wayland / screenshot tools
      wl-clipboard
      wl-clipboard-x11
      grim
      slurp
      swappy

      # Media & system controls
      playerctl
      brightnessctl
      pavucontrol

      # Desktop shell
      noctalia-shell

    ];

    sessionVariables = {
      EDITOR = "nano";
      VISUAL = "zed";
      TERMINAL = "kitty";
      CARGO_HOME = "$HOME/.cargo";
      PATH = "$HOME/.local/bin:$PATH";
    };
  };

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

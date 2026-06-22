{ pkgs, ... }:

{
  # Emacs needs system-level setup for vterm/pdf-tools to build correctly
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
    extraPackages = epkgs: with epkgs; [
      vterm
      pdf-tools
    ];
  };

  # True system-level tools — available to all users and root
  environment.systemPackages = with pkgs; [
    ripgrep
    fd
    nano

    # LSP & language tools (used by Emacs at system level)
    nil
    pyright
    nixpkgs-fmt
    black
    shellcheck
    imagemagick
    pandoc
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
    nodePackages.typescript-language-server
    nodePackages.bash-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    nodePackages.prettier
    nodePackages.eslint
    nodePackages.js-beautify
  ];

  # Personal packages — only for rahul
  users.users.rahul.packages = with pkgs; [
    # System utilities
    fastfetch
    btop
    stow
    cifs-utils
    lazygit

    # Development
    python313
    nodejs_24
    uv

    # Editors & terminals
    kitty
    tmux
    unstable.zed-editor

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
}

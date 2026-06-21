{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
    extraPackages = epkgs: with epkgs; [
      vterm
      pdf-tools
    ];
  };

  environment.systemPackages = with pkgs; [
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
    git

    # Editors & terminals
    kitty
    tmux
    unstable.zed-editor

    # LSP & language tools (used by Emacs / Zed)
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

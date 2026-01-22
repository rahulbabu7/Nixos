{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      ll = "ls -lah";
      la = "ls -A";
      l = "ls -CF";

      # NixOS
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos#nixos";
      update = "cd ~/nixos && nix flake update && sudo nixos-rebuild switch --flake ~/nixos#nixos";
      test-rebuild = "sudo nixos-rebuild test --flake ~/nixos#nixos";
      clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      optimize = "nix-store --optimize";

      # Git
      g = "git";
      gs = "git status";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit";
      gcm = "git commit -m";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      gb = "git branch";
      lg = "lazygit";

      # Editors
      e = "emacsclient -c -a emacs";
      et = "emacsclient -t";
      ec = "emacsclient -c";
      z = "zed";

      # System
      cpu = "btop";
      ports = "sudo netstat -tulanp";
      cleanup = "sudo journalctl --vacuum-time=7d";

      # Directory shortcuts
      dl = "cd ~/Downloads";
      doc = "cd ~/Documents";
      dev = "cd ~/Development";
      conf = "cd ~/nixos";
    };

    bashrcExtra = ''
      # Git branch in prompt
      parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
      }

      # Colored prompt with git branch
      PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[33m\]$(parse_git_branch)\[\033[00m\]\$ '

      # History configuration
      export HISTSIZE=50000
      export HISTFILESIZE=100000
      export HISTCONTROL=ignoreboth:erasedups
      export HISTTIMEFORMAT="%F %T "

      # Bash options
      shopt -s histappend
      shopt -s checkwinsize
      shopt -s cdspell

      # Better completion
      bind 'set completion-ignore-case on' 2>/dev/null
      bind 'set show-all-if-ambiguous on' 2>/dev/null

      # Custom functions
      mkcd() {
        mkdir -p "$1" && cd "$1"
      }

      extract() {
        if [ -f "$1" ]; then
          case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.tar.xz)    tar xJf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "Cannot extract '$1'" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }

      hs() {
        history | grep "$1"
      }

      killp() {
        ps aux | grep "$1" | grep -v grep | awk '{print $2}' | xargs kill -9
      }
    '';
  };
}

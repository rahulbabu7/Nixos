{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;

    # Updated: new option names
    settings = {
      user.name = "rahulbabu7";
      user.email = "rahulbabu436@gmail.com";

      init.defaultBranch = "main";
      core = {
        editor = "emacsclient -c -a emacs";
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
      };
      pull.rebase = false;
      push = {
        autoSetupRemote = true;
        default = "current";
        followTags = true;
      };
      fetch.prune = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      rebase.autoStash = true;
      rerere.enabled = true;
      help.autocorrect = 1;
    };

    # Ignores remain the same
    ignores = [
      ".DS_Store" "Thumbs.db" "*~" "*.swp" "*.swo"
      ".vscode/" ".zed" ".idea/" "*.code-workspace"
      "*.pyc" "__pycache__/" "node_modules/" "dist/" "build/" ".next/"
      ".env" ".env.*" ".envrc"
      "*.log" "npm-debug.log*"
      ".direnv/"
    ];
  };

  # Delta is now a top-level program
  programs.delta = {
    enable = true;
    enableGitIntegration = true;   # Must be explicit now

    options = {
      navigate = true;
      light = false;
      side-by-side = true;
      line-numbers = true;
      syntax-theme = "Catppuccin-mocha";

      # Force your preferred features
      features = lib.mkForce "decorations";

      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-style = "bold yellow ul";
        file-decoration-style = "none";
        hunk-header-decoration-style = "cyan box ul";
      };
    };
  };

   programs.lazygit = {
    enable = true;
#     catppuccin.enable = true;

    settings = {
      gui = {
        showFileTree = true;
        showRandomTip = false;
        nerdFontsVersion = "3";
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
        # ADDED: New pagers array format (migration requirement)
        pagers = [
          {
            diff = "delta --dark --paging=never";
          }
          {
            log = "delta --dark --paging=never";
          }
          {
            show = "delta --dark --paging=never";
          }
        ];
        commit.signOff = false;
        autoFetch = true;
        autoRefresh = true;
      };
      refresher = {
        refreshInterval = 10;
        fetchInterval = 60;
      };
      update.method = "never";
    };
  };
}


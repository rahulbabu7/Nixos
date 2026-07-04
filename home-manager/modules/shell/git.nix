{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    

    settings = {
      user.name = "rahulbabu7";
      user.email = "rahulbabu436@gmail.com";
      init.defaultBranch = "main";
      core = {
        editor = "nano";
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

    ignores = [
      ".DS_Store" "Thumbs.db" "*~" "*.swp" "*.swo"
      ".vscode/" ".zed/" ".idea/" "*.code-workspace"
      "*.pyc" "__pycache__/" "node_modules/" "dist/" "build/" ".next/"
      ".env" ".env.*" ".envrc"
      "*.log" "npm-debug.log*"
      ".direnv/"
    ];
  };

  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = true;
      line-numbers = true;
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showFileTree = true;
        showRandomTip = false;
        nerdFontsVersion = "3";
      };
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never";
      };
      update.method = "never";
    };
  };
}

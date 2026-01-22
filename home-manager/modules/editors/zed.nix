{ config, pkgs, nixpkgs-unstable, ... }:

let
  unstablePkgs = import nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  home.packages = [ unstablePkgs.zed-editor ];

  xdg.configFile."zed/settings.json".text = builtins.toJSON {
    theme = {
      mode = "system";
      light = "Catppuccin Latte";
      dark = "Catppuccin Mocha";
    };

    ui_font_size = 20;
    ui_font_family = "Noto Sans";
    buffer_font_size = 16;
    buffer_font_family = "Fira Code";
    buffer_line_height = { custom = 1.5; };
    vim_mode = false;
    relative_line_numbers = true;
    tab_size = 2;
    hard_tabs = false;
    soft_wrap = "editor_width";
    show_whitespaces = "selection";
    remove_trailing_whitespace_on_save = true;
    ensure_final_newline_on_save = true;
    format_on_save = "on";
    auto_update = true;
    base_keymap = "VSCode";
    icon_theme = "Material Icon Theme";

    indent_guides = {
      enabled = true;
      coloring = "indent_aware";
    };

    preview_tabs = { enabled = false; };
    autosave = { after_delay = { milliseconds = 100; }; };

    terminal = {
      shell = "system";
      font_family = "Fira Code";
      font_size = 14;
      line_height = { custom = 1.4; };
      copy_on_select = true;
    };

    git = {
      git_gutter = "tracked_files";
      inline_blame = {
        enabled = true;
        show_commit_summary = true;
        padding = 7;
      };
      hunk_style = "unstaged_hollow";
    };

    lsp = {
      pyright = {
        settings = {
          python = {
            analysis = {
              diagnosticMode = "workspace";
              typeCheckingMode = "strict";
            };
            pythonPath = ".venv/bin/python";
          };
        };
      };
      vue-language-server = {
        initialization_options = {
          typescript = {
            tsdk = "/home/rahul/.npm-global/lib/node_modules/typescript/lib";
          };
          vue = {
            hybridMode = false;
            autoInsert = true;
            autoCompleteRefs = true;
          };
        };
      };
      eslint = {
        settings = {
          codeActionOnSave = {
            enable = true;
            mode = "all";
          };
        };
      };
    };

    languages = {
      Python = {
        tab_size = 4;
        formatter = "language_server";
        format_on_save = "on";
        language_servers = [ "pyright" ];
      };
      JavaScript = {
        tab_size = 2;
        format_on_save = "on";
        formatter = {
          external = {
            command = "prettier";
            arguments = [ "--stdin-filepath" "{buffer_path}" ];
          };
        };
        code_actions_on_format = { "source.fixAll.eslint" = true; };
      };
      TypeScript = {
        tab_size = 2;
        format_on_save = "on";
        formatter = {
          external = {
            command = "prettier";
            arguments = [ "--stdin-filepath" "{buffer_path}" ];
          };
        };
        code_actions_on_format = { "source.fixAll.eslint" = true; };
      };
      TSX = {
        tab_size = 2;
        format_on_save = "on";
        formatter = {
          external = {
            command = "prettier";
            arguments = [ "--stdin-filepath" "{buffer_path}" ];
          };
        };
        code_actions_on_format = { "source.fixAll.eslint" = true; };
      };
      "Vue.js" = {
        tab_size = 2;
        format_on_save = "on";
        formatter = {
          external = {
            command = "prettier";
            arguments = [ "--stdin-filepath" "{buffer_path}" ];
          };
        };
        code_actions_on_format = { "source.fixAll.eslint" = true; };
      };
    };

    telemetry = {
      metrics = false;
      diagnostics = false;
    };
  };

  xdg.configFile."zed/keymap.json".text = builtins.toJSON [
    {
      context = "Workspace";
      bindings = {};
    }
    {
      bindings = {
        "ctrl-h" = "pane::SplitHorizontal";
        "ctrl-j" = "pane::SplitVertical";
      };
    }
  ];

  xdg.configFile."zed/snippets/vue.js.json".text = builtins.toJSON {
    vue3 = {
      prefix = "vue3";
      description = "vue3 structure";
      body = [
        "<script setup lang=\"\${1|ts,js|}\">"
        "$0"
        "</script>"
        ""
        "<template>"
        "  <section>"
        "    "
        "  </section>"
        "</template>"
        ""
        "<style scoped>"
        ""
        "</style>"
      ];
    };
  };
}

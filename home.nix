{ config, pkgs, ... }:

let
  iosevka = pkgs.iosevka.override {
    set = "custom";
    privateBuildPlan = {
      family = "Iosevka Kitty";
      spacing = "normal";
      serifs = "sans";
      no-cv-ss = false;
      exportGlyphNames = true;
      ligations = {
        "inherits" = "haskell";
      };
    };
  };
in

{
  home = {
    stateVersion = "22.11";

    homeDirectory = "/home/ollie";

    file.".jjconfig.toml".text = ''
      [core]
      fsmonitor = "watchman"

      [ui]
      diff.tool = ["difft", "--color=always", "$left", "$right"]
      pager="less -SFRX"

      [user]
      name = "Ollie Charles"
      email = "ollie@ocharles.org.uk"

      [revset-aliases]
      'MINE' = 'author(ocharles)'
      'MY_HEAD' = '((visible_heads() & ::MINE & (~empty() | merges())) | @)'
      'MAIN' = '(present("main") | present("master"))'
      'DEFAULT' = "MAIN | (::MY_HEAD~::MAIN) | (::MY_HEAD~::MAIN)-"

      [revsets]
      log = "DEFAULT | root()"

      [snapshot]
      max-new-file-size = '4MiB'
    '';

    packages = with pkgs; [
      asciinema
      alloy5
      ardour
      emacs29-gtk3
      entr
      esphome
      fd
      file
      gdb
      gh
      gimp
      git-crypt
      gitAndTools.git-annex
      gitAndTools.hub
      graphviz
      guitarix
      google-chrome
      kdeconnect
      konsole
      jj
      # logseq
      meld
      ncdu
      nomad
      mpv
      remmina
      nix-diff
      nixpkgs-fmt
      ntfs3g
      okular
      picard
      qjackctl
      quodlibet-full
      restic
      ripgrep
      spectacle
      sqlite
      tlaplusToolbox
      tokei
      unrar
      unzip
      vlc
      wireshark
      simplescreenrecorder
      tree-grepper
      watchman
      viu
      fzf
      fuzzel
      sioyek
      swaybg
      swaynotificationcenter
    ];

    sessionVariables = {
      EDITOR = "hx";
    };

    username = "ollie";
  };

  fonts.fontconfig.enable = true;

  programs = {
    bat.enable = true;

    broot.enable = true;

    btop.enable = true;

    command-not-found.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    firefox.enable = true;

    fish = {
      enable = true;
      plugins = [
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      ];
      shellAliases = {
        icat = "kitty +kitten icat";
        ssh = "kitty +kitten ssh";
      };
    };

    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_mocha";
        editor = {
          cursorline = true;
          rulers = [ 100 ];
          gutters = [ "diagnostics" "spacer" "line-numbers" "diff" ];
          color-modes = true;
          bufferline = "always";
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
          smart-tab.supersede-menu = true;
        };
      };
    };

    home-manager.enable = true;

    htop.enable = true;

    git = {
      enable = true;
      difftastic.enable = true;
      aliases = {
        force-push = "push --force-with-lease";
      };
      userName = "Ollie Charles";
      userEmail = "ollie@ocharles.org.uk";
      extraConfig = {
        merge.conflictstyle = "diff3";
      };
    };

    jq.enable = true;

    starship = {
      enable = true;
      enableFishIntegration = true;
    };

    kitty = {
      enable = true;

      font = {
        name = "Iosevka Kitty Medium";
        package = iosevka;

        # name = "Berkeley Mono Bold";
      };

      extraConfig = ''
        font_size 12.0
        # modify_font cell_height 2px
        tab_bar_style powerline
        window_margin_width 0
        include ${pkgs.catppuccin-kitty}/themes/macchiato.conf

        map ctrl+shift+enter launch --type window --cwd last_reported
      '';
    };

    zoxide.enable = true;

    waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";

          modules-left = [ "wlr/taskbar" ];
          modules-center = [ "clock" ];
          modules-right = [ "wireplumber" ];

          wireplumber = {
            scroll-step = 5.0;
          };

          clock = {
            format-alt = "{:%a, %d. %b  %H:%M}";
          };
        };
      };
    };

    niri.settings = {
      prefer-no-csd = true;

      input = {
        warp-mouse-to-focus = true;
      };

      spawn-at-startup = [
        { command = [ "waybar" ]; }
        { command = [ "swaync" ]; }
        { command = [ "swaybg" "-i" "/home/ollie//Downloads/macos-big-sur-apple-layers-fluidic-colorful-wwdc-stock-4096x2304-1455.jpg" ]; }
      ];

      cursor = {
        theme = "Breeze_Snow";
        size = 24;
      };

      layout = {
        center-focused-column = "on-overflow";
      };

      window-rules = [
        {
          clip-to-geometry = true;
          geometry-corner-radius = {
            bottom-left = 6.0;
            bottom-right = 6.0;
            top-left = 6.0;
            top-right = 6.0;
          };
        }

        {
          matches = [{ is-active = false; }];
          opacity = 1.00;
        }
      ];

      outputs."DP-3" = {
        scale = 1.0;

        mode = {
          width = 2560;
          height = 1440;
          refresh = 165.0;
        };
      };

      binds = with config.lib.niri.actions; {
        "Mod+Shift+Slash".action = show-hotkey-overlay;

        "Mod+T".action = spawn "kitty";
        "Mod+D".action = spawn "fuzzel";

        "Mod+Q".action = close-window;
        "Mod+Shift+E".action = quit;
        "Mod+Shift+P".action = power-off-monitors;

        "Mod+Left".action = focus-column-left;
        "Mod+Down".action = focus-window-or-workspace-down;
        "Mod+Up".action = focus-window-or-workspace-up;
        "Mod+Right".action = focus-column-right;

        "Mod+Ctrl+Left".action = move-column-left;
        "Mod+Ctrl+Down".action = move-window-down-or-to-workspace-down;
        "Mod+Ctrl+Up".action = move-window-up-or-to-workspace-up;
        "Mod+Ctrl+Right".action = move-column-right;

        "Mod+Home".action = focus-column-first;
        "Mod+End".action = focus-column-last;
        "Mod+Ctrl+Home".action = move-column-to-first;
        "Mod+Ctrl+End".action = move-column-to-last;

        "Mod+Shift+Left".action = focus-monitor-left;
        "Mod+Shift+Down".action = focus-monitor-down;
        "Mod+Shift+Up".action = focus-monitor-up;
        "Mod+Shift+Right".action = focus-monitor-right;
        "Mod+Shift+H".action = focus-monitor-left;
        "Mod+Shift+J".action = focus-monitor-down;
        "Mod+Shift+K".action = focus-monitor-up;
        "Mod+Shift+L".action = focus-monitor-right;

        "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
        "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;

        "Mod+U".action = focus-workspace-down;
        "Mod+I".action = focus-workspace-up;
        "Mod+Ctrl+U".action = move-column-to-workspace-down;
        "Mod+Ctrl+I".action = move-column-to-workspace-up;

        "Mod+Shift+U".action = move-workspace-down;
        "Mod+Shift+I".action = move-workspace-up;

        "Mod+Shift+WheelScrollDown" = {
          action = focus-workspace-down;
          cooldown-ms = 150;
        };

        "Mod+Shift+WheelScrollUp" = {
          action = focus-workspace-up;
          cooldown-ms = 150;
        };

        "Mod+Ctrl+Shift+WheelScrollDown" = {
          action = move-column-to-workspace-down;
          cooldown-ms = 150;
        };

        "Mod+Ctrl+Shift+WheelScrollUp" = {
          action = move-column-to-workspace-up;
          cooldown-ms = 150;
        };

        "Mod+WheelScrollDown".action = focus-column-right;
        "Mod+WheelScrollUp".action = focus-column-left;
        "Mod+Ctrl+WheelScrollDown".action = move-column-right;
        "Mod+Ctrl+WheelScrollUp".action = move-column-left;

        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;
        "Mod+Ctrl+1".action = move-column-to-workspace 1;
        "Mod+Ctrl+2".action = move-column-to-workspace 2;
        "Mod+Ctrl+3".action = move-column-to-workspace 3;
        "Mod+Ctrl+4".action = move-column-to-workspace 4;
        "Mod+Ctrl+5".action = move-column-to-workspace 5;
        "Mod+Ctrl+6".action = move-column-to-workspace 6;
        "Mod+Ctrl+7".action = move-column-to-workspace 7;
        "Mod+Ctrl+8".action = move-column-to-workspace 8;
        "Mod+Ctrl+9".action = move-column-to-workspace 9;

        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;

        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;

        "Mod+R".action = switch-preset-column-width;
        "Mod+Shift+R".action = reset-window-height;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+C".action = center-column;

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";

        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        "Print".action = screenshot;
        "Ctrl+Print".action = screenshot-screen;
        "Alt+Print".action = screenshot-window;
      };
    };
  };

  services.mako.enable = true;
  services.rsibreak.enable = true;
}

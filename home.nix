{ inputs, config, pkgs, ... }:

# let
#   iosevka = pkgs.iosevka.override {
#     set = "custom";
#     privateBuildPlan = {
#       family = "Iosevka Kitty";
#       spacing = "normal";
#       serifs = "sans";
#       no-cv-ss = false;
#       exportGlyphNames = true;
#       ligations = {
#         "inherits" = "haskell";
#       };
#     };
#   };
# in

{
  home = {
    stateVersion = "22.11";

    homeDirectory = "/home/ollie";

    file.".jjconfig.toml".text = ''
      [core]
      fsmonitor = "watchman"

      [ui]
      diff-editor = "meld-3"
      diff-formatter = ["difft", "--color=always", "$left", "$right"]
      pager="less -SFRX"
      movement.edit = true

      [user]
      name = "Ollie Charles"
      email = "ollie@ocharles.org.uk"

      [snapshot]
      max-new-file-size = '4MiB'

      [templates]
      commit_trailers = 'if(!trailers.contains_key("Change-Id"), format_gerrit_change_id_trailer(self))'
      git_push_bookmark = '"ollie/jj-" ++ change_id.short()'
    '';


    packages = with pkgs; [
      asciinema
      alloy5
      ardour
      # emacs29-gtk3
      entr
      # esphome
      fd
      file
      gdb
      gh
      gimp
      git-crypt
      graphviz
      guitarix
      google-chrome
      kdePackages.konsole
      jujutsu
      # logseq
      ghostty
      meld
      ncdu
      nomad
      mpv
      remmina
      nix-diff
      nixpkgs-fmt
      ntfs3g
      kdePackages.okular
      picard
      qjackctl
      quodlibet-full
      restic
      ripgrep
      kdePackages.spectacle
      sqlite
      terragrunt
      tlaplusToolbox
      tokei
      unrar
      unzip
      vlc
      wireshark
      simplescreenrecorder
      # tree-grepper
      watchman
      viu
      fzf
      fuzzel
      sioyek
      swaybg
      swaynotificationcenter
      swayosd
      xwayland-satellite-unstable
      # scryer-prolog
      zotero_7
    ];

    sessionVariables = {
      EDITOR = "hx";
    };

    username = "ollie";
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;

    cursorTheme = {
      name = "Breeze_Snow";
      size = 24;
    };

    font = {
      name = "Sans";
      size = 10;
    };
  };

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
          end-of-line-diagnostics = "hint";
          inline-diagnostics = {
            cursor-line = "warning";
          };
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
        name = "Iosevka Medium";
        package = pkgs.iosevka;
        # name = "PragmataPro Mono";
        # name = "Berkeley Mono Bold";
      };

      extraConfig = ''
        font_size 11.0
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

          modules-left = [ "niri/workspaces" ];
          modules-center = [ "niri/window"];
          modules-right = [ "clock" "battery" "wireplumber" ];

          wireplumber = {
            scroll-step = 5.0;
          };

          clock = {
            format-alt = "{:%a, %d. %b  %H:%M}";
          };
        };
      };
      style = ''
        * {
          border: none;
          border-radius: 0;
          font-weight: 600;
          font-size: 12px;
          min-height: 0;
          font-family: "PragmataPro"
        }

        #waybar {
          background: transparent;
          padding-left: 30px;
        }

        #waybar > box {
          background: rgba(30, 30, 46, 0.6);
          margin: 0px; 
          padding: 0px;
          box-shadow: 7.5px 7.5px 0px 0px rgba(30, 30, 46, 0.44);
          border-radius: 0px;
          margin: 12.5px;
          margin-bottom: 7.5px;
          border-radius: 4px;
        }

        #battery, #wireplumber, #clock, #workspaces button, #window {
          padding: 5px 10px;
          color: rgb(205, 214, 244);
        }

        #workspaces button:first-child {
          border-radius: 4px 0px 0px 4px;
        }

        #workspaces button.active {
          background: rgb(166, 227, 161);
          color: rgb(30, 30, 46);
        }

        .muted {
          background: rgb(231, 130, 132);
        }
      '';
    };

    noctalia-shell = {
      enable = true;
    };

    niri.settings = {
      prefer-no-csd = true;

      input = {
        warp-mouse-to-focus = true;
        keyboard.xkb.layout = "engrammer,enthium,us";

        touchpad = {
          dwt = true;
          tap-button-map = "left-right-middle";
          click-method = "clickfinger";
        };
      };

      spawn-at-startup = [
        # { command = [ "waybar" ]; }
        { command = [ "noctalia-shell" ]; }
        # { command = [ "swaync" ]; }
        # { command = [ "swaybg" "-i" "/home/ollie/Downloads/macos-big-sur-apple-layers-fluidic-colorful-wwdc-stock-4096x2304-1455.jpg" ]; }
        # { command = [ "swayosd-server" ]; }
      ];

      cursor = {
        theme = "Breeze_Snow";
        size = 24;
      };

      hotkey-overlay.skip-at-startup = true;

      layout = {
        center-focused-column = "on-overflow";
        focus-ring.width = 2.0;
        shadow = {
          enable = true;
          softness = 0.0;
          spread = 1.0;
          offset = rec { x = 7.5; y = x; };
        };
        struts = rec {
          left = 20;
          right = left;
        };
      };

      window-rules = [
        {
          clip-to-geometry = true;
          geometry-corner-radius = rec {
            bottom-left = 1.0;
            bottom-right = bottom-left;
            top-left = bottom-left;
            top-right = bottom-left;
          };
        }

        {
          matches = [{ is-active = false; }];
          opacity = 0.96;
        }
      ];

      outputs = {
        "F5CWCP3" = {
          mode = {
            width = 2560;
            height = 1440;
            refresh = 120.000;
          };
          position = {
            x = 0;
            y = -1440;
          };
        };

        "eDP-1" = {
          scale = 1.5;

          mode = {
            width = 2256;
            height = 1504;
            refresh = 60.0;
          };

          position = {
            x = 0;
            y = 0;
          };
        };
      };

      binds = with config.lib.niri.actions; {
        "XF86AudioRaiseVolume".action = spawn "noctalia-shell" "ipc" "call" "volume" "increase";
        "XF86AudioLowerVolume".action = spawn "noctalia-shell" "ipc" "call" "volume" "decrease";
        "XF86AudioMute".action = spawn "noctalia-shell" "ipc" "call" "volume" "muteOutput";

        "XF86MonBrightnessUp".action = spawn "noctalia-shell" "ipc" "call" "brightness" "increase";
        "XF86MonBrightnessDown".action = spawn "noctalia-shell" "ipc" "call" "brightness" "decrease";

        "Mod+Shift+Slash".action = show-hotkey-overlay;

        "Mod+T".action = spawn "ghostty";
        "Mod+D".action = spawn "fuzzel";

        "Mod+L".action = switch-layout "next";

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
        # "Mod+Ctrl+1".action = move-column-to-workspace 1;
        # "Mod+Ctrl+2".action = move-column-to-workspace 2;
        # "Mod+Ctrl+3".action = move-column-to-workspace 3;
        # "Mod+Ctrl+4".action = move-column-to-workspace 4;
        # "Mod+Ctrl+5".action = move-column-to-workspace 5;
        # "Mod+Ctrl+6".action = move-column-to-workspace 6;
        # "Mod+Ctrl+7".action = move-column-to-workspace 7;
        # "Mod+Ctrl+8".action = move-column-to-workspace 8;
        # "Mod+Ctrl+9".action = move-column-to-workspace 9;

        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;

        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;

        "Mod+R".action = switch-preset-column-width;
        "Mod+Shift+R".action = reset-window-height;
        "Mod+F".action = maximize-column;
        "Mod+M".action.maximize-window-to-edges = [];
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+C".action = center-column;

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";

        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        "Print".action.screenshot = [];
        "Ctrl+Print".action.screenshot-screen = [];
        "Alt+Print".action.screenshot-window = [];
      };
    };
  };

  services.mako.enable = true;

  services.syncthing = {
    enable = true;
  };
}

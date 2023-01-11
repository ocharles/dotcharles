{ config, pkgs, ... }:

let
  iosevka = pkgs.iosevka.override {
    set = "custom";
    privateBuildPlan = {
      family = "Iosevka Kitty";
      spacing = "normal";
      serifs = "sans";
      no-cv-ss = false;
      export-glyph-names = true;

      ligations = {
        "inherits" = "haskell";
      };
    };
  };
in

{
  home = {
    homeDirectory = "/home/ollie";
    username = "ollie";

    sessionVariables = {
      EDITOR = "hx";
    };

    packages = with pkgs; [
      alloy5
      ardour
      fd
      file
      gdb
      gh
      git-crypt
      gitAndTools.git-annex
      gitAndTools.hub
      guitarix
      iosevka
      kdeconnect
      konsole
      nix-diff
      ntfs3g
      okular
      picard
      qjackctl
      restic
      ripgrep
      spectacle
      sqlite
      tlaplusToolbox
      tokei
      unzip
      vlc
      zotero
    ];
    stateVersion = "21.05";
  };

  fonts.fontconfig.enable = true;

  programs = {
    bat.enable = true;
    broot.enable = true;
    command-not-found.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    emacs = {
      enable = false;
      extraPackages = epkgs: [ epkgs.vterm ];
      overrides = self: super: {
        emacs-libvterm =
          super.emacs-libvterm.overrideAttrs (old: {
            src = builtins.fetchGit https://github.com/akermu/emacs-libvterm;
          });
      };
      package = pkgs.emacsGit;
    };
    firefox.enable = true;
    fish.enable = true;
    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_mocha";
        editor = {
          cursorline = true;
          rulers = [ 100 ];
          gutters = [ "diagnostics" "spacer" "line-numbers" "diff" ];
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          lsp.display-messages = true;
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
      font = { name = "Iosevka Kitty"; package = iosevka; };
      # font = { name = "Berkeley Mono Regular"; };

      # include ${
      #   pkgs.fetchurl {
      #     url = https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/kitty_tokyonight_storm.conf;
      #     sha256 = "0vidpk1ridlakz776pgz4lxkmq5xn75ghsr9a2krh9zlm1r264jh";
      #   }
      # }

      extraConfig = ''
        font_size 16.0
        modify_font cell_height 2px
        tab_bar_style powerline
        window_margin_width 3
        include ${
          pkgs.fetchurl {
            url = https://raw.githubusercontent.com/catppuccin/kitty/main/macchiato.conf;
            sha256 = "sha256-lk0ca7An8GSCbBMYTb/y37RogsidZRajTt12R+/z2Ls=";
          }
        }
      '';
    };
    zoxide.enable = true;
  };

  # xdg.configFile.nvim = {
  #   source = /home/ollie/config/nvim;
  #   recursive = true;
  # };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      input = {
        "*" = {
          xkb_layout = "dvorak";
        };
      };
    };
  };
}

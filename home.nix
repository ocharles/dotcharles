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
      log = "DEFAULT | root"
    '';

    packages = with pkgs; [
      asciinema
      alloy5
      ardour
      entr
      esphome
      fd
      file
      gdb
      gh
      gimp
      git-branchless
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
      unzip
      vlc
      wireshark
      simplescreenrecorder
      tree-grepper
      watchman
      viu
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

      font = {
        name = "Iosevka Kitty Medium";
        package = iosevka;

        # name = "Berkeley Mono Bold";
      };

      extraConfig = ''
        font_size 14.0
        # modify_font cell_height 2px
        tab_bar_style powerline
        window_margin_width 0
        include ${pkgs.catppuccin-kitty}/themes/macchiato.conf

        map ctrl+shift+enter new_window_with_cwd
      '';
    };

    zoxide.enable = true;
  };
}

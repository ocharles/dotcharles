{ lib, config, pkgs, ... }:
{ boot =
    { loader =
        { timeout =
            10;

          grub =
            { enable =
                true;

                version =
                  2;

                device =
                  "/dev/sdb";

                extraEntries =
                    ''
                    menuentry "Homomorphic Operating System" {
                      search --set=drive1 --fs-uuid ab9aaeac-5265-4f2d-8316-d348de35f7d1
                      search --set=drive2 --fs-uuid ab9aaeac-5265-4f2d-8316-d348de35f7d1
                      linux ($drive2)/nix/store/dxq85h6fvvm5q5bwff40kyp4lxsdafzx-linux-4.9.66/bzImage init=/home/ollie/work/homomorphic-operating-system/Main
                    }

                    menuentry "Windows 10" --class windows --class os {
                      insmod ntfs
                      search --no-floppy --set=root --fs-uuid E6E44CCAE44C9EA5
                      ntldr /bootmgr
                    }
                    '';
            };
        };
    };

  environment.systemPackages =
    with pkgs;
    [ adobe-reader
      cabal-install
      cabal2nix
      dmenu
      dropbox
      emacs
      firefox
      gitAndTools.git
      gitAndTools.git-annex
      glxinfo
      haskellPackages.xmobar
      nixops
      stalonetray
      wget
    ];

  imports =
    [ ./desktop/hardware-configuration.nix
      ../private/machines/desktop.nix
    ];

  fonts.fonts =
    with pkgs;
    [ fira-code iosevka terminus_font ];

  hardware =
    { pulseaudio =
        { daemon.config.flat-volumes =
            "no";

          enable =
            true;
        };

      enableAllFirmware =
        true;

      opengl.driSupport32Bit =
        true;
    };

  i18n =
    { consoleFont =
        "Lat2-Terminus16";

      consoleKeyMap =
        "dvorak";

      defaultLocale =
        "en_GB.UTF-8";
    };

  networking =
    { firewall.enable =
        false;

      hostName =
        "nixos-desktop";

      networkmanager =
        { enable =
            true;

          insertNameservers =
            [ "192.168.100.1" ];
        };
    };

  nix =
    { binaryCachePublicKeys =
        [ "hydra.cryp.to-1:8g6Hxvnp/O//5Q1bjjMTd5RO8ztTsG8DKPOAg9ANr2g="
          "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
          "mpickering.cachix.org-1:COxPsDJqqrggZgvKG6JeH9baHPue8/pcpYkmcBPUbeg="
        ];

      trustedUsers =
        [ "root" "ollie" ];

      buildCores =
        4;

      maxJobs =
        2;

      requireSignedBinaryCaches =
        false;

      binaryCaches =
        [ https://cache.nixos.org https://mpickering.cachix.org ];

      trustedBinaryCaches =
        [ https://hydra.nixos.org https://cache.nixos.org ];

      distributedBuilds =
        true;

      buildMachines =
        [];
    };

  nixpkgs.config.allowUnfree =
    true;

  programs =
    { ssh.startAgent =
        true;

      zsh.enable =
        true;
    };

  security.sudo.enable =
    true;

  services =
    { xserver =
        { dpi =
            192;

          monitorSection =
            ''
            DisplaySize 527 296
            '';

          desktopManager.plasma5.enable =
            true;

          displayManager.lightdm.enable =
            true;

          enable =
            true;
        };

      journald =
        { rateLimitBurst =
            0;

          rateLimitInterval =
            "0";
        };

      rabbitmq =
        { enable =
            true;

          plugins =
            [ "rabbitmq_management" ];
        };

      redis =
        { enable =
            true;
        };

      udev.extraRules =
        ''
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="3b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl", GROUP="users"
        '';

      openssh.enable =
        true;

      redshift =
        { enable =
            false;

          latitude =
            "51.5072";

          longitude =
            "0.1275";

          temperature =
            { night =
                2750;
            };
        };

      postgresql =
        { authentication =
            lib.mkForce
              ''
              local   all             all                                     trust
              host    all             all             127.0.0.1/32            trust
              host    all             all             ::1/128                 trust
              '';

          enable =
            true;

          package =
            pkgs.postgresql95;

          extraConfig =
            ''
            log_min_duration_statement = 0
            track_activity_query_size=16384
            log_line_prefix = '%c'
            '';
        };

      earlyoom.enable =
        true;

      ntp.enable =
        true;
    };

  system.stateVersion =
    "16.09";

  users.extraUsers.ollie =
    { isNormalUser =
        true;

      uid =
        1000;

      extraGroups =
        [ "wheel" "docker" ];

      shell =
        "${pkgs.zsh}/bin/zsh";
    };

  time.timeZone =
    "Europe/London";

  virtualisation =
    { docker.enable =
        true;

      virtualbox.host.enable =
        true;
    };
}

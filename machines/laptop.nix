{ config, pkgs, ... }:

let inherit (pkgs) callPackage;

in {
  imports = [
    ./laptop-hardware-configuration.nix
    ../private/nix/picofactory-vpn.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    virtualbox.enableExtensionPack = true;
  };

  boot = {
    cleanTmpDir = true;
    blacklistedKernelModules = [ "nvidiafb" ];
    initrd.kernelModules = [ "i915" ];
    loader.grub = {
      device = "/dev/sda";
    };
    kernel.sysctl = {
      "kernel.shmmax" = 1073741824;
    };
    extraModprobeConfig = ''
      thinkpad_acpi fan_control=1
    '';
  };

  environment.systemPackages = with pkgs; [
    adobe-reader
    cabal2nix
    dmenu
    dropbox
    emacs
    evince
    git
    haskellPackages.cabal-install
    termite
  ];

  hardware = {
    enableAllFirmware = true;
    bluetooth.enable = true;
    # bumblebee.enable = true;
    opengl.driSupport32Bit = true;
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      configFile = ./laptop/pulseaudio.pa;
    };
  };

  fonts.enableDefaultFonts = true;
  fonts.fonts = [ pkgs.fira-code pkgs.fira-mono pkgs.terminus_font ];

  i18n = {
    consoleKeyMap = "dvorak";
    defaultLocale = "en_GB.UTF-8";
  };

  networking = {
    firewall.enable = false;
    # networkmanager = {
    #   enable = true;
    #   insertNameservers = [ "192.168.100.1" ];
    # };
    connman.enable = true;
  };

  nix = {
    binaryCaches = [
      http://cache.nixos.org
    ] ++ import ../private/nix/caches.nix;
    binaryCachePublicKeys = [
      "hydra.cryp.to-1:8g6Hxvnp/O//5Q1bjjMTd5RO8ztTsG8DKPOAg9ANr2g="
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
      "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
      "hydra.example.org-1:yf8eZWbIuUdbGSe3K53Y8y6YRg/hURFcKrOxPhpu7TA="
    ];
    extraOptions = ''
      build-cores = 2
      auto-optimise-store = true
    '';
    requireSignedBinaryCaches = false;
    trustedBinaryCaches = ([
      http://52.50.40.204:3000
      http://hydra.nixos.org
      http://hydra.cryp.to
      https://ryantrinkle.com:5443/
      http://192.168.2.181
      http://localhost:10000
      https://cachix.cachix.org
    ] ++ import ../private/nix/caches.nix
    );
    maxJobs = 4;
    buildMachines = [
      { hostName = "139.162.196.136"; maxJobs = 1; sshKey = "/root/.ssh/id_buildfarm"; sshUser = "root"; system = "x86_64-linux"; }
    ];
  };

  services = {
    earlyoom.enable = true;

    emacs = {
      enable = true;
      install = true;
    };

    virtualboxHost = {
      #enable = true;
    };

    acpid = {
      enable = true;
    };

    journald = {
      rateLimitBurst = 0;
      rateLimitInterval = "0";
    };

    locate = {
      enable = true;
    };

    # mysql = {
    #   enable = true;
    #   package = pkgs.mysql;
    #   extraOptions = ''
    #     max_allowed_packet = 64M
    #   '';
    # };

    postgresql = {
      enable = true;
      enableTCPIP = true;
      authentication = pkgs.lib.mkForce ''
        local all all              trust
        host  all all 127.0.0.1/32 trust
        host  all all ::1/128      trust
      '';
      package = pkgs.postgresql95;
      extraConfig = ''
        maintenance_work_mem = 64MB
        work_mem = 128MB
        shared_buffers = 512MB
        effective_cache_size = 4GB
        log_statement = all
        log_min_duration_statement = 1
        log_line_prefix = '[%p] [%c]: '
      '';
    };

    rabbitmq = {
      enable = true;
      plugins = [ "rabbitmq_management" ];
    };

    redshift = {
      enable = true;
      latitude = "51.5072";
      longitude = "0.1275";
      temperature = {
        night = 2750;
      };
    };

    xserver = {
      # dpi = 157;
      # monitorSection = ''
      #  DisplaySize 301 174
      #'';
      displayManager.lightdm.enable = true;
      enable = true;
      synaptics = {
        enable = false;
        palmDetect = true;
      };
      libinput.enable = true;
      desktopManager.xfce = {
        enable = true;
        noDesktop = true;
      };
      windowManager.xmonad = {
        enable = true;
        extraPackages = hs: [
          hs.xmonad-contrib
          hs.xmonad-extras
        ];
      };
      xkbVariant = "dvorak";
    };

    illum.enable = true;

    # postfix = {
    #   enable = true;
    #   extraConfig = ''virtual_maps = hash:/etc/postfix/virtual, regexp:/etc/postfix/virtual-regexp'';
    # };

    redis = {
      enable = true;
    };
  };

  time.timeZone = "Europe/London";

  sound.mediaKeys.enable = true;

  services.xserver.config =
    ''
    Section "InputClass"
      Identifier "t440p touchpad"
      MatchDriver "synaptics"
      Option "PalmDetect" "on"
      Option "AreaTopEdge" "45%"
      Option "SoftButtonAreas" "60% 0 0 45% 40% 60% 0 45%"
    EndSection
    '';

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", GROUP=="users"
    ACTION=="remove", GOTO="usb3vision_end"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{bDeviceClass}=="ef", ATTR{bDeviceSubClass}=="02", ATTR{bDeviceProtocol}=="01", ENV{ID_USB_INTERFACES}=="*:ef0500:*", GROUP="video" TAG+="uaccess" TAG+="udev-acl"
    LABEL="usb3vision_end"

    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", ATTRS{idVendor}=="2c97"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", ATTRS{idVendor}=="2581"

    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="3b7c", MODE="0660", TAG+="uaccess", TAG+="udev-acl"

    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1b7c", MODE="0660", GROUP="users"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="2b7c", MODE="0660", GROUP="users"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="3b7c", MODE="0660", GROUP="users"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="4b7c", MODE="0660", GROUP="users"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1807", MODE="0660", GROUP="users"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1808", MODE="0660", GROUP="users"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0000", MODE="0660", GROUP="users"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001", MODE="0660", GROUP="users"
  '';

  services.teamviewer.enable = true;

  services.thinkfan.enable = true;
  services.thinkfan.sensor = "/sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input";

  programs = {
    adb.enable = true;
    zsh.enable = true;
    ssh.startAgent = true;
  };

  users.users.ollie = {
    isNormalUser = true;
    shell = "${pkgs.zsh}/bin/zsh";
    extraGroups = [ "wheel" ];
  };

  virtualisation.docker.enable = true;

  powerManagement.powertop.enable = true;

  system.stateVersion = "17.03";

  hardware.trackpoint = {
    enable = true;
    emulateWheel = true;
  };

}

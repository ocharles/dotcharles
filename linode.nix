{ config, lib, pkgs, modulesPath, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
      ./machine.nix
    ];

  boot = {
    loader = {
      grub = {
        enable = true;
        extraConfig = ''
          serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
          terminal_input serial;
          terminal_output serial
        '';
        forceInstall = true;
        device = "nodev";
      };
      timeout = 10;
    };
    initrd = {
      availableKernelModules = [ "virtio_pci" "virtio_scsi" "ahci" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
    kernelParams = [ "console=ttyS0,19200n8" ];
  };

  networking = {
    usePredictableInterfaceNames = false;
    useDHCP = false;
    interfaces.eth0.useDHCP = true;
    firewall.enable = false;
  };

  services = {
    consul = {
      enable = true;
      extraConfig = {
        bootstrap_expect = 1;
        datacenter = "linode";
        server = true;
      };
      interface.bind = "tailscale0";
      webUi = true;
    };

    nomad = {
      enable = true;
      dropPrivileges = false;

      settings = {
        advertise = {
          http = "100.66.127.89";
          rpc = "100.66.127.89";
          serf = "100.66.127.89";
        };
        datacenter = "linode";
        server = {
          bootstrap_expect = 1;
          enabled = true;
        };
        client = {
          options."docker.volumes.enabled" = true;

          enabled = true;
          host_volume = {
            blog = {
              path = "/nix/store/m8k1mz35mmvrdq9xq19zc8h78cmzkmix-ocharles.org.uk-blog-1";
              read_only = true;
            };
            letsencrypt = {
              path = "/var/lib/letsencrypt";
              read_only = false;
            };
          };
        };
      };
    };

    openssh = {
      enable = true;
    };

    tailscale.enable = true;
  };

  system.stateVersion = "24.05";

  fileSystems."/" =
    {
      device = "/dev/sda";
      fsType = "ext4";
    };

  swapDevices = [
    { device = "/dev/sdb"; }
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  virtualisation.docker.enable = true;
}

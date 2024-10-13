{ config, lib, pkgs, modulesPath, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
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
        datacenter = "linode";
        server = true;
        peering.enabled = false;
      };
      interface.bind = "tailscale0";
      webUi = true;
    };

    nomad = {
      enable = true;
      settings = {
        advertise = {
          http = "100.66.127.89";
          rpc = "100.66.127.89";
          serf = "100.66.127.89";
        };
        datacenter = "linode";
        server = {
          enabled = true;
        };
        client = {
          enabled = true;
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

}

{ config, pkgs, ... }:

{
  hardware.bluetooth.enable = true;

  imports = [
    ./machine.nix
    ./media-server/hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    firewall.enable = false;
    hostName = "quantock-media";
    networkmanager.enable = true;
  };

  services = {
    plex = {
      enable = true;
      user = "ollie";
      group = "users";
    };

    openssh.enable = true;
  };

  system.stateVersion = "19.09";

  virtualisation.docker.enable = true;

  services.consul = {
    enable = true;
    interface.bind = "wlp4s0";
    extraConfig = {
      bootstrap_expect = 1;
      client_addr = "0.0.0.0";
      ui_config.enabled = true;
      connect.enabled = true;
      server = true;
      ports.grpc = 8502;
    };
  };

  services.nomad = {
    package = pkgs.nomad_1_6;
    enable = true;
    dropPrivileges = false;
    extraPackages = [ pkgs.consul ];
    settings = {
      advertise = {
        http = "100.90.122.99";
        rpc = "100.90.122.99";
        serf = "100.90.122.99";
      };
      server = {
        enabled = false;
        bootstrap_expect = 2;
      };
      client = {
        enabled = true;
        cni_path = "${pkgs.cni-plugins}/bin";
        options."docker.volumes.enabled" = true;
        host_volume.syncthing = {
          path = "/var/lib/sync";
          read_only = false;
        };
        host_network.tailscale = {
          interface = "tailscale0";
          cidr = "100.90.122.99/32";
        };
        servers = [ "100.66.127.89" ];
      };
    };
  };

  systemd.services.nomad = {
    bindsTo = [ "sys-subsystem-net-devices-tailscale0.device" ];
    wants = [ "mnt-seedhost.mount" ];
    after = [
      "sys-subsystem-net-devices-tailscale0.device"
      "mnt-seedhost.mount"
      "tailscaled.service"
    ];
  };
}


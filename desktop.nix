{ config, pkgs, ... }:
{
  system.stateVersion = "22.11";

  imports = [
    ./desktop/hardware-configuration.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  hardware.bluetooth.enable = true;
  hardware.nvidia.modesetting.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    users.ollie = import ./home.nix;
  };

  musnix.enable = true;

  networking = {
    hostName = "desktop";
    networkmanager.enable = true;
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "ollie" ];
    substituters = [
      "s3://circuithub-nix-binary-cache?profile=circuithub-binary-cache&region=eu-central-1"
    ];
    trusted-public-keys = [
      "hydra.circuithub.com:tt5GsRxotmMj6nDFuiYGxKEWSZiDiywb0OEDdrfRXZk="
    ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
  programs.ssh.startAgent = true;
  programs.steam.enable = true;
  programs.niri.enable = true;

  security.rtkit.enable = true;

  services = {
    openssh.enable = true;
    tailscale.enable = true;
    earlyoom.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5 = {
        enable = true;
      };
      videoDrivers = [ "nvidia" ];
    };

    redis.enable = true;
  };

  time.timeZone = "Europe/London";

  users.users.ollie = {
    isNormalUser = true;
    extraGroups = [ "audio" "dialout" "realtime" "wheel" ];
    shell = pkgs.fish;
  };

  virtualisation.podman = {
    enable = true;
  };

  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };

  virtualisation.virtualbox.host.enable = true;

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
} 

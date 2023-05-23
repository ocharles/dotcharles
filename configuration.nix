{ config, pkgs, ... }:
{
  system.stateVersion = "22.11";

  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  console.keyMap = "dvorak";

  environment.systemPackages = [ pkgs.libsForQt5.bismuth ];

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

  programs.ssh.startAgent = true;
  programs.steam.enable = true;

  security.rtkit.enable = true;

  services = {
    openssh.enable = true;
    tailscale.enable = true;

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
        supportDDC = true;
      };
      videoDrivers = [ "nvidia" ];
      layout = "dvorak";
    };

    redis.enable = true;
  };

  time.timeZone = "Europe/London";

  users.users.ollie = {
    isNormalUser = true;
    extraGroups = [ "audio" "dialout" "realtime" "wheel" ];
    shell = pkgs.fish;
  };

  virtualisation.virtualbox.host.enable = true;
} 

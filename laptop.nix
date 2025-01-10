{ inputs, config, pkgs, ... }:
{
  system.stateVersion = "24.05";

  imports = [
    ./laptop/main-config.nix
    ./machine.nix
  ];

  hardware.bluetooth.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    users.ollie = import ./home.nix;
    sharedModules = [
      inputs.ags.homeManagerModules.default
      inputs.noctalia.homeModules.default
    ];
  };

  nix.settings = {
    trusted-users = [ "root" "ollie" ];
    substituters = [
      "s3://circuithub-nix-binary-cache?profile=circuithub-binary-cache&region=eu-central-1"
    ];
    trusted-public-keys = [
      "hydra.circuithub.com:tt5GsRxotmMj6nDFuiYGxKEWSZiDiywb0OEDdrfRXZk="
    ];
  };

  programs.steam.enable = true;
  programs.niri.enable = true;

  services = {
    fwupd.enable = true;
    earlyoom.enable = true;
    mullvad-vpn.enable = true;
    resolved.enable = true;

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
      desktopManager.plasma6 = {
        enable = true;
      };
    };

    printing = {
      enable = true;
      drivers = [ pkgs.samsung-unified-linux-driver ];
    };

    redis.enable = true;
  };

  virtualisation.podman = {
    enable = true;
  };

  virtualisation.docker = {
    enable = true;
  };

  virtualisation.virtualbox.host.enable = true;

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
} 

# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.hostId = "b6a01618";

  system.stateVersion = "24.05";

  services.xserver.xkb.extraLayouts.engrammer = {
    description = "Engrammer";
    languages = [ "eng" ];
    symbolsFile = ./engrammer;
  };
}


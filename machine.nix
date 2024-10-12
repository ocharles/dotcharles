{ inputs, config, pkgs, ... }:
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;

  services = {
    tailscale.enable = true;
  };

  time.timeZone = "Europe/London";

  users.users.ollie = {
    isNormalUser = true;
    extraGroups = [ "audio" "dialout" "realtime" "wheel" ];
    shell = pkgs.fish;
  };

  system.activationScripts.diff = ''
    if [[ -e /run/current-system ]]; then
      ${pkgs.nix}/bin/nix store diff-closures /run/current-system "$systemConfig"
    fi
  '';
} 

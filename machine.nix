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
} 

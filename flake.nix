{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-branchless = {
      url = "github:arxanas/git-branchless";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-kitty = {
      url = "github:catppuccin/kitty";
      flake = false;
    };
  };

  outputs = inputs: {
    nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules =
        let
          packageUpgrades = self: super: {
            helix = inputs.helix.packages.x86_64-linux.default;
            git-branchless = inputs.git-branchless.defaultPackage.x86_64-linux;

            inherit (inputs) catppuccin-kitty;
          };

        in
        [
          { nixpkgs.overlays = [ packageUpgrades ]; }
          inputs.home-manager.nixosModule
          inputs.musnix.nixosModules.musnix
          ./configuration.nix
        ];
    };

    formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
  };
}

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
      url = "github:ocharles/helix/tree-sitter-cabal";
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
    tree-grepper = {
      inputs.tree-sitter-haskell.url = "github:tree-sitter/tree-sitter-haskell";
      url = "github:BrianHicks/tree-grepper";
    };
  };

  outputs = inputs:
    let
      overlays = {
        nixpkgs.overlays = [ packageUpgrades ];
      };

      packageUpgrades = self: super: {
        helix = inputs.helix.packages.x86_64-linux.default;
        git-branchless = inputs.git-branchless.defaultPackage.x86_64-linux;
        tree-grepper = inputs.tree-grepper.packages.x86_64-linux.tree-grepper;

        inherit (inputs) catppuccin-kitty;
      };
    in
    {
      nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules =
          [
            overlays
            inputs.home-manager.nixosModule
            inputs.musnix.nixosModules.musnix
            ./configuration.nix
          ];
      };

      homeConfigurations.ollie = inputs.home-manager.lib.homeManagerConfiguration {
        # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1378627909
        pkgs = import inputs.nixpkgs {
          config.allowUnfree = true;
          system = "x86_64-linux";
        };

        modules = [
          overlays
          ./home.nix
        ];
      };

      formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}

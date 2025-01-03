{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
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
    catppuccin-kitty = {
      url = "github:catppuccin/kitty";
      flake = false;
    };
    tree-grepper = {
      inputs.tree-sitter-haskell.url = "github:tree-sitter/tree-sitter-haskell";
      url = "github:BrianHicks/tree-grepper";
    };
    jj = {
      url = "github:martinvonz/jj";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-flake.url = "github:sodiboo/niri-flake";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    ags.url = "github:Aylur/ags";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    scryer.url = "github:mthom/scryer-prolog";
  };

  outputs = inputs:
    let
      overlays = {
        nixpkgs.overlays = [
          inputs.niri-flake.overlays.niri
          inputs.helix.overlays.default
          inputs.jj.overlays.default
          inputs.tree-grepper.overlay.x86_64-linux
          packageUpgrades
        ];
      };

      packageUpgrades = self: super: {
        inherit (inputs) catppuccin-kitty;
        scryer-prolog = inputs.scryer.packages.x86_64-linux.default;
      };
    in
    {
      nixosConfigurations = {
        desktop = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules =
            [
              overlays
              inputs.home-manager.nixosModule
              inputs.musnix.nixosModules.musnix
              inputs.niri-flake.nixosModules.niri
              inputs.nixos-hardware.nixosModules.common-pc-ssd
              inputs.nixos-hardware.nixosModules.common-cpu-intel
              ./desktop.nix
            ];
        };

        laptop = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = { inherit inputs; };

          modules =
            [
              overlays
              inputs.home-manager.nixosModule
              inputs.musnix.nixosModules.musnix
              inputs.niri-flake.nixosModules.niri
              inputs.nixos-hardware.nixosModules.framework-11th-gen-intel
              inputs.lix-module.nixosModules.default
              ./laptop.nix
            ];
        };

        media-server = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = { inherit inputs; };

          modules =
            [
              overlays
              inputs.home-manager.nixosModule
              inputs.musnix.nixosModules.musnix
              inputs.niri-flake.nixosModules.niri
              inputs.nixos-hardware.nixosModules.framework-11th-gen-intel
              inputs.lix-module.nixosModules.default
              ./media-server.nix
            ];
        };

        linode = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./linode.nix
          ];
        };
      };

      formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}

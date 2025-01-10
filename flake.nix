{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
    niri-flake.inputs.niri-stable.url = "github:YaLTeR/niri/v25.11";
    niri-flake.inputs.niri-stable.flake = false;
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    ags.url = "github:Aylur/ags";
    scryer.url = "github:mthom/scryer-prolog";

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      overlays = {
        nixpkgs.overlays = [
          inputs.niri-flake.overlays.niri
          # inputs.helix.overlays.default
          inputs.jj.overlays.default
          inputs.tree-grepper.overlay.x86_64-linux
          packageUpgrades
        ];
      };

      unstable = import inputs.nixpkgs-unstable { system = "x86_64-linux"; };

      packageUpgrades = self: super: {
        inherit (inputs) catppuccin-kitty;
        scryer-prolog = inputs.scryer.packages.x86_64-linux.default;
        ghostty = unstable.ghostty;
        terragrunt = unstable.terragrunt;
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
              inputs.home-manager.nixosModules.default
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
              inputs.home-manager.nixosModules.default
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
              inputs.home-manager.nixosModules.default
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

{
  description = "My home-manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    home-manager = {
      url = "github:nix-community/home-manager";
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
    tree-grepper = {
      url = "github:BrianHicks/tree-grepper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [ "https://helix.cachix.org" ];
    extra-trusted-public-keys = [ "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs=" ];
  };

  outputs = { nixpkgs, home-manager, helix, git-branchless, tree-grepper, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations.ocharles = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
          {
            programs.helix.package = helix.packages.x86_64-linux.default;

            home = {
              packages = [
                git-branchless.packages.x86_64-linux.git-branchless
                tree-grepper.packages.x86_64-linux.tree-grepper
              ];
            };
          }
        ];
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}

{
  description = "rahul's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    # Unstable overlay — use pkgs.unstable.* anywhere
    overlay = ({ pkgs, ... }: {
      nixpkgs.overlays = [
        (final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            system = prev.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
        })
      ];
    });

    # Helper — builds a NixOS system for a given host
    mkHost = { hostName, hmUser }: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };  # makes inputs available in all modules

      modules = [
        overlay
        ./hosts/${hostName}
        ./configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-back";  # backup instead of fail
          home-manager.extraSpecialArgs = { inherit inputs hostName; };
          home-manager.users.${hmUser} = import ./home-manager/home.nix;
        }
      ];
    };

  in {
    nixosConfigurations = {
      nixos    = mkHost { hostName = "laptop";     hmUser = "rahul"; };
      nixosBtw = mkHost { hostName = "laptop-amd"; hmUser = "rahul"; };
    };
  };
}

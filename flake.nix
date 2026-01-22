{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
          url = "github:nix-community/home-manager/release-25.11";
          inputs.nixpkgs.follows = "nixpkgs";
        };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, catppuccin, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        # Host platform (modern replacement for `system = ...`)
        {
          nixpkgs.hostPlatform = "x86_64-linux";
        }

        # Overlay for unstable packages
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                system = prev.stdenv.hostPlatform.system;
                config.allowUnfree = true;
              };
            })
          ];
        })

        # Your main system configuration
        ./configuration.nix

        home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;

                  # Import catppuccin module for home-manager
                  home-manager.sharedModules = [ catppuccin.homeModules.catppuccin ];

                  # User configuration
                  home-manager.users.rahul = import ./home-manager/home.nix;

                  # Optionally, use extraSpecialArgs to pass inputs to home-manager
                  home-manager.extraSpecialArgs = { inherit nixpkgs-unstable; };
                }
      ];
    };
  };
}

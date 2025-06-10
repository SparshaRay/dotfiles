{
  description = "Idk anything what is going on here, but it works";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-pinned.url = "github:nixos/nixpkgs/a39ed32a651fdee6842ec930761e31d1f242cb94";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # scientific-fhs
    scientific-fhs.url = "github:Vortriz/scientific-fhs";

    inputactions = {
      url = "github:taj-ny/InputActions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-pinned,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'

    environment.systemPackages = [
      inputs.inputactions.packages.${nixpkgs.system}.inputactions-kwin
    ];

    nixosConfigurations = {
      # replace with your hostname
      SparshaRay = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs outputs;

          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };

          pkgs-pinned = import nixpkgs-pinned {
            inherit system;
            config.allowUnfree = true;
          };
          
        };
        # > Our main nixos configuration file <
        modules = [./nixos/configuration.nix];
      };
    };
  };
}

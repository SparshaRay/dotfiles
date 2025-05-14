{
  description = "Idk anything what is going on here, but it works";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-pinned.url = "github:nixos/nixpkgs/a39ed32a651fdee6842ec930761e31d1f242cb94";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # scientific-fhs
    scientific-fhs.url = "github:Vortriz/scientific-fhs";
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

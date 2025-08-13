{ inputs, outputs, ... }: {
  imports = [
    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };

    useGlobalPkgs = true;
    useUserPackages = true;

    users = {
      # Import your home-manager configuration
      sparsharay = import ../home-manager/home.nix;
    };

    backupFileExtension = ".bak";

  };
}
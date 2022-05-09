{
  description = "Philip's personal machine";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home.url = "github:nix-community/home-manager";
    home.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
  };
 
  outputs = { self, nixpkgs, home, nix-colors, ... }: {
    nixosConfigurations.Niflheimr = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/niflheimr/default.nix
        ./modules/shell/alias.nix
        home.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.philip = import ./users/philip.nix;
            home-manager.extraSpecialArgs = { inherit nix-colors; };
          }
      ];
      specialArgs = { inherit nix-colors; };
    };
  };
}

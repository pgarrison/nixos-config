
{
  description = "Philip's personal machine";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
  };
 
  outputs = { self, nixpkgs, home-manager, nix-colors, ... }: {
    nixosConfigurations.Niflheimr = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/niflheimr/default.nix
        ./modules/shell/alias.nix
        home-manager.nixosModules.home-manager
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


{
  description = "Philip's personal machine";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
 
  outputs = { self, nixpkgs, home-manager, ... }: {
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
          }
       ];
    };
  };
}

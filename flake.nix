
{
  description = "Philip's personal machine";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };
 
  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.Niflheimr = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/niflheimr/default.nix ];
    };
  };
}

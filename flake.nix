
{
  description = "Philip's personal machine";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home.url = "github:nix-community/home-manager";
  };
 
  outputs = { self, nixpkgs, home, ... }: {
    nixosConfigurations.Niflheimr = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/niflheimr/default.nix
        ./modules/shell/alias.nix
       ];
    };
  };
}


{
  outputs = { self, nixpkgs }: {
    nixosConfigurations.Niflheimr = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}

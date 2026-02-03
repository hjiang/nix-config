{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, zen-browser, home-manager }:
  let
    # Helper to create a NixOS system configuration
    mkHost = hostName: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./modules/base.nix
        ./hosts/${hostName}/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit hostName; };
          home-manager.users.hjiang = ./home.nix;
        }
      ];
      specialArgs = { inherit zen-browser; };
    };
  in
  {
    nixosConfigurations.hestia = mkHost "hestia";
  };
}

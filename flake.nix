{
  description = "Home Manager config for M2 MacBook Air";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."leon" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs; };
        modules = [ ./home.nix ];
      };
    };
}

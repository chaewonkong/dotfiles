{
  description = "Home Manager config for macOS and Ubuntu";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code.url = "github:sadjow/claude-code-nix";

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      mkHome = system: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home.nix ];
      };
    in {
      homeConfigurations = {
        mac = mkHome "aarch64-darwin";
        ubuntu = mkHome "x86_64-linux";
      };
    };
}

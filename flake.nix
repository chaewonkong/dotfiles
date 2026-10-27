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

    xremap-flake.url = "github:xremap/nix-flake";

    # Not a flake — built from source in modules/packages.nix
    port-killer = {
      url = "github:chaewonkong/port_killer";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      mkHome = system: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          # Host NVIDIA userspace for nix GPU apps (targets.genericLinux.gpu.nvidia in home.nix)
          config.nvidia.acceptLicense = true;
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

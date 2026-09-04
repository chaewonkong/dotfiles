{ inputs, pkgs, ... }:

{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./modules/packages.nix
    ./modules/shell.nix
    ./modules/git.nix
    ./modules/apps.nix
    ./modules/brew.nix
    ./modules/containers.nix
  ];

  home.username = "leon";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/leon" else "/home/leon";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };
}

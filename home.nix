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
    ./modules/nvim.nix
    ./modules/keyboard.nix
  ];

  home.username = "leon";
  home.homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/leon" else "/home/leon";
  home.stateVersion = "24.11";

  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.home-manager.enable = true;

  # Non-NixOS Linux (Ubuntu): put ~/.nix-profile/share on XDG_DATA_DIRS (incl. environment.d for the
  # GNOME session) so nix-installed GUI apps show up in the app grid and as default-app candidates
  targets.genericLinux.enable = pkgs.stdenv.hostPlatform.isLinux;

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "mauve";
  };
}

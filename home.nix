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
    ./modules/openlogi.nix
  ];

  home.username = "leon";
  home.homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/leon" else "/home/leon";
  home.stateVersion = "24.11";

  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.home-manager.enable = true;

  # Non-NixOS Linux (Ubuntu): put ~/.nix-profile/share on XDG_DATA_DIRS (incl. environment.d for the
  # GNOME session) so nix-installed GUI apps show up in the app grid and as default-app candidates
  targets.genericLinux.enable = pkgs.stdenv.hostPlatform.isLinux;

  # Give nix GPU apps (e.g. openlogi-gui) the host's NVIDIA userspace via /run/opengl-driver; without it
  # they fall back to llvmpipe, which renders GPUI windows as an empty transparent frame on X11.
  # version must match the host driver exactly (`nvidia-smi`) — update both after an apt driver upgrade,
  # then re-run `sudo ~/.nix-profile/bin/non-nixos-gpu-setup` (see CLAUDE.md)
  targets.genericLinux.gpu.nvidia = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    version = "595.99.02";
    sha256 = "sha256-6HR3lYv3YwcFSTJL1a1slI66btIQ5EAFs+/4SUD24ew=";
  };

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "mauve";
  };
}

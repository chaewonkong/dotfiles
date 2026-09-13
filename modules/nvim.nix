{ config, ... }:
let
  # The repo is cloned to ~/.config/home-manager on both machines (same assumption as README / the hms alias).
  dotfiles = "${config.home.homeDirectory}/.config/home-manager";
in
{
  # LazyVim-based config. Linked directly to the repo directory instead of the nix store → writable.
  # When lazy.nvim updates lazy-lock.json, the change shows up in git (commit after :Lazy update).
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config/nvim";
}

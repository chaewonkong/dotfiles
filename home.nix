{  inputs, ... }:

{
  imports = [ 
    inputs.catppuccin.homeModules.catppuccin
    ./modules/packages.nix
    ./modules/shell.nix
    ./modules/git.nix
    ./modules/hyprland.nix
    ./modules/waybar.nix
    ./modules/dunst.nix
  ];

  home.username = "leon";
  home.homeDirectory = "/home/leon";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
  };

  programs.rofi = {
    enable = true;
    font = "JetBrainsMono Nerd Font 12";
    # theme은 catppuccin 모듈이 자동 주입 (catppuccin-default + catppuccin-mocha)
  };
}


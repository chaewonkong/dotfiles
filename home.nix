{ config, pkgs, ... }:

{
  home.username = "leon";
  home.homeDirectory = "/home/leon";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    kitty
    btop
    ripgrep
    fd
    eza
    bat
    waybar
    wofi
    dunst
    swww
    grim
    slurp
    wl-clipboard
    brightnessctl
    pamixer
  ];

  programs.git = {
    enable = true;
    userName = "leon";
    userEmail = "your@email.com";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };
}

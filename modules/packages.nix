{pkgs, inputs, ...}:
let 
  system = pkgs.stdenv.hostPlatform.system;
in {
  home.packages = with pkgs; [
    btop
    ripgrep
    fd
    eza
    bat
    swww
    grim
    slurp
    wl-clipboard
    brightnessctl
    pamixer
    neovim
    tree-sitter
    lazygit
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts qt5.qtwayland
    qt6.qtwayland
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    hyprpolkitagent
    hypridle
    inputs.claude-code.packages.${system}.claude-code
    wev
    obsidian
    go_1_26
    rustup
    nodejs_24
    typescript
    ffmpegthumbnailer
    unar
    poppler
    fontpreview
    mise
    podman
    podman-compose
  ];
}

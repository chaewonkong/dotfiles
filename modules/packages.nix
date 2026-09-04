{pkgs, inputs, lib, ...}:
let
  system = pkgs.stdenv.hostPlatform.system;
in {
  home.packages = with pkgs; [
    btop
    ripgrep
    fd
    eza
    bat
    neovim
    tree-sitter
    lazygit
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts
    inputs.claude-code.packages.${system}.claude-code
    rustup
    typescript
    ffmpegthumbnailer
    unar
    poppler
    mise
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    obsidian
    fontpreview # xdotool/sxiv 의존성이 darwin 미지원
  ];
}

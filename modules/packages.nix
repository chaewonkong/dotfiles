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
    tmux # protects remote runs — session survives disconnects
    uv # Python project/venv management (LLM from scratch — installs torch without a system CUDA toolkit)

    # Moved from brew.nix — CLI tools are managed via nixpkgs (brew is casks-only; drops the linuxbrew dependency on Ubuntu)
    wget
    gh
    tree
    hugo
    inetutils # includes telnet
    just
    kubernetes-helm
    postgresql_18
    clang-tools # includes clang-format
    sops
    gnupg
    kustomize
    age
    sqlc
    python3Packages.huggingface-hub # hf CLI (formerly huggingface-cli)
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    gcc # for compiling nvim treesitter parsers (macOS uses clang from Xcode CLT)
    obsidian
    fontpreview # xdotool/sxiv dependencies don't support darwin
    vscode
    google-chrome # macOS uses brew.nix cask
  ];
}

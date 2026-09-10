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
    tmux # 원격 런 보호 — 접속 끊겨도 세션 유지
    uv # Python 프로젝트/venv 관리 (LLM from scratch — 시스템 CUDA toolkit 없이 torch 설치)

    # brew.nix에서 이관 — CLI 도구는 nixpkgs로 관리 (brew는 cask 전용, 우분투 linuxbrew 의존성 제거)
    wget
    gh
    tree
    hugo
    inetutils # telnet 포함
    just
    kubernetes-helm
    postgresql_18
    clang-tools # clang-format 포함
    sops
    gnupg
    kustomize
    age
    sqlc
    python3Packages.huggingface-hub # hf CLI (구 huggingface-cli)
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    gcc # nvim treesitter 파서 컴파일용 (macOS는 Xcode CLT의 clang 사용)
    obsidian
    fontpreview # xdotool/sxiv 의존성이 darwin 미지원
    vscode
  ];
}

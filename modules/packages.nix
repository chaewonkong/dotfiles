{pkgs, inputs, lib, ...}:
let
  system = pkgs.stdenv.hostPlatform.system;

  # Not in nixpkgs; built from the flake input (provides the `portkill` binary)
  port-killer = pkgs.rustPlatform.buildRustPackage {
    pname = "port_killer";
    version = "0.1.0";
    src = inputs.port-killer;
    cargoLock.lockFile = "${inputs.port-killer}/Cargo.lock";
  };

  # nix GTK3 doesn't look in /usr/lib for IM modules, so nix-installed GUI apps fall back to the
  # built-in simple IM and never talk to Ubuntu's IBus daemon (no Korean input at all). Give them
  # a cache listing only nixpkgs' im-ibus.so, built against the same gtk3 they use
  gtk3IbusCache = pkgs.runCommand "gtk3-ibus-immodules" { } ''
    mkdir -p $out
    ${pkgs.gtk3.dev}/bin/gtk-query-immodules-3.0 \
      ${pkgs.ibus}/lib/gtk-3.0/3.0.0/immodules/im-ibus.so > $out/immodules.cache
  '';

  # Wraps every binary to use that cache; .desktop files with absolute store paths
  # (e.g. google-chrome) are rewritten to point at the wrappers
  withIbus = pkg: pkgs.symlinkJoin {
    name = "${pkg.pname or pkg.name}-ibus";
    paths = [ pkg ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      for b in $out/bin/*; do
        wrapProgram "$b" \
          --set GTK_IM_MODULE_FILE ${gtk3IbusCache}/immodules.cache \
          --set-default GTK_IM_MODULE ibus
      done
      for d in $out/share/applications/*.desktop; do
        if grep -q ${pkg} "$d"; then
          sed "s|${pkg}|$out|g" "$(readlink -f "$d")" > "$d.tmp"
          rm "$d" && mv "$d.tmp" "$d"
        fi
      done
    '';
  };
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
    port-killer # `portkill` — interactive port/process killer
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    gcc # for compiling nvim treesitter parsers (macOS uses clang from Xcode CLT)
    fontpreview # xdotool/sxiv dependencies don't support darwin
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (map withIbus [
    obsidian
    vscode
    google-chrome # macOS uses brew.nix cask
  ]);
}

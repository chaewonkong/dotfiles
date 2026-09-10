{ config, lib, pkgs, ... }:
let
  formulae = [ 
    "wget" 
    "gh" 
    "tree" 
    "hugo"
    "telnet" 
    "just" 
    "helm" 
    "postgresql@18"
    "clang-format" 
    "sops" 
    "gnupg" 
    "kustomize" 
    "age" 
    "sqlc"
    "hf"
  ]; # 필요해지면 추가 (예: "wget", "gh")
  casks = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
    "obsidian"
    "google-chrome"
    "visual-studio-code"
    "ghostty"
    "slack"
    "android-studio"
    "flutter"
    "tailscale-app"
  ];
  brewfile = pkgs.writeText "Brewfile" (lib.concatStringsSep "\n" (
    (map (f: ''brew "${f}"'') formulae) ++
    (map (c: ''cask "${c}"'') casks)
  ));
in {
  home.activation.brewBundle = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # activation 스크립트는 PATH를 nix store 경로로만 덮어써서 brew가 안 잡힌다 — 직접 탐색
    BREW_BIN=""
    for brewPrefix in /opt/homebrew /home/linuxbrew/.linuxbrew "$HOME/.linuxbrew"; do
      if [ -x "$brewPrefix/bin/brew" ]; then
        BREW_BIN="$brewPrefix/bin/brew"
        break
      fi
    done

    if [ -n "$BREW_BIN" ]; then
      $DRY_RUN_CMD "$BREW_BIN" bundle --file=${brewfile}
    else
      echo "brew not found — skipping Homebrew bundle (install from https://brew.sh)" >&2
    fi
  '';
}

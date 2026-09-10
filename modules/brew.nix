{ config, lib, pkgs, ... }:
let
  # GUI 앱(cask)만 brew로 관리 — CLI 도구는 packages.nix(nixpkgs)로 이관함.
  # 이유: macOS 앱은 코드사이닝/공증, 자체 업데이터, Launch Services 등록 등
  # nix store의 불변성과 충돌하는 지점이 많아 OS 네이티브 설치 방식(brew cask)에 위임하는 게 안정적.
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
    map (c: ''cask "${c}"'') casks
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

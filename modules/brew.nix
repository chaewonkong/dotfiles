{ config, lib, pkgs, ... }:
let
  # Only GUI apps (casks) are managed by brew — CLI tools moved to packages.nix (nixpkgs).
  # Why: macOS apps rely on code signing/notarization, self-updaters, Launch Services registration, etc.,
  # which clash with the immutable nix store — delegating to the OS-native install path (brew cask) is more reliable.
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
    # The activation script's PATH only contains nix store paths, so brew isn't found — look for it manually
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

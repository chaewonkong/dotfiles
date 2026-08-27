{ config, lib, pkgs, ... }:
let
  formulae = [ ]; # 필요해지면 추가 (예: "wget", "gh")
  casks = lib.optionals pkgs.stdenv.isDarwin [
    "obsidian"
  ];
  brewfile = pkgs.writeText "Brewfile" (lib.concatStringsSep "\n" (
    (map (f: ''brew "${f}"'') formulae) ++
    (map (c: ''cask "${c}"'') casks)
  ));
in {
  home.activation.brewBundle = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if command -v brew >/dev/null 2>&1; then
      $DRY_RUN_CMD brew bundle --file=${brewfile} --no-lock
    else
      echo "brew not found — skipping Homebrew bundle (install from https://brew.sh)" >&2
    fi
  '';
}

{ pkgs, lib, ... }:
let
  openlogi = pkgs.openlogi;
  # Packaged unit: ExecStart already points at this store path, WantedBy=graphical-session.target
  unit = "${openlogi}/share/systemd/user/openlogi-agent.service";
in
# Linux-only — macOS gets OpenLogi as a cask in brew.nix
# Device access needs the package's udev rules in /etc — see "Manual steps for initial Ubuntu setup" in CLAUDE.md
lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  # CLI (openlogi), agent, GUI (openlogi-gui), .desktop entry and icon
  home.packages = [ openlogi ];

  # The agent owns all device I/O; the GUI only talks to it. Not `systemd.user.services`: on every start
  # the agent reconciles ~/.config/systemd/user/openlogi-agent.service against its "launch at login"
  # setting (off by default) and disables + deletes it — home-manager's link included. It never touches
  # $XDG_DATA_HOME/systemd/user, so the unit lives there and only the wants link goes in ~/.config.
  # Keep "launch at login" off in the app, or it writes its own unit alongside this one.
  xdg.dataFile."systemd/user/openlogi-agent.service".source = unit;
  xdg.configFile."systemd/user/graphical-session.target.wants/openlogi-agent.service".source = unit;
}

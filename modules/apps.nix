{ lib, pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
  };

  # Linux only: default browser = google-chrome (from packages.nix). Needed e.g. so Claude Desktop's
  # login flow opens in Chrome (passkey/QR) instead of Ubuntu's Firefox snap.
  # GNOME/Firefox create their own mimeapps.list files, so force-overwrite both locations.
  xdg.mimeApps = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "text/html" = "google-chrome.desktop";
    };
  };
  xdg.configFile = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    "mimeapps.list".force = true;
  };
  xdg.dataFile = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    "applications/mimeapps.list".force = true;
  };
}

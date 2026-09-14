{ lib, pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
  };

  # Linux only: default browser = google-chrome (from packages.nix). Needed e.g. so Claude Desktop's
  # login flow opens in Chrome (passkey/QR) instead of Ubuntu's Firefox snap.
  # If ~/.config/mimeapps.list already exists (Firefox creates one), remove it before `hms`.
  xdg.mimeApps = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "text/html" = "google-chrome.desktop";
    };
  };
}

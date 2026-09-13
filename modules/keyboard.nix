{ inputs, pkgs, lib, ... }:
let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;

  # xremap identifies apps by the X11 WM_CLASS class name (the second value from `xprop WM_CLASS`)
  terminals = [ "Gnome-terminal" ];

  # In GUI apps, Cmd(Super)+key → Ctrl+key. Extra Shift/Alt carry through (Cmd+Shift+Z → Ctrl+Shift+Z)
  # grave (`) is excluded — GNOME already uses it to switch windows of the same app (same as Cmd+` on the Mac)
  cmdKeys = lib.stringToCharacters "abcdefghijklmnopqrstuvwxyz0123456789"
    ++ [ "minus" "equal" "leftbrace" "rightbrace" "backslash" "semicolon" "apostrophe" "comma" "dot" "slash" ];
  cmdAsCtrl = lib.listToAttrs (map (k: lib.nameValuePair "Super-${k}" "C-${k}") cmdKeys);
in
{
  imports = [ inputs.xremap-flake.homeManagerModules.default ];

  # Make Ubuntu shortcuts behave like macOS — assumes a Mac-layout keyboard (key left of Space = Cmd = Super)
  # Requires /dev/uinput access (input group + udev rule) — see "Manual steps for initial Ubuntu setup" in CLAUDE.md
  services.xremap = {
    enable = isLinux;
    withX11 = true;
    config = lib.mkIf isLinux {
      modmap = [{
        name = "CapsLock toggles Korean/English";
        remap.CapsLock = "Hangeul";
      }];

      keymap = [
        {
          name = "Ctrl+Cmd+Q locks the screen";
          remap."C-Super-q" = "Super-l";
        }
        {
          name = "Cmd shortcuts in terminal";
          application.only = terminals;
          remap = {
            "Super-c" = "C-Shift-c";
            "Super-v" = "C-Shift-v";
            "Super-t" = "C-Shift-t";
            "Super-w" = "C-Shift-w";
            "Super-n" = "C-Shift-n";
            "Super-f" = "C-Shift-f";
            "Super-q" = "C-Shift-q";
            "Super-equal" = "C-Shift-equal";
            "Super-minus" = "C-minus";
            "Super-0" = "C-0";
            "Super-Left" = "C-a";
            "Super-Right" = "C-e";
            "Super-Backspace" = "C-u";
            "Alt-Left" = "Alt-b";
            "Alt-Right" = "Alt-f";
            # gnome-terminal can't tell Shift+Enter from Enter, so Claude Code newlines don't work without this
            "Shift-Enter" = "Alt-Enter";
          } // lib.listToAttrs (map (n: lib.nameValuePair "Super-${n}" "Alt-${n}") (lib.stringToCharacters "123456789"));
        }
        {
          name = "Cmd shortcuts in GUI apps";
          application.not = terminals;
          remap = cmdAsCtrl // {
            "Super-Left" = "Home";
            "Super-Right" = "End";
            "Super-Up" = "C-Home";
            "Super-Down" = "C-End";
            "Super-Backspace" = [ "Shift-Home" "Backspace" ];
            "Alt-Left" = "C-Left";
            "Alt-Right" = "C-Right";
            "Alt-Backspace" = "C-Backspace";
          };
        }
      ];
    };
  };

  dconf.settings = lib.mkIf isLinux {
    # Remove Shift+Space from ibus-hangul's switch keys — only CapsLock (→ Hangul key) toggles
    "org/freedesktop/ibus/engine/hangul".switch-keys = "Hangul";
    # ibus-hangul is the only input source — it has its own Latin mode, and switch-keys only work
    # while it is the active source (with a separate xkb 'us' source selected, CapsLock does nothing)
    "org/gnome/desktop/input-sources" = {
      sources = [ (lib.hm.gvariant.mkTuple [ "ibus" "hangul" ]) ];
      current = lib.hm.gvariant.mkUint32 0;
    };
    # Don't open the Activities overview on a lone Super tap (like Cmd on macOS). Remaps without a
    # modifier in the output (Super-Left → Home) make xremap release Super before sending the key,
    # which GNOME reads as a lone Super tap
    "org/gnome/mutter".overlay-key = "";
  };
}

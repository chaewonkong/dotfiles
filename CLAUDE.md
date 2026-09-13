# Home Manager Configuration

Manages dotfiles for two machines (macOS and Ubuntu Desktop) with a single Nix home-manager config. The user is `leon` on both machines.

## Structure

- `flake.nix` — Flake inputs (nixpkgs unstable, home-manager, claude-code-nix, catppuccin, xremap-flake) and the `mkHome` helper that defines `homeConfigurations.{mac,ubuntu}` (`aarch64-darwin` / `x86_64-linux`, `allowUnfree = true`)
- `flake.lock` — dependency lock file
- `home.nix` — imports all modules and enables catppuccin globally (mocha flavor, mauve accent, `autoEnable`). Only `home.homeDirectory` branches on `pkgs.stdenv.hostPlatform.isDarwin`; any other platform branching uses `pkgs.stdenv.hostPlatform.isLinux`, and only where needed
- `config/nvim/` — LazyVim-based Neovim config, linked by `modules/nvim.nix`
- `modules/`
  - `packages.nix` — CLI/dev tools and fonts from nixpkgs (cross-platform), including the CLI tools that used to be Homebrew formulae. Linux-only extras via `lib.optionals isLinux`: `gcc` (treesitter parser builds; macOS uses Xcode CLT clang), `fontpreview` (deps unsupported on darwin), and the GUI apps `obsidian`, `vscode`, `google-chrome` (macOS gets these as casks in `brew.nix`)
  - `shell.nix` — zsh (oh-my-zsh with `git` plugin, `af-magic` theme), zoxide, direnv (with nix-direnv; `load_dotenv = true` so `.env` files load too, after `direnv allow`), shell aliases (`hms`, git shortcuts), podman `policy.json`. Appends brew to the *end* of `PATH` so nixpkgs binaries win. On Linux, also places the Ghostty terminfo in `~/.terminfo`
  - `brew.nix` — **casks only, macOS only.** Generates a Brewfile from the `casks` list and runs `brew bundle` in `home.activation`. GUI apps go through brew casks because code signing, self-updaters and Launch Services registration conflict with the immutable nix store. On Linux the cask list is empty
  - `containers.nix` — colima, docker-client, docker-compose (cross-platform). Links docker-compose as a Docker CLI plugin and writes `~/.colima/default/colima.yaml` (4 CPU, 8 GB RAM, 60 GB disk, docker runtime; on macOS also `vz`, `virtiofs`, Rosetta)
  - `nvim.nix` — links `~/.config/nvim` to `~/.config/home-manager/config/nvim` with `mkOutOfStoreSymlink` (not the nix store), so the config stays writable. `lazy-lock.json` changes from `:Lazy update` show up in git — commit them
  - `git.nix` — git user identity and `credential.helper = store` (cross-platform)
  - `apps.nix` — yazi file manager with zsh integration; shell wrapper is `y` (cross-platform)
  - `keyboard.nix` — Linux-only. Uses xremap (`xremap-flake`, X11 build) to make Ubuntu shortcuts behave like macOS (assumes a Mac-layout keyboard: Cmd = Super). In GUI apps Cmd+key → Ctrl+key; in the terminal (`Gnome-terminal`) Cmd+C/V → Ctrl+Shift+C/V and Shift+Enter → Alt+Enter (Claude Code newline); CapsLock → Hangul key. Also sets, via dconf, ibus-hangul's switch keys to `Hangul` only and GNOME's input sources to ibus-hangul alone (its switch keys only work while it's the active source, so a separate xkb `us` source breaks CapsLock toggling), and removes Ubuntu Tiling Assistant's Super+arrow bindings so Cmd+arrow cursor movement isn't grabbed by window tiling

## Stack

- **Shell**: zsh (completion, autosuggestion, syntax-highlighting enabled) + oh-my-zsh
- **Editor**: Neovim (LazyVim)
- **Theme**: catppuccin mocha
- **Font**: JetBrains Mono Nerd Font, Noto CJK
- **Containers**: colima + docker CLI
- **Package management**: nixpkgs for everything by default. Homebrew is used only on macOS, only for GUI app casks. OS package managers like apt/dnf are not used for user tools

## Applying

```bash
# macOS only: install brew first — https://brew.sh (Ubuntu doesn't need brew)
# Clone the repo to ~/.config/home-manager on both machines (nvim.nix's out-of-store symlink path assumes this)
home-manager switch --flake ~/.config/home-manager#mac     # macOS
home-manager switch --flake ~/.config/home-manager#ubuntu  # Ubuntu
# Afterwards, use the alias `hms` (auto-detects the platform)
```

### Manual steps for initial Ubuntu setup

These are system-level, outside home-manager's scope, so they must be done by hand:

- **Change the login shell** — Ubuntu's default shell is bash. If bash reads the zsh config, you get a `(Ie)__zoxide_hook` syntax error
  ```bash
  command -v zsh | sudo tee -a /etc/shells
  chsh -s "$(command -v zsh)"   # takes effect after logging out of and back into the GNOME session
  ```
- **System daemons/drivers use apt** — `openssh-server`, NVIDIA drivers (`ubuntu-drivers install`), etc. The "no apt" rule only applies to user tools managed by home-manager
- **uinput permissions for xremap** — the xremap service in `modules/keyboard.nix` needs access to `/dev/uinput`. Reboot afterwards (logging out alone may not give the systemd user manager the new group)
  ```bash
  sudo usermod -aG input leon
  echo 'KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/99-uinput.rules
  echo uinput | sudo tee /etc/modules-load.d/uinput.conf
  ```
- **Ghostty terminfo** is placed in `~/.terminfo` automatically by `modules/shell.nix` (Linux only). If you previously ran `tic` manually, `rm ~/.terminfo/x/xterm-ghostty` before switching

## Notes when making changes

- Do not change `home.stateVersion` (currently `"24.11"`)
- When adding a package, check compatibility with both systems (aarch64-darwin, x86_64-linux)
- CLI tools go in `modules/packages.nix` (nixpkgs), not Homebrew
- GUI apps go in `casks` in `modules/brew.nix` (macOS). If nixpkgs has a working version for Linux, also add it to `packages.nix` under `lib.optionals pkgs.stdenv.hostPlatform.isLinux [...]`
- If `brew` isn't installed locally, activation silently skips the cask install (it doesn't fail) — see `modules/brew.nix`
- New module files must be `git add`ed (at least `git add -N`) before `hms`, since flakes only see tracked files
- The Korean input method itself is not managed by this repo — Ubuntu uses GNOME's default IBus (`ibus-hangul`), macOS uses the system input method, each configured separately. The exception is Ubuntu's Korean/English toggling (CapsLock, ibus-hangul `switch-keys`, and the GNOME input source list), which is managed in `modules/keyboard.nix`
- nixpkgs uses the `unstable` channel

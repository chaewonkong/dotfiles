# dotfiles

Personal dotfiles managed with Nix + home-manager, for two machines:

- **mac** — macOS (aarch64-darwin)
- **ubuntu** — Ubuntu Desktop (x86_64-linux)

## Stack

- **Package manager**: Nix + home-manager for CLI/dev tools, Homebrew (declared in Nix, see `modules/brew.nix`) for GUI apps and anything nixpkgs doesn't cover well
- **Shell**: zsh

## Prerequisites

- [Homebrew](https://brew.sh) must already be installed (macOS and Ubuntu both) — `home-manager switch` runs `brew bundle` on activation but does not install `brew` itself.

## Usage

```bash
git clone https://github.com/chaewonkong/dotfiles.git ~/.config/home-manager
home-manager switch --flake ~/.config/home-manager#<mac|ubuntu>
```

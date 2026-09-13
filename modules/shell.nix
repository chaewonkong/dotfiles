{ pkgs, lib, ... }:
{
  home.file.".config/containers/policy.json".text = builtins.toJSON {
    default = [{ type = "insecureAcceptAnything"; }];
  };

  # SSHing in from Ghostty on the Mac sets TERM=xterm-ghostty. nix zsh (nix ncurses) doesn't look in /usr/share/terminfo,
  # so put it in ~/.terminfo — a path both system and nix ncurses check. Without it, ZLE rendering breaks.
  home.file.".terminfo/x/xterm-ghostty" = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    source = "${pkgs.ghostty.terminfo}/share/terminfo/x/xterm-ghostty";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # direnv — auto-loads .env files as well as .envrc (load_dotenv).
  # .env files also need `direnv allow` the first time. nix-direnv caches `use flake`.
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config.global = {
      load_dotenv = true;
      hide_env_diff = true;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
      theme = "af-magic";
    };

    initContent = ''
      # Append brew to the end of PATH — `brew shellenv` prepends, which would shadow nixpkgs, so it's not used
      for brewPrefix in /opt/homebrew /home/linuxbrew/.linuxbrew "$HOME/.linuxbrew"; do
        [ -x "$brewPrefix/bin/brew" ] && export PATH="$PATH:$brewPrefix/bin:$brewPrefix/sbin"
      done

      eval "$(mise activate zsh)"
      '';

    shellAliases = {
      # home-manager switch — auto-detects the platform (mac / ubuntu)
      hms = "home-manager switch --flake ~/.config/home-manager#$([ \"$(uname)\" = Darwin ] && echo mac || echo ubuntu)";

      # git
      st = "git status";
      pull = "git pull --no-rebase";
      push = "git push";
      lgit = "lazygit";
    };
  };
}

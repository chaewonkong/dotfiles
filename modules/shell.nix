{ pkgs, lib, ... }:
{
  home.file.".config/containers/policy.json".text = builtins.toJSON {
    default = [{ type = "insecureAcceptAnything"; }];
  };

  # 맥 Ghostty에서 SSH 접속 시 TERM=xterm-ghostty. nix zsh(nix ncurses)는 /usr/share/terminfo를
  # 안 보므로 ~/.terminfo에 둔다 — 시스템/nix ncurses 모두 참조하는 경로. 없으면 ZLE 렌더링이 깨짐.
  home.file.".terminfo/x/xterm-ghostty" = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    source = "${pkgs.ghostty.terminfo}/share/terminfo/x/xterm-ghostty";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
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
      # brew를 PATH 뒤에 붙인다 — shellenv는 앞에 prepend해서 nixpkgs보다 우선하게 되므로 쓰지 않음
      for brewPrefix in /opt/homebrew /home/linuxbrew/.linuxbrew "$HOME/.linuxbrew"; do
        [ -x "$brewPrefix/bin/brew" ] && export PATH="$PATH:$brewPrefix/bin:$brewPrefix/sbin"
      done

      eval "$(mise activate zsh)"
      '';

    shellAliases = {
      # home-manager switch — 플랫폼 자동 감지 (mac / ubuntu)
      hms = "home-manager switch --flake ~/.config/home-manager#$([ \"$(uname)\" = Darwin ] && echo mac || echo ubuntu)";

      # git
      st = "git status";
      pull = "git pull --no-rebase";
      push = "git push";
      lgit = "lazygit";
    };
  };
}

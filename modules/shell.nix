{...}:
{
  home.file.".config/containers/policy.json".text = builtins.toJSON {
    default = [{ type = "insecureAcceptAnything"; }];
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

    initExtra = ''
      eval "$(mise activate zsh)"
      '';

    shellAliases = {
      # home-manager switch — 플랫폼 자동 감지 (mac / ubuntu)
      hms = "home-manager switch --flake ~/.config/home-manager#$([ \"$(uname)\" = Darwin ] && echo mac || echo ubuntu)";
    };
  };
}

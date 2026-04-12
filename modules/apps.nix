{...}:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
  };

  programs.rofi = {
    enable = true;
    font = "JetBrainsMono Nerd Font 12";
    # theme은 catppuccin 모듈이 자동 주입 (catppuccin-default + catppuccin-mocha)
  };
}

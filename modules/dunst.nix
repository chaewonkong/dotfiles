{...}:
{
  services.dunst = {
    enable = true;
    # 색상은 catppuccin 모듈이 drop-in으로 자동 주입 (~/.config/dunst/dunstrc.d/00-catppuccin.conf)
    settings = {
      global = {
        font = "JetBrainsMono Nerd Font 11";
        frame_width = 2;
        corner_radius = 8;
        padding = 12;
        horizontal_padding = 12;
        offset = "16x40";
        origin = "top-right";
        notification_limit = 5;
        idle_threshold = 120;
        format = "<b>%s</b>\\n%b";
        markup = "full";
        word_wrap = true;
        ignore_newline = false;
        show_indicators = false;
        mouse_left_click = "close_current";
        mouse_right_click = "close_all";
      };

      urgency_low = {
        timeout = 5;
      };

      urgency_normal = {
        timeout = 8;
      };

      urgency_critical = {
        timeout = 0; # 직접 닫을 때까지 유지
      };
    };
  };
}

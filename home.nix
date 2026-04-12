{  inputs, ... }:

{
  imports = [ 
    inputs.catppuccin.homeModules.catppuccin
    ./modules/packages.nix
    ./modules/shell.nix
    ./modules/git.nix
    ./modules/hyprland.nix
  ];

  home.username = "leon";
  home.homeDirectory = "/home/leon";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

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

  programs.waybar = {
    enable = true;
    systemd.enable = false; # Hyprland exec-once로 직접 실행

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 32;
      spacing = 4;

      modules-left = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "backlight" "battery" "tray" ];

      "hyprland/workspaces" = {
        format = "{name}";
        on-click = "activate";
      };

      "hyprland/window" = {
        format = "{title}";
        max-length = 60;
        separate-outputs = true;
      };

      clock = {
        format = "{:%a %Y-%m-%d  %H:%M}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      pulseaudio = {
        format = "{volume}% {icon}";
        format-muted = "muted";
        format-icons = {
          default = [ "" "" "" ];
        };
        on-click = "pamixer -t";
        scroll-step = 5;
      };

      network = {
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "{ipaddr} ";
        format-disconnected = "disconnected ⚠";
        tooltip-format = "{ifname}: {ipaddr}";
      };

      backlight = {
        format = "{percent}% {icon}";
        format-icons = [ "" "" "" ];
        on-scroll-up = "brightnessctl set 5%+";
        on-scroll-down = "brightnessctl set 5%-";
      };

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% ";
        format-icons = [ "" "" "" "" "" ];
      };

      tray = {
        icon-size = 16;
        spacing = 8;
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Noto Sans CJK KR";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background-color: alpha(@base, 0.85);
        color: @text;
        border-bottom: 2px solid @surface0;
      }

      #workspaces button {
        padding: 0 8px;
        color: @overlay1;
        background: transparent;
        border-bottom: 2px solid transparent;
      }

      #workspaces button.active {
        color: @accent;
        border-bottom: 2px solid @accent;
      }

      #workspaces button:hover {
        background: @surface0;
        color: @text;
      }

      #window {
        padding: 0 10px;
        color: @subtext1;
      }

      #clock,
      #pulseaudio,
      #network,
      #backlight,
      #battery,
      #tray {
        padding: 0 10px;
        color: @text;
      }

      #battery.warning {
        color: @peach;
      }

      #battery.critical {
        color: @red;
      }

      #pulseaudio.muted {
        color: @overlay0;
      }

      #network.disconnected {
        color: @red;
      }
    '';
  };
}


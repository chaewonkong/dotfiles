{ config, pkgs, inputs, ... }:

{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  home.username = "leon";
  home.homeDirectory = "/home/leon";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };


  systemd.user.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  home.packages = with pkgs; [
    btop
    ripgrep
    fd
    eza
    bat
    swww
    grim
    slurp
    wl-clipboard
    brightnessctl
    pamixer
    neovim
    tree-sitter
    lazygit
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts
    qt5.qtwayland
    qt6.qtwayland
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    hyprpolkitagent
    hypridle
    inputs.claude-code.packages.${system}.claude-code
    wev
    obsidian
    go_1_26
    rustup
    nodejs_24
    typescript
    ffmpegthumbnailer
    unar
    poppler
    fontpreview
  ];

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

  programs.git = {
    enable = true;
    settings = {
      user.name = "chaewonkong";
      user.email = "chaewonkong@gmail.com";
      credential.helper = "store";
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
  };

  xdg.configFile."hypr/hyprland.conf".text = ''
      monitor=,preferred,auto,1.25

      input {
        kb_layout = us
        kb_options = caps:ctrl_modifier # 한글 입력 ctrl+space로 매핑
        follow_mouse = 1
        touchpad {
          natural_scroll = true
          tap-to-click = true
        }
        sensitivity = 0
      }

      general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgba(cba6f7ee) rgba(89b4faee) 45deg
        col.inactive_border = rgba(45475aaa)
        layout = dwindle
      }

      decoration {
        rounding = 10
        blur {
          enabled = true
          size = 3
          passes = 1
        }
        shadow {
          enabled = true
          range = 4
          render_power = 3
        }
      }

      animations {
        enabled = true
        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
      }

      dwindle {
        pseudotile = true
        preserve_split = true
      }

      $mod = SUPER

      bind = $mod, Return, exec, /usr/bin/kitty
      bind = $mod, Q, killactive,
      bind = $mod, M, exit,
      bind = $mod, V, togglefloating,
      bind = $mod, D, exec, rofi -show drun -show-icons
      bind = $mod, F, fullscreen, 0

      bind = $mod, B, exec, firefox

      bind = $mod, H, movefocus, l
      bind = $mod, L, movefocus, r
      bind = $mod, K, movefocus, u
      bind = $mod, J, movefocus, d

      bind = $mod, 1, workspace, 1
      bind = $mod, 2, workspace, 2
      bind = $mod, 3, workspace, 3
      bind = $mod, 4, workspace, 4
      bind = $mod, 5, workspace, 5

      bind = $mod SHIFT, 1, movetoworkspace, 1
      bind = $mod SHIFT, 2, movetoworkspace, 2
      bind = $mod SHIFT, 3, movetoworkspace, 3
      bind = $mod SHIFT, 4, movetoworkspace, 4
      bind = $mod SHIFT, 5, movetoworkspace, 5

      bindm = $mod, mouse:272, movewindow
      bindm = $mod, mouse:273, resizewindow

      bind = , Print, exec, grim -g "$(slurp)" - | wl-copy

      binde = , XF86MonBrightnessUp, exec, brightnessctl set 5%+
      binde = , XF86MonBrightnessDown, exec, brightnessctl set 5%-

      binde = , XF86AudioRaiseVolume, exec, pamixer -i 5
      binde = , XF86AudioLowerVolume, exec, pamixer -d 5
      bind = , XF86AudioMute, exec, pamixer -t

      exec-once = waybar
      exec-once = fcitx5 -d
      exec-once = hyprpolkitagent
      exec-once = hypridle

      # wallpaper
      exec-once = swww-daemon
      exec-once = swww img ~/wallpapers/wallhaven-391ql6.png
    '';

xdg.configFile."hypr/hypridle.conf".text=''
    general {
      after_sleep_cmd = hyprctl dispatch dpms on
    }

    listener {
      timeout = 300 # 5 mins to dark
      on-timeout = brightnessctl -s set 10%
      on-resume = brightnessctl -r
    }

    listener {
      timeout = 900 # 15 mins to off the screen
      on-timeout = hyprctl dispatch dpms off
      on-resume = hyprctl dispatch dpms on
    }
'';
}


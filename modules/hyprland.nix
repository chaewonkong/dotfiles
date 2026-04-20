{...}:
{
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
      exec-once = awww-daemon
      exec-once = sleep 1 && awww img ~/wallpapers/wallhaven-9ozlpk.png
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

{...}:
{
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

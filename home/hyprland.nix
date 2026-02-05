{ config, pkgs, lib, ... }:

let
  # Program shortcuts
  terminal = "footclient";
  fileManager = "dolphin";
  browser = "zen";
  editor = "emacs";
  screenshot = ''grim -g "$(slurp)" - | satty -f -'';
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    # Conflict with UWSM - systemd integration handled by UWSM instead
    systemd.enable = false;

    settings = {
      # Monitor configuration - device-specific overrides can be done via extraConfig
      monitor = ",highres@highrr,auto,auto";

      # Environment variables
      env = [
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "QT_QPA_PLATFORM,wayland;xcb"
        "GDK_BACKEND,wayland,x11,*"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "MOZ_ENABLE_WAYLAND,1"
      ];

      # Autostart applications
      exec-once = [
        ''gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"''
        "fcitx5"
        "/usr/libexec/hyprpolkitagent"
        "hypridle"
        "hyprpaper"
        "waybar"
        "foot --server"
        "xhost si:localuser:root"
        "swaync"
        "nm-applet"
        "blueman-applet"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "udiskie --tray"
        "gammastep -l geoclue"
      ];

      # General settings
      general = {
        gaps_in = 3;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = true;
        extend_border_grab_area = 15;
        allow_tearing = false;
        layout = "dwindle";
      };

      # Decoration
      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.8;
        dim_inactive = true;
        dim_strength = 0.1;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      # Animations
      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      # Workspace rules for smart gaps
      workspace = [
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];

      # Dwindle layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Master layout
      master = {
        new_status = "master";
      };

      # Misc settings
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_hyprland_guiutils_check = true;
        focus_on_activate = true;
      };

      # Input settings
      input = {
        kb_layout = "us";
        natural_scroll = true;
        follow_mouse = 1;
        sensitivity = 0;
      };

      # XWayland settings
      xwayland = {
        force_zero_scaling = true;
      };

      # Cursor settings
      cursor = {
        no_hardware_cursors = 1;
        inactive_timeout = 5;
        hide_on_touch = true;
        hide_on_tablet = true;
        hide_on_key_press = true;
      };

      # Variables for bindings
      "$mainMod" = "SUPER";
      "$terminal" = terminal;
      "$fileManager" = fileManager;
      "$browser" = browser;
      "$editor" = editor;
      "$screenshot" = screenshot;

      # Key bindings
      bind = [
        # Program launchers
        "$mainMod, T, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod SHIFT, Q, exit,"
        "$mainMod CTRL, L, exec, loginctl lock-session"
        "$mainMod, F, exec, $fileManager"
        "$mainMod, B, exec, $browser"
        "$mainMod, E, exec, $editor"
        "$mainMod CTRL, V, togglefloating,"
        "$mainMod, RETURN, exec, walker"
        "$mainMod, P, pseudo,"
        "$mainMod, BACKSLASH, togglesplit,"
        "$mainMod SHIFT, S, exec, $screenshot"

        # Window management
        "$mainMod, M, fullscreen, 0"
        "$mainMod SHIFT, M, fullscreen, 1"
        "$mainMod, C, centerwindow"
        "$mainMod, X, pin"

        # Scratchpad
        "$mainMod, D, togglespecialworkspace, magic"
        "$mainMod SHIFT, D, movetoworkspace, special:magic"

        # Move focus (vim-style)
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"

        # Move windows
        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod SHIFT, J, movewindow, d"

        # Swap windows
        "$mainMod CTRL, H, swapwindow, l"
        "$mainMod CTRL, L, swapwindow, r"
        "$mainMod CTRL, K, swapwindow, u"
        "$mainMod CTRL, J, swapwindow, d"

        # Resize mode entry
        "$mainMod, R, submap, resize"

        # Workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move to workspaces
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Workspace navigation
        "$mainMod, TAB, workspace, e+1"
        "$mainMod SHIFT, TAB, workspace, e-1"
        "$mainMod, bracketright, workspace, m+1"
        "$mainMod, bracketleft, workspace, m-1"

        # Mouse workspace scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # System utilities
        "$mainMod, V, exec, cliphist list | walker --dmenu | cliphist decode | wl-copy"
        "$mainMod, N, exec, swaync-client -t -sw"
        "$mainMod CTRL SHIFT, ESCAPE, exit"
      ];

      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Repeatable bindings (for media/brightness)
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      # Locked bindings (work even when locked)
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };

    # Extra config for features that don't translate well to Nix
    # (submaps, window rules with new 0.53+ syntax)
    extraConfig = ''
      # Resize submap
      submap = resize
      binde = , H, resizeactive, -10 0
      binde = , L, resizeactive, 10 0
      binde = , K, resizeactive, 0 -10
      binde = , J, resizeactive, 0 10
      bind = , escape, submap, reset
      bind = , return, submap, reset
      submap = reset

      # ==========================================
      # Window Rules (Hyprland 0.53+ syntax)
      # ==========================================

      # Suppress maximize events for all windows
      windowrule = match:class .*, suppress_event maximize

      # Smart gaps - remove borders/rounding when only one tiled window
      windowrule {
        name = smart-gaps-tv1-tiled
        match:float = false
        match:workspace = w[tv1]
        border_size = 0
        rounding = 0
      }

      windowrule {
        name = smart-gaps-fullscreen-tiled
        match:float = false
        match:workspace = f[1]
        border_size = 0
        rounding = 0
      }

      # Workspace assignments
      windowrule = match:class firefox-esr, workspace 1
      windowrule = match:class zen, workspace 1
      windowrule = match:class emacs, workspace 2
      windowrule = match:class kitty, workspace 3
      windowrule = match:class foot, workspace 3
      windowrule = match:class footclient, workspace 3
      windowrule = match:class com.mitchellh.ghostty, workspace 3
      windowrule = match:class Slack, workspace 4
      windowrule = match:class discord, workspace 4
      windowrule = match:class Element, workspace 5
      windowrule = match:class wechat, workspace 5
      windowrule = match:class steam, workspace 6

      # Floating dialogs with size
      windowrule {
        name = float-pavucontrol
        match:class = ^(pavucontrol)$
        float = on
        size = 800 600
      }

      windowrule {
        name = float-blueman
        match:class = ^(blueman-manager)$
        float = on
        size = 800 600
      }

      windowrule {
        name = float-nm-editor
        match:class = ^(nm-connection-editor)$
        float = on
        size = 800 600
      }

      windowrule = match:class ^(nwg-look)$, float on

      # File dialogs
      windowrule = match:title ^(Open File)(.*), float on
      windowrule = match:title ^(Select a File)(.*), float on
      windowrule = match:title ^(Choose wallpaper)(.*), float on
      windowrule = match:title ^(Open Folder)(.*), float on
      windowrule = match:title ^(Save As)(.*), float on
      windowrule = match:title ^(Library)(.*), float on

      # Picture-in-Picture
      windowrule {
        name = pip-window
        match:title = ^(Picture-in-Picture)$
        float = on
        pin = on
        move = 75% 75%
        size = 25% 25%
      }

      # Fix XWayland drag issues
      windowrule {
        name = fix-xwayland-drags
        match:class = ^$
        match:title = ^$
        match:xwayland = true
        match:float = true
        match:fullscreen = false
        no_focus = on
      }
    '';
  };

  # Hypridle configuration
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  # Hyprlock configuration
  programs.hyprlock = {
    enable = true;
    settings = {
      "$font" = "Fira Sans";

      general = {
        hide_cursor = false;
      };

      animations = {
        enabled = true;
        bezier = [ "linear, 1, 1, 0, 0" ];
        animation = [
          "fadeIn, 1, 5, linear"
          "fadeOut, 1, 5, linear"
          "inputFieldDots, 1, 2, linear"
        ];
      };

      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "20%, 5%";
          outline_thickness = 3;
          inner_color = "rgba(0, 0, 0, 0.0)";
          outer_color = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          check_color = "rgba(00ff99ee) rgba(ff6633ee) 120deg";
          fail_color = "rgba(ff6633ee) rgba(ff0066ee) 40deg";
          font_color = "rgb(143, 143, 143)";
          fade_on_empty = false;
          rounding = 15;
          font_family = "$font";
          placeholder_text = "Input password...";
          fail_text = "$PAMFAIL";
          dots_spacing = 0.3;
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          # Time
          monitor = "";
          text = "$TIME";
          font_size = 90;
          font_family = "$font";
          position = "-30, 0";
          halign = "right";
          valign = "top";
        }
        {
          # Date
          monitor = "";
          text = ''cmd[update:60000] date +"%A, %d %B %Y"'';
          font_size = 25;
          font_family = "$font";
          position = "-30, -150";
          halign = "right";
          valign = "top";
        }
      ];
    };
  };

  # Hyprpaper configuration
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "~/.local/share/backgrounds/a_house_with_a_chair_and_a_bicycle.jpg" ];
      wallpaper = [ ", ~/.local/share/backgrounds/a_house_with_a_chair_and_a_bicycle.jpg" ];
    };
  };
}

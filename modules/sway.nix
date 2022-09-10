{ pkgs, lib, config, specialArgs, ... }:

with lib;

let
  cfg = config.modules.sway;

  inherit (config) colorscheme;
in
{
  options = {
    modules.sway = {
      enable = mkEnableOption "Enable sway";

      xwayland = mkOption {
        type = types.bool;
        default = true;
      };

      wallpaper = mkOption {
        type = types.nullOr types.path;
        default = null;
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fuzzel
      imv
      swayidle
      swaylock
      wl-clipboard
      grim
      slurp
      pamixer
      sway-contrib.grimshot
      wf-recorder
      wlr-randr
    ];

    services.swayidle = {
      enable = true;
      timeouts = [
        # 10 minutes
        {
          timeout = 600;
          command       = "swaymsg 'output * dpms off'";
          resumeCommand = "swaymsg 'output * dpms on'";
        }
        # 10 minutes 30 seconds
        { timeout = 630; command = "systemctl suspend-then-hibernate"; }
      ];
    };

    wayland.windowManager.sway = {
      enable = true;
      #package = pkgs.sway-unwrapped;
      wrapperFeatures = { base = true; gtk = true; };
      #xwayland = cfg.xwayland;
      config = rec {
        startup = [
          {
            command = "wlr-randr --output eDP-1 --scale 1.5";
            always = true;
          }
        ];

        /*
        input = {
          "type:keyboard" = {
            xkb_layout = "us";
            xkb_variant = "colemak";
            xkb_options = "caps:swapescape";

            repeat_delay = "300";
            repeat_rate = "50";
          };

          "1267:91:Elan_Touchpad" = {
            tap = "enabled";
            natural_scroll = "enabled";
          };
        };
        */

        seat."*" = {
          hide_cursor = "when-typing enabled";
        };

        output."*" = mkIf (!(isNull cfg.wallpaper)) {
          bg = "${cfg.wallpaper} fill";
        };

        fonts = {
          names = [ "JetBrains Mono" ];
          size = 12.0;
        };

        gaps = {
          inner = 4;
          outer = 4;
        };

        window = {
          titlebar = false;
          border = 2;
        };

        floating = {
          border = 2;
          criteria = [
            #{ app_id = "org.keepassxc.KeePassXC"; }
            {
              class = "firefox";
              title = "Picture-in-Picture";
            }
            { app_id = "mpv"; }
          ];
        };

        # Mod1 is alt, Mod4 is windows key
        modifier = "Mod4";
        keybindings = {
          # open terminal
          "${modifier}+Return" = "exec ${pkgs.foot}/bin/foot";
          "${modifier}+Shift+Return" = "splitv, exec ${pkgs.foot}/bin/foot";

          # open launcher
          "${modifier}+Space" = ''exec ${toString [
            "fuzzel -P 'run: '"
            "-f 'JetBrains Mono:size=10'" #"-i '${config.gtk.iconTheme.name}'"
            "-r 2 -B 3 -y 20 -p 10"
            "-b '${colorscheme.colors.base00}ff' -t '${colorscheme.colors.base06}ff'"
            "-C '${colorscheme.colors.base0D}ff' -m '${colorscheme.colors.base08}ff'"
            "-s '${colorscheme.colors.base02}ff' -S '${colorscheme.colors.base06}ff'"
          ]}'';

          "${modifier}+Shift+q" = "kill";

          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";
          "${modifier}+Shift+h" = "move left 20";
          "${modifier}+Shift+j" = "move down 20";
          "${modifier}+Shift+k" = "move up 20";
          "${modifier}+Shift+l" = "move right 20";

          "${modifier}+f" = "fullscreen toggle";
          #"${modifier}+Shift+space" = "floating toggle";
          #"${modifier}+space" = "focus mode_toggle";

          # modes
          "${modifier}+r" = "mode resize";
          #"${modifier}+F11" = "mode passthrough";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          "${modifier}+Tab" = "workspace next";
          "${modifier}+Shift+Tab" = "workspace prev";

          # scratchpad
          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";

          "XF86AudioMute" = "exec pamixer -t";
          "XF86AudioRaiseVolume" = "exec pamixer -i 5";
          "XF86AudioLowerVolume" = "exec pamixer -d 5";
          "Shift+XF86AudioMute" = "exec pamixer --default-source -t";
          "Shift+XF86AudioRaiseVolume" = "exec pamixer --default-source -i 5";
          "Shift+XF86AudioLowerVolume" = "exec pamixer --default-source -d 5";

          "Print" = "exec grimshot --notify save screen ${config.xdg.userDirs.pictures}/$(date +%m-%d-%Y_%H-%M-%S).jpg";
          "Shift+Print" = "exec grimshot --notify save window ${config.xdg.userDirs.pictures}/$(date +%m-%d-%Y_%H-%M-%S).jpg";
          "Control+Shift+Print" = "exec grimshot --notify save area ${config.xdg.userDirs.pictures}/$(date +%m-%d-%Y_%H-%M-%S).jpg";

          "XF86AudioPlay" = "exec mpc toggle";
          "XF86AudioPause" = "exec mpc toggle";
          "XF86AudioNext" = "exec mpc next";
          "XF86AudioPrev" = "exec mpc prev";
          "Shift+XF86AudioNext" = "exec mpc seek +10";
          "Shift+XF86AudioPrev" = "exec mpc seek -10";

          "XF86MonBrightnessUp" = "exec light -A 5";
          "XF86MonBrightnessDown" = "exec light -U 5";

          # toggle waybar
          "${modifier}+b" = "exec pkill -USR1 waybar";

          # layout
          "${modifier}+v" = "splitt";

          # fnott notifications
          "${modifier}+n" = "fnottctl dismiss";

          # lock
          "${modifier}+z" = "systemctl suspend";
        };

        modes = {
          resize = {
            "h" = "resize shrink width 50 px";
            "j" = "resize grow height 50 px";
            "k" = "resize shrink height 50 px";
            "l" = "resize grow width 50 px";
            "Escape" = "mode default";
            "Return" = "mode default";
            "${modifier}+r" = "mode default";
          };

          #passthrough = { "${modifier}+F11" = "mode default"; };
        };

        bars = [{ command = "waybar"; }];
        colors = with colorscheme.colors; {
          focused = {
            border = "#${base0D}";
            background = "#${base0D}";
            text = "#${base00}";
            indicator = "#${base0F}";
            childBorder = "";
          };
          focusedInactive = {
            border = "#${base00}";
            background = "#${base00}";
            text = "#${base06}";
            indicator = "#${base00}";
            childBorder = "";
          };
          unfocused = {
            border = "#${base00}";
            background = "#${base00}";
            text = "#${base06}";
            indicator = "#${base00}";
            childBorder = "";
          };
          urgent = {
            border = "#${base08}";
            background = "#${base08}";
            text = "#${base00}";
            indicator = "#${base0F}";
            childBorder = "";
          };
        };

      };

      extraConfig = ''
        workspace_auto_back_and_forth yes
      '';

      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland

        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export QT_SCALE_FACTOR="2";
        export QT_QPA_PLATFORMTHEME="qt5ct";
        export QT_WAYLAND_FORCE_DPI="physical";
      '';
    };

    systemd.user.services.fnott.Install.WantedBy = [ "sway-session.target" ];
  };
}

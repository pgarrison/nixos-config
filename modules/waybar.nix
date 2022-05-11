{ pkgs, lib, config, specialArgs, ... }:

with lib;

let
  cfg = config.modules.waybar;
in
{
  options = {
    modules.waybar = {
      enable = mkEnableOption "Enable waybar";

      bars = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            position = mkOption {
              type = types.nullOr types.str;
              default = null;
            };

            modules-left = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };

            modules-center = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };

            modules-right = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };
          };
        });
        default = { };
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      jq
      pulseaudio
      mpc_cli

      (nerdfonts.override {
        fonts = [ "JetBrainsMono" ];
      })
    ];

    programs.waybar = {
      enable = true;
      settings = mapAttrsToList (output: v: {
        inherit output;
        layer = "bottom";
        position = "bottom";
        margin = "4";
        modules-left = v.modules-left;
        modules-center = v.modules-center;
        modules-right = v.modules-right;

        "tray" = {
          icon-size = 14;
          spacing = 8;
        };

        "network" = {
          format = "🐑 {essid}";
          format-disconnect = "Disconnected";
          format-alt = "⬆️ {bandwidthUpBits} ⬇️ {bandwidthDownBits}";
          tooltip-format = "{ifname}: {signalStrength}%";
          max-length = 40;
          interval = 1;
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "🔓";
            deactivated = "🔒";
          };
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "🔇";
          format-source-muted = "🔇 (source)";
          format-bluetooth = " {volume}%";
          format-icons = {
            headphones = "";
            default = [ "奄" "奔" "墳" ];
          };
          on-click = "pamixer -t";
          on-click-right = "pamixer --default-source -t";
          scroll-step = 0.1;
        };

        "battery" = {
          format = "{icon} {capacity}%";
          format-plugged = "🔌 {capacity}%";
          format-icons = [" " " " " " " " " "];
          interval = 5;
          states = {
            warning = 30;
            critical = 15;
          };
          max-length = 25;
        };

        "clock" = {
          format = "🐢 {:%H:%M}";
          format-alt = "🐢 {:%a, %d %b %Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<small>{calendar}</small>";
        };

        "mpd" = {
          format = "{stateIcon} {artist} - {title}";
          format-disconnected = "ﱙ";
          format-stopped = " Stopped";
          state-icons = {
            paused = "";
            playing = "";
          };
          max-length = 40;
          interval = 1;
          on-click = "mpc toggle";
          on-click-right = "mpc stop";
          on-scroll-up = "mpc volume +1";
          on-scroll-down = "mpc volume -1";
        };

        "disk" = {
          format = "{path} {free}";
        };

        # sway only
        "sway/workspaces" = {
          format = "{name}";
        };

        "custom/scratchpad" = {
          interval = 1;
          exec = "swaymsg -t get_tree | jq 'recurse(.nodes[]) | first(select(.name==\"__i3_scratch\")) | .floating_nodes | length'";
          format = "  {}";
          tooltip = false;
          on-click = "swaymsg 'scratchpad show'";
          on-click-right = "swaymsg 'move scratchpad'";
        };

        # river only
        "river/tags" = {
          num-tags = 9;
        };
      }) cfg.bars;
      style = with config.colorscheme.colors; ''
        /* reset */
        * {
          padding: 0;
          margin: 0;
          min-height: 0;
        }

        button {
          min-width: 1.5em;
        }

        /* waybar */
        window#waybar {
          font-family: 'JetBrains Mono', 'JetBrainsMonoMedium Nerd Font';
          font-size: 12px;
          background: none;
          color: #${base06};
        }

        /* defaults */
        #workspaces,
        #tags,
        #custom-scratchpad,
        #custom-bluetooth,
        #network,
        #idle_inhibitor,
        #pulseaudio,
        #backlight,
        #battery,
        #clock,
        #disk,
        #mode,
        #tray,
        #mpd {
          background: #${base00};
          color: #${base06};
          padding: 0.25em 0.75em;
          margin: 0 0.65em;
          border-radius: 0.15em;
        }

        .modules-left {
          margin-left: 1.5em;
        }
        .modules-right {
          margin-right: 1.5em;
        }

        /* workspaces / tags */
        #workspaces button,
        #tags button {
          background: none;
          color: #${base02};
          font-weight: bold;
        }

        #tags button.occupied {
          color: #${base04};
        }

        #workspaces button.focused,
        #tags button.focused {
          color: #${base0D};
        }

        #workspace button.urgent,
        #tags button.urgent {
          color: #${base08};
        }

        #workspaces button:hover,
        #tags button:hover {
          color: #${base0B};
        }

        /* mpd */
        #mpd.disconnected {
          opacity: 0;
        }

        /* tray */
        #tray {
          margin-left: 1em;
          margin-right: 1em;
        }

        /* scratchpad */
        #custom-scratchpad {
          background: #${base0D};
          color: #${base00};
        }
      '';
    };
  };
}


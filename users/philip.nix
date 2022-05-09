{ config, pkgs, nix-colors, ... }:

rec {
  imports = [
    nix-colors.homeManagerModule
  ];

  colorscheme = nix-colors.colorSchemes.gruvbox-dark-medium;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "philip";
  home.homeDirectory = "/home/philip";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    aliases = {
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
    userName = "Philip Garrison";
  };

  # An upgraded ctrl-r for Bash whose history results make sense for what you're working on right now
  programs.mcfly = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # disable startup shell message
      set fish_greeting
    '';
  };

  programs.neovim = {
    enable = true;
    vimAlias = true; # symlink vim
    plugins = with pkgs.vimPlugins; [
      vim-nix
      # bufferline
      # lualine
      # nvim-tree
      vim-surround
      gruvbox
    ];
    extraConfig = "colorscheme gruvbox";
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures = { base = true; gtk = true; };

    config = rec {
      seat."*" = {
        hide_cursor = "when-typing enabled";
      };

      fonts = {
        names = [ "JetBrains Mono" ];
        size = 10.0;
      };

      gaps = {
        inner = 10;
        outer = 4;
      };

      window = {
        titlebar = false;
        border = 3;
      };

      floating = {
        border = 2;
        criteria = [
          {
            class = "firefox";
            title =  "Picture-in-Picture";
          }
          { app_id = "mpv"; }
        ];
      };

      modifier = "Mod4";
      keybindings = {
        # open terminal
        "${modifier}+Return" = "exec ${pkgs.foot}/bin/foot";

        # TODO fuzzel launcher

        "${modifier}+Shift+c" = "kill";

        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";
        "${modifier}+Shift+h" = "move left 20";
        "${modifier}+Shift+j" = "move down 20";
        "${modifier}+Shift+k" = "move up 20";
        "${modifier}+Shift+l" = "move right 20";

        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+space" = "focus mode_toggle";

        # modes
        "${modifier}+r" = "mode resize";
        "${modifier}+F11" = "mode passthrough";

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
        "${modifier}+t" = "layout toggle";

        "${modifier}+q" = "reload";
        "${modifier}+Shift+q" = "exec swaymsg exit";
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
          indicator = "#${base0F}";
          childBorder = "";
        };
        unfocused = {
          border = "#${base00}";
          background = "#${base00}";
          text = "#${base06}";
          indicator = "#${base0F}";
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

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland

      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';
  };
}

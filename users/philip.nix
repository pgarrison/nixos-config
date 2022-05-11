{ config, pkgs, nix-colors, ... }:

rec {
  imports = [
    nix-colors.homeManagerModule
    ../modules/waybar.nix
    ../modules/sway.nix
    ../modules/fnott.nix
    ../modules/shell/alias.nix
  ];

  modules.waybar = {
    enable = true;
    bars."eDP-1" = {
      modules-left = [
        #"custom/scratchpad" # Turns windows into floating windows
        "sway/workspaces"
        #"sway/mode" # Seems to have no effect?
      ];
      modules-center = [ "mpd" ];
      modules-right = [
        "tray"
        "idle_inhibitor"
        "network"
        "disk"
        "pulseaudio"
        "battery"
        "clock"
      ];
    };
  };

  modules.sway = {
    enable = true;
    wallpaper = pkgs.fetchurl {
      url = "https://files.catbox.moe/jv3ywu.jpg";
      hash = "sha256-3oHN2lEYUbagehGBf5CIVLCjA+HhZv6WECeV9bqVfJE=";
    };
  };

  modules.fnott.enable = true;

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

  home.sessionVariables = {
    EDITOR = "vim";
    MOZ_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "sway";
    NIXOS_OZONE = 1;
  };

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
    enableZshIntegration = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # disable startup shell message
      set fish_greeting
    '';
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    history.save = 100000; # number of lines to save
    history.size = 100000; # number of lines to keep. What's the difference?

    # Added to .zshrc
    initExtra = ''
      bindkey '^[[27;5;13~' autosuggest-execute
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
      ];
    };
    prezto = {
      enable = true;
      prompt.theme = "pure";
    };
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
    extraConfig = ''
      set number
      colorscheme gruvbox
    '';
  };

  programs.foot = {
    enable = true;
    # available settings defined here: https://codeberg.org/dnkl/foot/src/branch/master/foot.ini
    settings = {
      main = {
        app-id = "foot";
        title = "foot";
        term = "xterm-256color";
        font = "JetBrains Mono:size=8";
        pad = "10x10";
      };

      bell = {
        urgent = "no";
        notify = "no";
      };

      colors = with colorscheme; {
        alpha = 1.0;

        background = colors.base00;
        foreground = colors.base06;
        regular0 = colors.base01;
        regular1 = colors.base08;
        regular2 = colors.base0B;
        regular3 = colors.base0A;
        regular4 = colors.base0D;
        regular5 = colors.base0E;
        regular6 = colors.base0C;
        regular7 = colors.base06;
        bright0 = colors.base02;
        bright1 = colors.base08;
        bright2 = colors.base0B;
        bright3 = colors.base0A;
        bright4 = colors.base0D;
        bright5 = colors.base0E;
        bright6 = colors.base0C;
        bright7 = colors.base07;
      };

      scrollback.lines = 10000; # default 1000
    };
  };
}

{ config, pkgs, nix-colors, ... }:

{
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
}

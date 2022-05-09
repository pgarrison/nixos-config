{ pkgs, lib, config, ... }:

{
  fonts = {
    fontconfig.defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "Noto Sans" "Cascadia Code" ];
      serif = [ "Noto Serif" ];
    };

    fonts = with pkgs; [
      # programming fonts
      cascadia-code
      jetbrains-mono

      # nerd fonts
      (nerdfonts.override {
        fonts = [
          "CascadiaCode"
          "JetBrainsMono"
        ];
      })

      # noto fonts
      noto-fonts
      noto-fonts-extra
      noto-fonts-cjk
      noto-fonts-emoji
    ];
  };
}

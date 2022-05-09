{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.modules.fnott;

  defaults = {
    summary-font = "${config.gtk.font.name}:size=10:weight=bold";
    title-font = "${config.gtk.font.name}:size=6:weight=bold:slant=italic";
    body-font = "${config.gtk.font.name}:size=8:weight=regular";
    default-timeout = 5;
  };
in
{
  options = {
    modules.fnott = {
      enable = mkEnableOption "Enable fnott" // {
        #default = config.modules.sway.enable;
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.libnotify ];

    services.fnott = {
      enable = true;
      settings = {
        main = {
          notification-margin = 15;
          icon-theme = config.gtk.iconTheme.name;
        };

        low = {
          inherit (defaults) summary-font title-font body-font default-timeout;
          background = config.colorscheme.colors.base01;
          title-color = config.colorscheme.colors.base03;
        };

        normal = {
          inherit (defaults) summary-font title-font body-font default-timeout;
          background = config.colorscheme.colors.base00;
          title-color = config.colorscheme.colors.base03;
          summary-color = config.colorscheme.colors.base05;
          body-color = config.colorscheme.colors.base06;
        };
      };
    };
  };
}

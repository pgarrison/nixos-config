{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.modules.wayland;
in
{
  options = {
    modules.wayland = {
      enable = mkEnableOption "Enable wayland";
    };
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    #services.xserver.displayManager.gdm.wayland = true;
    xdg.portal = { enable = true; wlr.enable = true; };
    security.rtkit.enable = true;
    #security.pam.services.swaylock = { };

    hardware.pulseaudio.enable = false;

    environment.systemPackages = [
      pkgs.qt5.qtwayland
    ];
  };
}

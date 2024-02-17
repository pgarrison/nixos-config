{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.modules.gnome;
in
{
  options = {
    modules.gnome = {
      enable = mkEnableOption "Enable gnome";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    # displaylink uses binary unfree blob. Must be manually added via
    # nix-prefetch-url --name displaylink-580.zip https://www.synaptics.com/sites/default/files/exe_files/2023-08/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu5.8-EXE.zip
    # See https://nixos.wiki/wiki/Displaylink for more
    services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      #gnome-terminal
      gedit # text editor
      epiphany # web browser
      geary # email reader
      evince # document viewer
      #nome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

    environment.systemPackages = with pkgs; [
      gnome.adwaita-icon-theme
      gnomeExtensions.appindicator
    ];
  };
}

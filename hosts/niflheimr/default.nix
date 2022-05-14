# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/fonts.nix
      ../../modules/wayland.nix
    ];

  modules.wayland.enable = true;

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Niflheimr"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # support `nix search` and others
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (import ../../overlays/electron-overlay.nix)
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    autojump
    bat # better cat
    bitwarden-cli
    cava # alsa visualizations
    chromium
    curl
    curlie # more user-friendly curl
    exa
    expect
    fd # A simple, fast and user-friendly alternative to find
    feh
    firefox
    foot # terminal emulator
    fzf
    glances
    grim # screenshots
    lshw
    lynx
    mpv
    networkmanagerapplet
    nix-prefetch-scripts
    nvd
    pamixer
    qt5.qtwayland # For sway/gdm/wayland. Maybe unneeded? TODO: duplicate in modules/wayland.nix
    ranger
    redshift
    # An extremely fast alternative to grep that respects your gitignore
    ripgrep
    scrot
    signal-desktop
    # A community effort to simplify man pages with practical examples
    tealdeer
    tree
    vscodium
    wget
    which
    wlr-randr
    xsel
    zathura
    zoom-us # very unfree
    #  romkatv/zsh4humans needs packaging
  ];

  xdg.portal.wlr.enable = true; # support screensharing with sway

  services.physlock = import ../../modules/physlock.nix;

  programs.htop.enable = true;
  programs.neovim.enable = true;
  programs.light.enable = true; # backlight

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # redshift things
  location.latitude = 47.606;
  location.longitude = -122.332;

  services.redshift = {
    enable = true;
    brightness = {
      day = "1.0";
      night = "0.7";
    };
    temperature = {
      day = 4900;
      night = 4200;
    };
  };
  
  programs.neovim.defaultEditor = true;
  users.extraUsers.philip = {
    createHome = true;
    extraGroups = ["wheel" "video" "audio" "disk" "networkmanager"];
    group = "users";
    home = "/home/philip";
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
  };

  services.getty.autologinUser = "philip";

  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && WLR_NO_HARDWARE_CURSORS=1 sway
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.printing.enable = true;
  programs.system-config-printer.enable = true;

  programs.ssh.startAgent = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}


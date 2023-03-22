# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... } @ inputs:

let
  bw-ssh = (import ../../modules/shell/bw-ssh.nix) inputs;
in
rec {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/fonts.nix
      ../../modules/wayland.nix
      ../../modules/gnome.nix
    ];

  # BIOS version manager
  services.fwupd.enable = true;

  hardware.keyboard.zsa.enable = true;

  #modules.wayland.enable = true;
  modules.gnome.enable = true;

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

  # support `nix search` and others
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (import ../../overlays/electron-overlay.nix)
  ];

  # For League of Legends
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat # better cat
    bitwarden-cli
    bw-ssh # provided by my bw-ssh.nix
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
    gammastep
    glances
    google-chrome
    grim # screenshots
    htmlq # html parser like jq
    jq # json parser
    lshw
    lutris
    lynx
    mpv
    networkmanagerapplet
    nix-prefetch-scripts
    nvd
    pamixer
    pavucontrol
    ranger
    # An extremely fast alternative to grep that respects your gitignore
    ripgrep
    scrot
    signal-desktop
    # A community effort to simplify man pages with practical examples; tldr
    tealdeer
    tree
    unzip
    vscodium
    vulkan-tools # for League and other directx games?
    wally-cli
    wget
    which
    wlr-randr
    xsel
    zathura
    #zoom-us # very unfree
  ];

  xdg.portal.wlr.enable = true; # support screensharing with sway

  #services.logind.lidSwitch = "suspend-then-hibernate";

  #services.physlock = import ../../modules/physlock.nix;

  programs.htop.enable = true;
  programs.neovim.enable = true;
  programs.light.enable = true; # backlight

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
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

  programs.dconf.enable = true;

  # make ~/Downloads temporary (30 days)
  systemd.tmpfiles.rules = [
    "d ${users.extraUsers.philip.home}/Downloads 0755 philip users 30d"
  ];

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

  # Turn on cups
  services.printing.enable = true;
  programs.system-config-printer.enable = true;
  # Let cups find network printers
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
  # Setup drivers for Brother printers
  services.printing.drivers = [ pkgs.brlaser ];

  programs.ssh.startAgent = true;

  # Docker!
  virtualisation.docker.enable = true;

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


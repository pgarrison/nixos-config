{ home, ... }:
{ 
  home.shellAliases = {
    kexp = "mpv http://live-mp3-128.kexp.org";
    moon = "curl 'wttr.in/moon?Seattle+US'";
    nixos-list-updates = ''ls -v /nix/var/nix/profiles | tail -n 2 | awk '{print "/nix/var/nix/profiles/" $0}' - | xargs nvd diff'';
    rebuild = "nixos-rebuild switch --flake /home/philip/nixos-config --use-remote-sudo";
    shell = "nix-shell --run zsh -p";
    update = "nix flake update ~/nixos-config";
    weather = "curl 'wttr.in/?2nq'";
    wifi = "nmcli device wifi";
  };
}

{ home, ... }:
{ 
  home.shellAliases = {
    kexp = "mpv http://live-mp3-128.kexp.org";
    rebuild = "nixos-rebuild switch --flake /home/philip/nixos-config --use-remote-sudo";
    update = "nix flake update ~/nixos-config";
    nixos-list-updates = ''ls -v /nix/var/nix/profiles | tail -n 2 | awk '{print "/nix/var/nix/profiles/" $0}' - | xargs nvd diff'';
  };
}

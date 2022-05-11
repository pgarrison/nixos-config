{ home, ... }:
{ 
  home.shellAliases = {
    rebuild = "nixos-rebuild switch --flake /home/philip/nixos-config --use-remote-sudo";
    kexp = "mpv http://live-mp3-128.kexp.org";
  };
}

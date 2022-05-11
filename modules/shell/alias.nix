{ ... }:
{ 
  environment.interactiveShellInit = ''
    alias rebuild='nixos-rebuild switch --flake /home/philip/nixos-config --use-remote-sudo'
    alias kexp='mpv http://live-mp3-128.kexp.org'
  '';
}

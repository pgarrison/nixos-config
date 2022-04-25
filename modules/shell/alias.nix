{ ... }:
{ 
  environment.interactiveShellInit = ''
    alias rebuild='nixos-rebuild switch --flake /home/philip/nixos-config --use-remote-sudo'
  '';
}

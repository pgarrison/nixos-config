{ home, ... }:
{ 
  home.shellAliases = {
    kexp = "mpv http://live-mp3-128.kexp.org";
    moon = "curl 'wttr.in/moon?Seattle+US'";
    nixos-list-updates = ''ls -v /nix/var/nix/profiles | tail -n 2 | awk '{print "/nix/var/nix/profiles/" $0}' - | xargs nvd diff'';
    # Depends on htmlq. Usage: npr [n]
    npr = "fun(){ if [ -z \"\$1\" ]; then curl -s https://text.npr.org | htmlq a.topic-title --text | nl -w 2; else curl -s \$(curl -s https://text.npr.org/ | htmlq a.topic-title -b https://text.npr.org -a href | head -n \$1 | tail -1) | grep -v 'Related Story' | htmlq article -r .slug-line --text | grep -v '^ *$' | less; fi; unset -f fun }; fun";
    rebuild = "nixos-rebuild switch --flake /home/philip/nixos-config --use-remote-sudo";
    shell = "nix-shell --run zsh";
    update = "nix flake update ~/nixos-config";
    weather = "curl 'wttr.in/?2nq'";
    wifi = "nmcli device wifi";
  };
}

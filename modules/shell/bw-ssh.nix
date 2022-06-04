# package my script for getting ssh keys via the bitwarden cli
{ pkgs, lib, ... }:
with pkgs;
runCommandLocal "bw-ssh" {
  script = ./bw-ssh.sh;
  nativeBuildInputs = [ makeWrapper ];
} ''
  makeWrapper $script $out/bin/bw-ssh \
    --prefix PATH : ${lib.makeBinPath [ bash bitwarden-cli expect ]}
''

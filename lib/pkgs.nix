/*
 * Borrowed from Jakub Arbet's lib/pkgs.nix (https://github.com/KubqoA/dotfiles)
 */
{ pkgs, ... }:

let 
  inherit (pkgs.stdenv) mkDerivation;
in rec {
  _buildBinScript = buildInputs: name: mkDerivation {
    inherit name buildInputs;

    src = builtins.path { path = ../bin; name = "dotfiles"; };

    buildCommand = ''
      install -Dm755 $src/${name} $out/bin/${name}
      patchShebangs $out/bin/${name}
    '';
  };

  buildBinScript = _buildBinScript [];
}

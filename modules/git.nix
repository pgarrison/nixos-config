{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.modules.git;
in
{
  options = {
    modules.git = {
      enable = mkEnableOption "Enable git";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      aliases = {
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        cm = "commit -m";
        ap = "add -p";
        dc = "diff --cached";
        ds = "diff --stat";
        dcs = "diff --cached --stat";
        rs = "restore --staged .";
      };
      userName = "Philip Garrison";
    };
  };
}

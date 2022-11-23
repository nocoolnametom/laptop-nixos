{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.safeeyes;
in {
  options = {
    services.safeeyes = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable safeeyes. (Delete when updated past 22.05!)
        '';
      };
    };
  };

  config = mkIf cfg.enable { };
}

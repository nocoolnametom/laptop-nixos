{ config, lib, pkgs, ... }:

with lib;

let cfg = config.home.envDiff;
in {
  options = {
    home.envDiff = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable different options for a dual-boot environment.
        '';
      };
      isNixos = mkOption {
        default = true;
        description = ''
          Whether we're running in NixOS or not (for a dual-boot NixOS/Pop_OS! setup).
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (!cfg.isNixos) {
      # Pop_OS! specific settings
      home.stateVersion = "22.05";

      # Safe Eyes RSI prevention
      services.safeeyes.enable = true;

      # Home Manager is not installed on NixOS
      # Because of this, do not use this file in a NixOS configuration.nix module
      targets.genericLinux.enable = true;

      # Apps for only Pop_OS!
      home.packages = [

      ];
    })
    (mkIf (cfg.isNixos) {
      # NixOS specific settings
      home.stateVersion = "22.05";

      # RSI break (I like safe eyes better, but it's not avaialble on HM 22.05)
      services.rsibreak.enable = true;

      # Apps for only NixOS
      home.packages = [
        pkgs.firefox # Fotns get messed up on Pop_OS if Nix Firefox is used
        pkgs.wget pkgs.rsync pkgs.steam pkgs.steam-run pkgs.latte-dock ];
    })
  ]);
}

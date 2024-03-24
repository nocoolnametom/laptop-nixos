{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.home.envDiff;
  isNixosCheck = builtins.pathExists /etc/nixos/configuration.nix;

  # Pop_OS! specific settings
  popOsConf = rec {
    home.stateVersion = "22.11";

    # Home Manager is not installed on NixOS
    # Because of this, do not use this file in a NixOS configuration.nix module
    targets.genericLinux.enable = true;

    # Apps for only Pop_OS!
    home.packages = [ pkgs.gnome-connections ];
  };

  # NixOS specific settings
  nixOsConf = rec {
    # Note that since we can't import within imports when using Home Manager as a
    # NixOS module, we need to load the NixOS-only imports in the main home.nix,
    # so the NixOS-specific setting you're looking for may be located in one of
    # those imports

    home.stateVersion = "22.11";

    services.waynergy.enable = true;

    # Apps for only NixOS
    home.packages = [
      pkgs.authy
      pkgs.firefox # Fonts get messed up on Pop_OS if Nix Firefox is used, so it's here
      pkgs.zoom-us # Easier to just install this via regular channels on Pop_OS
      pkgs.krdc # RDP client
      pkgs.wget
      pkgs.rsync
      pkgs.steam
      pkgs.steam-run
      pkgs.ktouch
      pkgs.kdeconnect
    ];
  };
in {
  options = {
    home.envDiff = {
      enable = mkOption {
        # You can explicitly opt out of the differentiated environments if needed
        default = true;
        description = ''
          Whether to enable different options for a dual-boot environment.
        '';
      };
      isNixos = mkOption {
        # You don't need to set this explicitly; we'll use presence of configuration.nix
        # to automatically determine if we're in a NixOS environment or not
        default = isNixosCheck;
        description = ''
          Whether we're running in NixOS or not (for a dual-boot NixOS/Pop_OS! setup).
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (!cfg.isNixos) popOsConf)
    (mkIf (cfg.isNixos) nixOsConf)
  ]);
}

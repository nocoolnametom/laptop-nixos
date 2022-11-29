{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.workrave;

in {
  options = {
    services.workrave = {
      enable = mkEnableOption "Workrave RSI prevention tool";

      package = mkPackageOption pkgs "workrave" { };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (hm.assertions.assertPlatform "services.workrave" pkgs platforms.linux)
    ];

    home.packages = [ cfg.package ];

    systemd.user.services.workrave = {
      Install.WantedBy = [ "graphical-session.target" ];

      Unit = {
        Description = "Workrave RSI Prevention Tool";
        PartOf = [ "graphical-session.target" ];
        StartLimitIntervalSec = 350;
        StartLimitBurst = 30;
      };

      Service = {
        ExecStart = getExe pkgs.workrave;
        Restart = "on-failure";
        RestartSec = 3;
      };
    };
  };
}
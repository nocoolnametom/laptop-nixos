{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.maestral;
  maestralCmd = "${cfg.package}/bin/maestral";
in {
  meta.maintainers = [ maintainers.eyjhb ];

  options = {
    services.maestral = {
      enable = mkEnableOption "Maestral daemon";

      package = mkOption {
        type = with types; nullOr package;
        default = pkgs.maestral;
        defaultText = literalExpression "${pkgs.maestral}";
        description = ''
          Maestral package to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "services.maestral" pkgs
        lib.platforms.linux)
    ];

    home.packages = [ cfg.package ];

    systemd.user.services.maestral = {
      Unit = {
        Description = "Maestral Open-source Dropbox Daemon";
        After = [ "network-online.target" ];
      };

      Install = { WantedBy = [ "default.target" ]; };

      Service = {
        Type = "notify";
        NotifyAccess = "exec";
        PIDFile = "${config.home.homeDirectory}/.maestral/maestral.pid";

        ExecStart = "${maestralCmd} start -f";
        ExecStop = "${maestralCmd} stop";
        ExecStopPost = ''
          ${pkgs.bash}/bin/bash -c "if [ $SERVICE_RESULT != success ]; then ${pkgs.libnotify}/bin/notify-send Maestral 'Daemon failed'; fi"
        '';
        WatchdogSec = "30s";

        PrivateTmp = true;
      };
    };
  };
}

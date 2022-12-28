{ config, lib ? pkgs.lib, pkgs, ... }:

with lib;

let
  cfg = config.services.waynergy;
  hostname = if (builtins.getEnv "HOSTNAME") != "" then
    (builtins.getEnv "HOSTNAME")
  else
    (if builtins.pathExists /etc/hostname then
      builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile /etc/hostname)
    else
      "toms-machine");
  waynergyPkg = pkgs.stdenv.mkDerivation rec {
    pname = "waynergy";
    version = "0.0.15";
    src = pkgs.fetchFromGitHub {
      owner = "r-c-f";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-pk1U3svy9r7O9ivFjBNXsaOmgc+nv2QTuwwHejB7B4Q=";
    };
    nativeBuildInputs = with pkgs; [
      meson
      ninja
      pkg-config
      wayland
      libxkbcommon
      libressl
      git
    ];
    postInstall = ''
      cp -a ../doc/xkb $out/share/xkb
    '';
    meta = {
      description =
        "Implementation of a synergy client for wayland compositors";
      homepage = "https://github.com/r-c-f/waynergy";
      license = licenses.mit;
      maintainers = with maintainers; [ nocoolnametom ];
      platforms = platforms.linux;
    };
  };
in {
  options = {
    services.waynergy = {
      enable = mkEnableOption "Whether to enable waynergy configuration";

      name = mkOption {
        type = types.nullOr types.str;
        default = hostname;
        description = ''
          Screen name of client.
        '';
      };

      host = mkOption {
        type = types.str;
        description = ''
          Server to connect to
        '';
      };

      port = mkOption {
        type = types.str;
        description = ''
          Port to connect to
        '';
      };

      enableCrypto = mkEnableOption "crypto (SSL) plugin" // {
        default = true;
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [ ];
        defaultText = literalExpression ''[ "-f" ]'';
        description = ''
          Additional flags to pass to <command>waynergy</command>.
          See <command>waynergy --help</command>.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "services.waynergy" pkgs
        lib.platforms.linux)
    ];

    xdg.configFile."waynergy/config.ini".text =
      generators.toINIWithGlobalSection { } {
        globalSection = {
          host = cfg.host;
          port = cfg.port;
          name = cfg.name;
          syn_raw_key_codes = false;
          xkb_key_offset = 7;
        };
        sections = {
          tls = {
            enable = cfg.enableCrypto;
            tofu = cfg.enableCrypto;
          };
        };
      };

    home.file.".xkb/keycodes/mac".source =
      "${waynergyPkg}/share/xkb/keycodes/mac";
    xdg.configFile."waynergy/xkb_keymap".text = ''
            xkb_keymap {
            	xkb_keycodes  { include "mac+aliases(qwerty)"	};
            	xkb_types     { include "complete"	};
            	xkb_compat    { include "complete"	};
      	      xkb_symbols   { include "pc+us+inet(evdev)"	};
      	      xkb_geometry  { include "pc(pc105)"	};
            };
    '';

    home.packages = [ waynergyPkg ];

    systemd.user.services.waynergy = {
      Install.WantedBy = [ "graphical-session.target" ];

      Unit = {
        Description = "Wayland-Enabled Syngery Client";
        After = [
          "network-online.target"
          "graphical-session-pre.target"
          "sway-session.target"
        ];
        PartOf = [ "graphical-session.target" ];
        StartLimitBurst =
          3; # How many failures to allow before not retrying again
        StartLimitIntervalSec =
          30; # Length of time for failures to occur within
      };

      Service = {
        Type = "simple";
        ExecStartPre =
          "${pkgs.systemd}/bin/systemd --user stop barrierc.service";
        ExecStart = "${waynergyPkg}/bin/waynergy ${
            lib.concatStringsSep " " cfg.extraFlags
          }";
        Restart = "on-failure";
        RestartSec = 5;
      };

    };

  };
}


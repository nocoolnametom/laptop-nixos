{ config, lib, pkgs, ... }:

let isNixos = builtins.pathExists /etc/nixos/configuration.nix;
in {
  services.spotifyd.settings.global.username = "oey8uvlx90107ncq7chxkh504";
  services.spotifyd.settings.global.password_cmd =
    "${config.programs.password-store.package}/bin/pass spotify.com/nocoolnametom@gmail.com | head -n1";
  # We use the machine hostname to generate the Spotify speaker name
  services.spotifyd.settings.global.device_name = "${
      if (builtins.getEnv "HOSTNAME") != "" then
        (builtins.getEnv "HOSTNAME")
      else
        (if builtins.pathExists /etc/hostname then
          builtins.replaceStrings [ "\n" ] [ "" ]
          (builtins.readFile /etc/hostname)
        else
          "toms-machine")
    }-spotifyd";
  services.spotifyd.settings.global.backend = "pulseaudio";
  services.spotifyd.settings.global.device_type = "computer";
}

{ config, pkgs, ... }:

{
  imports = [
    # Helpers to manage missing modules beteen laptop environments
    # and their home-manager installations.
    #
    # This is because HM modules can't include imports within their
    # configuration blocks, so these helpers use the presence of
    # the NixOS configuration.nix file to import helpers for
    # NixOs/non-NixOS home-managers
    ./helpers

    # Specific configurations for NixOS vs. non-NixOS home-manager
    ./envDiffs

    # Everything Bash
    ./bash

    # Everything SSH
    ./ssh

    # Protonmail Bridge
    ./protonmail

    # Davmail
    ./davmail

    # Workrave
    ./workrave
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "tdoggett";
  home.homeDirectory = "/home/tdoggett";

  services.barrier.client.enable = true;
  services.barrier.client.server = "192.168.0.11:24801";

  services.dropbox.enable = true;

  services.protonmail.enable = true;
  services.protonmail.nonInteractive = true;

  services.davmail-config.enable = true;

  # Workrave RSI prevention
  services.workrave.enable = true;

  home.packages = [
    pkgs.nixfmt
    pkgs.git
    pkgs.brave
    pkgs.vlc
    pkgs.google-chrome
    pkgs.vim
    pkgs.vscode
    pkgs.obsidian
    pkgs.silver-searcher
    pkgs.screen
    pkgs.wireguard-tools
    (pkgs.writeShellScriptBin "restart-systems-on-login" ''
      sleep 10s
      systemctl --user restart barrierc.service protonmail.service davmail.service workrave.service
    '')
  ];

  # Spotify Speaker
  services.spotifyd.enable = true;
  services.spotifyd.settings.global.username = "oey8uvlx90107ncq7chxkh504";
  services.spotifyd.settings.global.passwordCmd =
    "pass spotify.com/nocoolnametom@gmail.com | head -n1";
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
  services.spotifyd.settings.global.device-type = "computer";

  # PlayerCtl Daemon service
  services.playerctld.enable = true;

  # Pass store sync
  services.password-store-sync.enable = true;

  # Browserpass
  programs.browserpass.enable = true;
  programs.browserpass.browsers = [ "brave" "chrome" "firefox" ];

  # Gnu Pass and Automated Updates to Password Store
  programs.password-store.enable = true;
  programs.password-store.package =
    pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  programs.password-store.settings.PASSWORD_STORE_DIR =
    "${config.home.homeDirectory}/.password-store";

  # GPG
  # On non-NixOS try replacing /usr/bin/gpg, /usr/bin/gpg-agent,
  # and /usr/bin/gpgconf with symlinks to the HM commands to
  # prevent version mismatches.
  programs.gpg.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

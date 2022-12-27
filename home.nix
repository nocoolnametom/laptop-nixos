{ config, pkgs, ... }:

let
  # I don't use the impermanence HM module, but we need to load HM via Nixos to ensure
  # the symlinks are present in a fresh TMPFS version of /home/tdoggett, so make sure
  # that home.nix is imported into /etc/nixos/configuration.nix
  impermanence = builtins.fetchTarball {
    url = "https://github.com/nix-community/impermanence/archive/master.tar.gz";
  };
  isNixosCheck = builtins.pathExists /etc/nixos/configuration.nix;
in {
  imports = [
    ## CONFIGURATION------------------------------------------------------------ ##
    # Specific configurations for NixOS vs. non-NixOS home-manager
    ./configurations/envDiffs

    # Barrier - software KVM for X11
    ./configurations/barrier

    # Bash
    ./configurations/bash

    # SSH
    ./configurations/ssh

    # Davmail
    ./configurations/davmail

    # Dropbox
    ./configurations/dropbox

    # GPG
    ./configurations/gpg

    # Pass stuff
    ./configurations/pass

    # Playerctl
    ./configurations/playerctld

    # Protonmail
    ./configurations/protonmail

    # Safe Eyes
    ./configurations/safeeyes

    # Spotify
    ./configurations/spotify

    # VSCode
    ./configurations/vscode

    # Waynergy
    ./configurations/waynergy

    ## MODULES ----------------------------------------------------------------- ##
    # Protonmail Bridge
    ./modules/protonmail

    # Davmail Service and Config File
    ./modules/davmail

  ] ++ (if isNixosCheck then [
    # Since HM modules can't hold their own imports, we need to handle conditional importing here

    # Impermanence helper functions
    "${impermanence}/home-manager.nix"

    ## CONFIGURATION ----------------------------------------------------------- ##
    # Impermanence
    ./configurations/persistence

    # Sway
    ./configurations/swaywm

    ## MODULES ----------------------------------------------------------------- ##
    # Synergy/Barrier client for Wayland
    ./modules/waynergy
  ] else
    [
      # These imports will only be used if we're not running NixOS
    ]);

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "tdoggett";
  home.homeDirectory = "/home/tdoggett";

  # Whether to write program configuration files to the home
  programs.bash.enable = true;
  programs.browserpass.enable = true;
  programs.password-store.enable = true;
  programs.ssh.enable = true;

  # Whether to run services
  services.barrier.client.enable = true;
  services.davmail-config.enable = true;
  services.dropbox.enable = true;
  services.gnome-keyring.enable = true;
  services.playerctld.enable = true;
  services.protonmail.enable = true;
  services.spotifyd.enable = true;
  services.password-store-sync.enable = true;
  services.safeeyes.enable = true;

  # Whether to install window managers
  wayland.windowManager.sway.enable = true;
  xsession.windowManager.i3.enable = true;

  # Application installed to both NixOS and PopOS users through Home Manager
  home.packages = [
    pkgs.nixfmt
    pkgs.git
    pkgs.brave
    pkgs.vlc
    pkgs.google-chrome
    pkgs.vim
    pkgs.obsidian
    pkgs.silver-searcher
    pkgs.screen
    pkgs.todoist-electron
    pkgs.wireguard-tools
    (pkgs.writeShellScriptBin "restart-systems-on-login" ''
      sleep 10s
      systemctl --user restart barrierc.service protonmail.service davmail.service safeeyes.service
    '')
    (pkgs.appimageTools.wrapType2 {
      name = "android-messages-desktop";
      src = pkgs.fetchurl {
        url =
          "https://github.com/OrangeDrangon/android-messages-desktop/releases/download/v5.4.1/Android-Messages-v5.4.1-linux-x86_64.AppImage";
        hash = "sha256-JT/68wDGYr9Resmy5cN6bQrXm340gKWawPuDZ762Qmc=";
      };
    })
  ];

  # Tell Electron to use Wayland
  xdg.configFile."electron-flags.conf".text = ''
    --enable-features=WaylandWindowDecorations
    --ozone-platform-hint=auto
  '';

  # Tell VSCode to use Wayland
  xdg.configFile."code-flags.conf".source =
    "${config.xdg.configFile."electron-flags.conf".source}";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

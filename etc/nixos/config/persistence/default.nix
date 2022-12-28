{ config, lib, pkgs, ... }:

let
  impermanence = builtins.fetchTarball
    "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in {
  imports = [ "${impermanence}/nixos.nix" ];

  # This links the nixos configuration in this project to the /etc/nixos/ directory
  # Note that the configuration refers to the persisted home of
  # harware-configuration.nix which is not co-located in this repo currently
  environment.persistence."/uni/home/tdoggett/Projects/nocoolnametom/laptop-nixos" =
    {
      # files = [{ file = "/etc/nixos/configuration.nix"; }];
      directories = [ "/etc/nixos" ];
      hideMounts = true;
    };

  # Shared between OS's user persistence stuff - prevents mucking up df -h, though present on lsblk
  environment.persistence."/uni".users.tdoggett.directories = [
    "Projects" # This needs to be available for the nixos-rebuild use of home.nix!
    "Downloads"
    "Documents"
    "Desktop"
    "Arduino"
    "Games"
    "DataGripProjects"
    "Pictures"
    "Music"
    "Videos"
  ];

  # Persisted user config stuff that can't be symlinked
  environment.persistence."/uni/persist".users.tdoggett.directories = [
    # Brave Browser
    ".config/BraveSoftware"

    # Google Chrome
    ".config/google-chrome"

    # Firefox
    ".mozilla"

    # GnuPG keys
    ".gnupg"
    ".pki"

    # Pass
    ".password-store"

    # SSH
    ".ssh"

    # Gnome Keyrings (for secrets storage)
    ".local/share/keyrings"
  ];

  # Persisted NixOS system-level stuff, stored alongisde the Nix store on the /nix partition
  environment.persistence."/nix/persist" = {
    directories = [
      "/etc/ssh"
      "/var/log"
      "/var/lib"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
      "/etc/machine-info"
      "/root/.config/nixpkgs/config.nix"
    ];
    hideMounts = true;
  };
}

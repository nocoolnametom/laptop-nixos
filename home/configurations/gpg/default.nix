{ config, lib, pkgs, ... }:

{
  # On non-NixOS try replacing /usr/bin/gpg, /usr/bin/gpg-agent,
  # and /usr/bin/gpgconf with symlinks to the HM commands to
  # prevent version mismatches.

  # programs.gpg.enable = true;
  programs.gpg.enable = false; # Moving to NixOS for gpg-agent

  services.gpg-agent.enable = true;
  services.gpg-agent.maxCacheTtl = 34560000;
  services.gpg-agent.defaultCacheTtl = 34560000;
  # services.gpg-agent.pinentryFlavor = "gtk2";
  # services.gpg-agent.pinentryFlavor = "qt";
  services.gpg-agent.pinentryPackage = lib.mkForce pkgs.pinentry-qt;
}

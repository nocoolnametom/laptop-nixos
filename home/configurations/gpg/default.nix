{ config, lib, pkgs, ... }:

{
  # On non-NixOS try replacing /usr/bin/gpg, /usr/bin/gpg-agent,
  # and /usr/bin/gpgconf with symlinks to the HM commands to
  # prevent version mismatches.
  programs.gpg.enable = true;
}

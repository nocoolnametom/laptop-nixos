{ config, lib, pkgs, ... }:

let isNixos = builtins.pathExists /etc/nixos/configuration.nix;
in {
  imports = if isNixos then
    [
      ./fakeSafeeyes.nix # Remove once HM is past 22.05
    ]
  else
    [

    ];
}

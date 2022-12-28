{ config, lib, pkgs, ... }:

{
  services.waynergy.host = "192.168.0.11";
  services.waynergy.port = "24801";
}

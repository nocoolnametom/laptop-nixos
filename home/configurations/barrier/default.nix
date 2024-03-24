{ config, lib, pkgs, ... }:

{
  services.barrier.client.server = "192.168.0.10:24801";
}

{ config, lib, pkgs, ... }:

{
  # Browserpass
  programs.browserpass.browsers = [ "brave" "chrome" "firefox" ];

  # Gnu Pass and Automated Updates to Password Store
  programs.password-store.package =
    pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  programs.password-store.settings.PASSWORD_STORE_DIR =
    "${config.home.homeDirectory}/.password-store";
}

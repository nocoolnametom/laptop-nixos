{ config, pkgs, ... }:

let
  vscodeUnstablePkgs = (import (fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/refs/heads/nixos-unstable.tar.gz")
    { }).pkgs;
in {
  # VSCode configuration
  programs.vscode.enable = true;
  programs.vscode.package =
    # ((pkgs.vscode.override { isInsiders = true; }).overrideAttrs
    #   (oldAttrs: rec {
    #     src = (builtins.fetchTarball {
    #       url =
    #         "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
    #       sha256 = insidersSha;
    #     });
    #     version = "latest";
    #     pname = "vscode-insiders";
    #   }));
    vscodeUnstablePkgs.vscode;
  programs.vscode.enableExtensionUpdateCheck = false;
  programs.vscode.enableUpdateCheck = false;
  programs.vscode.userSettings = {
    "editor.inlineSuggest.enabled" = true;
    "editor.autoClosingBrackets" = "never";
    "editor.fontLigatures" = true;
    "[typescript]"."editor.defaultFormatter" =
      "vscode.typescript-language-features";
    "github.copilot.enable"."*" = true;
    "github.copilot.enable"."yaml" = true;
    "github.copilot.enable"."plaintext" = true;
    "github.copilot.enable"."markdown" = true;
    "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
    "editor.renderWhitespace" = "trailing";
    "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
    "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
    "diffEditor.ignoreTrimWhitespace" = false;
    "redhat.telemetry.enabled" = true;
    "git.autofetch" = true;
    "window.zoomLevel" = -1;
    "php.debug.executablePath" = "";
  };
  programs.vscode.mutableExtensionsDir = true;
  # programs.vscode.extensions = with pkgs.vscode-extensions;
  #   [
  #     arrterian.nix-env-selector
  #     bierner.markdown-mermaid
  #     # bmewburn.vscode-intelephense-client
  #     # bpruitt-goddard.mermaid-markdown-syntax-highlighting
  #     eamodio.gitlens
  #     # ecmel.vscode-html-css
  #     esbenp.prettier-vscode
  #     github.copilot
  #     # github.copilot-labs
  #     gitlab.gitlab-workflow
  #     jnoortheen.nix-ide
  #     # marcoq.vscode-typescript-to-json-schema
  #     ms-vscode.makefile-tools
  #     # ms-vscode.remote-explorer
  #     ms-vscode-remote.remote-ssh
  #     redhat.vscode-yaml
  #     usernamehw.errorlens
  #     vscodevim.vim
  #     WakaTime.vscode-wakatime
  #     yzhang.markdown-all-in-one
  #   ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  #     {
  #       name = "php-debug";
  #       publisher = "xdebug";
  #       version = "1.29.1";
  #       sha256 = "sha256-xpsHvmwboFkOGH4frfYYijgUtRHbdv476fN0B4pjg4U=";
  #     }
  #     {
  #       name = "vscode-versionlens";
  #       publisher = "pflannery";
  #       version = "1.0.10";
  #       sha256 = "sha256-+LDknkHqziDgwiUBfUHu15BP894P+cJuM9YQagg5sis=";
  #     }
  #     {
  #       name = "copilot-labs";
  #       publisher = "github";
  #       version = "0.4.488";
  #       sha256 = "sha256-Vy7T8PfU/4vAgHtFb++mJCfQYVijIL183XgfOJRB0ck=";
  #     }
  #     {
  #       name = "mermaid-markdown-syntax-highlighting";
  #       publisher = "bpruitt-goddard";
  #       version = "1.5.0";
  #       sha256 = "sha256-Lf+I2zN2bVDcVDhW9kJDvjm+PFa4WsjKhJPQRNndHfA=";
  #     }
  #     {
  #       name = "vscode-intelephense-client";
  #       publisher = "bmewburn";
  #       version = "1.8.2";
  #       sha256 = "sha256-OvWdDQfhprQNve017pNSksMuCK3Ccaar5Ko5Oegdiuo=";
  #     }
  #     {
  #       name = "remote-server";
  #       publisher = "ms-vscode";
  #       version = "1.0.0";
  #       sha256 = "sha256-upS04kQoMPVZrvU8jVkLd+5qBd8INvx3eoHdvdpljRE=";
  #     }
  #     {
  #       name = "remote-explorer";
  #       publisher = "ms-vscode";
  #       version = "0.0.3";
  #       sha256 = "sha256-m4/MCudWY3ESP0rk18DKPHn965CGYI2h6vFjJUAvVAE=";
  #     }
  #   ];

  # home.packages = [
  #   
  # ];
}

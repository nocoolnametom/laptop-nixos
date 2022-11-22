{ config, pkgs, ... }:

let isNixos = builtins.pathExists /etc/nixos/configuration.nix;
in {
  # Remove the fakeSafeeyes import after updating past HM 22.05!
  # imports = [ ./home.envDiff.nix ];
  imports = if !isNixos then
    [ ./home.envDiff.nix ]
  else [
    ./home.envDiff.nix
    ./fakeSafeeyes.nix
  ];
  home.envDiff.enable = true;
  home.envDiff.isNixos = isNixos;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "tdoggett";
  home.homeDirectory = "/home/tdoggett";

  services.barrier.client.enable = true;
  services.barrier.client.server = "192.168.0.11:24801";

  services.dropbox.enable = true;

  programs.bash.enable = true;
  programs.bash.historyControl = [ "ignoredups" "ignorespace" ];
  programs.bash.initExtra = ''
    # make less more friendly for non-text input files, see lesspipe(1)
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "${"$"}{debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
      debian_chroot=$(cat /etc/debian_chroot)
    fi

    # set a fancy prompt (non-color, unless we know we "want" color)
    case "$TERM" in
      xterm-color|*-256color) color_prompt=yes;;
    esac

    # uncomment for a colored prompt, if the terminal has the capability; turned
    # off by default to not distract the user: the focus in a terminal window
    # should be on the output of commands, not on the prompt
    #force_color_prompt=yes

    if [ -n "$force_color_prompt" ]; then
      if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
      else
        color_prompt=
      fi
    fi

    if [ "$color_prompt" = yes ]; then
      PS1='${
        "$"
      }{debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    else
      PS1='${"$"}{debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    fi
    unset color_prompt force_color_prompt

    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
    xterm*|rxvt*)
      PS1="\[\e]0;${"$"}{debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
      ;;
    *)
      ;;
    esac

    # enable color support of ls and also add handy aliases
    if [ -x /usr/bin/dircolors ]; then
      test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
      alias ls='ls --color=auto'
      #alias dir='dir --color=auto'
      #alias vdir='vdir --color=auto'

      alias grep='grep --color=auto'
      alias fgrep='fgrep --color=auto'
      alias egrep='egrep --color=auto'
    fi

    if [ -f ~/.bash_aliases ]; then
      . ~/.bash_aliases
    fi

  '' + (if isNixos then
    ""
    # Ensure on Pop_OS! that the $NIX_PATH is set correctly
  else ''
    export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${
      "$"
    }{NIX_PATH:+:$NIX_PATH}
  '');

  programs.bash.profileExtra = ''
    # if running bash
    if [ -n "$BASH_VERSION" ]; then
      # include .bashrc if it exists
      if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
      fi
    fi

    # set PATH so it includes user's private bin if it exists
    if [ -d "$HOME/bin" ] ; then
      PATH="$HOME/bin:$PATH"
    fi

    # set PATH so it includes user's private bin if it exists
    if [ -d "$HOME/.local/bin" ] ; then
      PATH="$HOME/.local/bin:$PATH"
    fi
  '';

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
    pkgs.ktouch # typing tutor
  ];

  # Spotify Speaker
  services.spotifyd.enable = true;
  services.spotifyd.settings.global.username = "oey8uvlx90107ncq7chxkh504";
  services.spotifyd.settings.global.passwordCmd =
    "pass spotify.com/nocoolnametom@gmail.com | head -n1";
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

  # Gnu Pass
  programs.password-store.enable = true;
  programs.password-store.package =
    pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  programs.password-store.settings.PASSWORD_STORE_DIR =
    "${config.home.homeDirectory}/.password-store";

  # GPG
  programs.gpg.enable = true;

  # SSH configuration
  programs.ssh.enable = true;
  programs.ssh.compression = true;
  programs.ssh.extraConfig = ''
    IdentityFile ${toString ./myKeys/private/id_rsa}
  '';
  programs.ssh.matchBlocks.ZG02911.identityFile =
    toString ./myKeys/private/work_rsa;
  programs.ssh.matchBlocks.zg02911vmu.identityFile =
    toString ./myKeys/private/work_rsa;
  programs.ssh.matchBlocks.github.hostname = "github.com";
  programs.ssh.matchBlocks.github.user = "git";
  programs.ssh.matchBlocks.gitlab.hostname = "gitlab.com";
  programs.ssh.matchBlocks.gitlab.user = "git";
  programs.ssh.matchBlocks.elrond.hostname = "45.33.53.132";
  programs.ssh.matchBlocks.elrond.user = "root";
  programs.ssh.matchBlocks.elrond.port = 2222;
  programs.ssh.matchBlocks.linode.hostname = "45.33.53.132";
  programs.ssh.matchBlocks.linode.user = "root";
  programs.ssh.matchBlocks.linode.port = 2222;
  programs.ssh.matchBlocks."exmormon.social".port = 2222;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage==
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  # In NixOS we use the NixOS version, in Pop_OS we use unstable,
  # so this value is now handled within home.envDiff.nix
  #  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

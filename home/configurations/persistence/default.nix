{ config, lib, pkgs, ... }:

let
  homePersistDir = "/uni/persist/home/tdoggett";
  fullHomePersistDir = "/uni/home/tdoggett";
in {
  home.persistence."${fullHomePersistDir}" = {
    allowOther = false;
    directories = [
      # This is bound only because we need to have at least one directory bound to use the HM impermanence module
      # I prefer to bind using the NixOS module as it can be hidden from `df -h`
      "Dropbox"
    ];
  };
  home.persistence."${homePersistDir}" = {
    allowOther = false;

    # Some directories are handled in the NixOS configuration instead of here:
    # Brave, Chrome, Firefox, Dropbox, GnuPG, and Password store

    directories = [
      # Maestral Dropbox Client
      {
        directory = ".local/share/maestral";
        method = "symlink";
      }
      {
        directory = ".config/maestral";
        method = "symlink";
      }

      # VSCode extension and credential storage
      {
        directory = ".config/Code/User/globalStorage";
        method = "symlink";
      }

      # Android Messages Storage
      {
        directory = ".config/android-messages-desktop";
        method = "symlink";
      }

      # Audacity Audio Editor
      {
        directory = ".config/audacity";
        method = "symlink";
      }

      # Barrier
      {
        directory = ".local/share/barrier";
        method = "symlink";
      }

      # Thunderbird
      {
        directory = ".thunderbird";
        method = "symlink";
      }

      # GTK
      {
        directory = ".config/gtk-3.0";
        method = "symlink";
      }
      {
        directory = ".config/gtk-4.0";
        method = "symlink";
      }

      # Obsidian
      {
        directory = ".config/obsidian";
        method = "symlink";
      }

      # Steam
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
      {
        directory = ".steam";
        method = "symlink";
      }

      # DirEnv
      {
        directory = ".local/share/direnv";
        method = "symlink";
      }

      # Wakatime
      {
        directory = ".wakatime";
        method = "symlink";
      }

      # Safe Eyes RSI Prevention
      {
        directory = ".config/safeeyes";
        method = "symlink";
      }

      # XFCE configuration
      {
        directory = ".config/xfce4/mcs_settings";
        method = "symlink";
      }
      {
        directory = ".config/xfce4/panel";
        method = "symlink";
      }
      {
        directory = ".config/xfce4/xffm";
        method = "symlink";
      }
      {
        directory = ".config/xfce4-sessions";
        method = "symlink";
      }
      {
        directory = ".config/xfce4/xfconf/xfce-perchannel-xml";
        method = "symlink";
      }

      # KDE
      # {
      #   directory = ".config/kde.org";
      #   method = "symlink";
      # }
      # {
      #   directory = ".config/kdeconnect";
      #   method = "symlink";
      # }
      # {
      #   directory = ".config/plasma-workspace";
      #   method = "symlink";
      # }
      # {
      #   directory = ".config/xsettingsd";
      #   method = "symlink";
      # }
      # {
      #   directory = ".kde";
      #   method = "symlink";
      # }
      # {
      #   directory = ".local/share/baloo";
      #   method = "symlink";
      # }
      # {
      #   directory = ".local/share/dolphin";
      #   method = "symlink";
      # }
      # {
      #   directory = ".local/share/kactivitymanagerd";
      #   method = "symlink";
      # }
      # {
      #   directory = ".local/share/kate";
      #   method = "symlink";
      # }
      # {
      #   directory = ".local/share/klipper";
      #   method = "symlink";
      # }
      # {
      #   directory = ".local/share/konsole";
      #   method = "symlink";
      # }
      # {
      #   directory = ".local/share/kscreen";
      #   method = "symlink";
      # }
      # {
      #   directory = ".local/share/kwalletd";
      #   method = "symlink";
      # }
      # {
      #   directory = ".local/share/kxmlgui5";
      #   method = "symlink";
      # }
      # {
      #   directory = ".local/share/sddm";
      #   method = "symlink";
      # }
    ];
    files = [
      # GTK Stuff
      ".config/gtkrc"
      ".config/gtkrc-2.0"

      # Pulse Cookie
      ".config/pulse/cookie"

      # XFCE Menu
      ".config/xfce4/desktop/menu.xml"

      # KDE Stuff
      # ".config/Trolltech.conf"
      # ".config/akregatorrc"
      # ".config/baloofilerc"
      # ".config/bluedevilglobalrc"
      # ".config/dolphinrc"
      # ".config/gwenviewrc"
      # ".config/kactivitymanagerd-statsrc"
      # ".config/kactivitymanagerdrc"
      # ".config/kateschemarc"
      # ".config/kcminputrc"
      # ".config/kconf_updaterc"
      # ".config/kded5rc"
      # ".config/kdeglobals"
      # ".config/kgammarc"
      # ".config/kglobalshortcutsrc"
      # ".config/khotkeysrc"
      # ".config/kmixrc"
      # ".config/konsolerc"
      # ".config/kscreenlockerrc"
      # ".config/ksmserverrc"
      # ".config/ktimezonedrc"
      # ".config/kwinrc"
      # ".config/kwinrulesrc"
      # ".config/kxkbrc"
      # ".config/mimeapps.list"
      # ".config/plasma-localerc"
      # ".config/plasmarc"
      # ".config/plasmashellrc"
      # ".config/plasmawindowed-appletsrc"
      # ".config/plasmawindowedrc"
      # ".config/powermanagementprofilesrc"
      # ".config/spectaclerc"
      # ".config/startkderc"
      # ".config/systemsettingsrc"
      # ".config/user-dirs.dirs"
      # ".config/user-dirs.locale"
      # ".local/share/krunnerstaterc"
      # ".local/share/user-places.xbel"
      # ".local/share/user-places.xbel.bak"
      # ".local/share/user-places.xbel.tbcache"

      # Protonmail Bridge
      ".config/protonmail/bridge/cert.pem"
      ".config/protonmail/bridge/key.pem"
      ".config/protonmail/bridge/prefs.json"

      # WakaTime
      ".wakatime.bdb"
      ".wakatime.cfg"

      # DavMail
      ".davmail.properties"

      # Looks and Feels
      ".gtkrc-2.0"
    ];
  };
}

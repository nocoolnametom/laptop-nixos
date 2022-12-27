{ config, lib, pkgs, ... }:

let
  homePersistDir = "/uni/persist/home/tdoggett";
  fullHomePersistDir = "/uni/home/tdoggett";
in {
  home.persistence."${fullHomePersistDir}" = {
    allowOther = false;
    directories = [
      # Make sure these exist!
      "Arduino"
      "DataGripProjects"
      "Desktop"
      "Documents"
      "Downloads"
      "Games"
      "Music"
      "Pictures"
      # "Projects" # This one is handled by the main configuration.nix!  Don't uncomment, and leave this note!
      "Videos"
      # "VirtualBox VMs"
    ];
    files = [ ];
  };
  home.persistence."${homePersistDir}" = {
    allowOther = false;
    directories = [
      #VSCode extension and credential storage
      ".config/Code/User/globalStorage"

      # Android Messages Storage
      ".config/android-messages-desktop"

      # Audacity Audio Editor
      ".config/audacity"

      # Brave Browser
      ".config/BraveSoftware"

      # Google Chrome
      ".config/google-chrome"

      # Firefox
      ".mozilla"

      # Thunderbird
      ".thunderbird"

      # GTK
      ".config/gtk-3.0"
      ".config/gtk-4.0"

      # Obsidian
      ".config/obsidian"

      # Dropbox
      ".dropbox-hm"

      # GnuPG keys
      ".gnupg"
      ".pki"

      # GnuPass store
      ".password-store"

      # Steam
      ".local/share/Steam"
      ".steam"

      # DirEnv
      ".local/share/direnv"

      # SSH
      ".ssh"

      # Wakatime
      ".wakatime"

      # Safe Eyes RSI Prevention
      ".config/safeeyes"

      # Gnome Keyrings (Needed for many secrets storages like Proton!)
      ".local/share/keyrings"

      # XFCE configuration
      ".config/xfce4/mcs_settings"
      ".config/xfce4/panel"
      ".config/xfce4/xffm"
      ".config/xfce4-sessions"
      ".config/xfce4/xfconf/xfce-perchannel-xml"

      # KDE
      # ".config/kde.org"
      # ".config/kdeconnect"
      # ".config/plasma-workspace"
      # ".config/xsettingsd"
      # ".kde"
      # ".local/share/baloo"
      # ".local/share/dolphin"
      # ".local/share/kactivitymanagerd"
      # ".local/share/kate"
      # ".local/share/klipper"
      # ".local/share/konsole"
      # ".local/share/kscreen"
      # ".local/share/kwalletd"
      # ".local/share/kxmlgui5"
      # ".local/share/sddm"
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

      # Barrier
      ".local/share/barrier"

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

      # Dropbox
      ".dropbox"
      "Dropbox"
    ];
  };
}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  nixos-hardware = builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; };
  home-manager = builtins.fetchGit { url = "https://github.com/nix-community/home-manager"; };
in {
  imports = [
    "${nixos-hardware}"
    "${home-manager}/nixos"
    /nix/persist/etc/nixos/hardware-configuration.nix
    ./config/persistence
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Allow NTFS
  boot.supportedFilesystems = [ "ntfs" ];

  # Set up encrypted boot stuff
  boot.initrd.luks.devices.luksroot.device = "/dev/nvme0n1p3";
  boot.initrd.luks.devices.luksroot.preLVM = true;
  boot.initrd.luks.devices.luksroot.allowDiscards = true;
  boot.initrd.luks.devices.luksroot.yubikey.slot = 2;
  boot.initrd.luks.devices.luksroot.yubikey.twoFactor = false;
  boot.initrd.luks.devices.luksroot.yubikey.storage.device = "/dev/nvme0n1p1";
  boot.initrd.luks.devices.luksroot.yubikey.storage.fsType = "vfat";
  boot.initrd.luks.devices.luksroot.yubikey.storage.path = "/crypt-storage/default";
  boot.initrd.luks.yubikeySupport = true;

  networking.hostName = "system76-laptop"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  # networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;
  networking.wireless.networks."Doggett-Wifi6".pskRaw =
    "14b01db5ee261a91968738011d6950ac43fdb428ab97d15bbb2c95edaf2f6372";
  networking.wireless.networks."Doggett-Google".pskRaw =
    "14b01db5ee261a91968738011d6950ac43fdb428ab97d15bbb2c95edaf2f6372";

  networking.wireless.networks."Pixel_6633".psk =
    "hhznzrn8sezhw7h";

  networking.wireless.networks."IHG ONE REWARDS Free WI-FI" = {};
  networking.wireless.networks."MarriottBonvoy_Guest" = {};

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Set up bluetooth
  hardware.bluetooth.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
     # keyMap = "us";
     useXkbConfig = true; # use xkbOptions in tty.
   };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Allow 32-bit OpenGL DRI support (for Steam!)
  hardware.opengl.driSupport32Bit = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.theme = "${(pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "kde-plasma-chili";
    rev = "0.5.5";
    sha256 = "17pkxpk4lfgm14yfwg6rw6zrkdpxilzv90s48s2hsicgl3vmyr3x";
  })}";
  services.xserver.displayManager.sddm.autoNumlock = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.desktopManager.xfce.enable = true;

  # Enable the Gnome Desktop Environment
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Use Gnome stuff outside of gnome (okay to enable this if gnome is enabled, too)
  services.gnome.gnome-keyring.enable = true;
  # services.gnome.gnome-online-accounts.enable = true;
  # services.gnome.evolution-data-server.enable = true;
  programs.dconf.enable = true;

  services.udev.packages = [
    # Ensure gnome-settings-daemon udev rules are enabled
    pkgs.gnome.gnome-settings-daemon

    # Allow Yubikey interactions
    pkgs.yubikey-personalization
  ];

  # Sway
  programs.sway.enable = true;
  programs.light.enable = true;
  services.dbus.packages = [ pkgs.dconf ];
  xdg.portal.enable = true;
  xdg.portal.extraPortals =
    [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];

  # i3wm
  environment.pathsToLink = [ "/libexec" ];
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.extraPackages = with pkgs; [
    dmenu
    i3status
    i3lock
    i3blocks
  ];

  # Greetd
  services.greetd.enable = false;
  services.greetd.settings.default_session.command =
    "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
  services.greetd.settings.default_session.user = "greeter";

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.gutenprintBin
    pkgs.hplip
  ];
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;

  # Enable control of Blinkstick by non-root users
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="20a0", ATTR{idProduct}=="41e5", MODE:="0666"
  '';

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tdoggett = {
    hashedPassword =
      "$6$u7q2XVmRp/ovlPvf$bqy/nMscK3pAmr64s.57D0eECh4JjGTeGX94JVcJZJuSGC63lCr0hbJME61g//4zSlbHJtuI.axubmc0qw9CR0";
    uid = 1000;
    isNormalUser = true;
    group = "tdoggett";
    extraGroups = [
      "wheel" # Control sudo
      "users" # Is a user
      "input" # Controls input devides
      "audio" # Controls audio levels and settings
      "disk" # Mounting stuff
      "networkmanager" # Connecting to the network
      "docker" # Manage docker resources
      "video" # Controls the monitor
    ];
  };
  users.groups.tdoggett.gid = 1000;

  # Home Manager
  home-manager.users.tdoggett =
    import /uni/home/tdoggett/Projects/nocoolnametom/laptop-nixos/home.nix;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Sudo Stuff
  # security.sudo.extraRules = [{
  #   users = [ "tdoggett" ];
  #   commands = [{
  #     command = "ALL";
  #     options = [ "SETENV" "NOPASSWD" ];
  #   }];
  # }];
  users.users.root.initialHashedPassword =
    "$6$8PyCfJmELrGkwHFQ$DVc6qIKQgSpnXepqaeFBv3ZbiE4vJ1x6QdkZpAe8AIZCg5uyXR1UEDj0shM7QtLpH5SEp22mzGh8kH.Z6m6DM1";

  # Only allow users hwo have sudo access to run `nix`
  nix.settings.allowed-users = [ "@wheel" ];

  # U2F PAM module for Yubikey auth
  security.pam.u2f.cue = true;
  security.pam.services.login.u2fAuth = true;
  security.pam.services.sudo.u2fAuth = true;

  # Yubikey for login
  security.pam.yubico.enable = true;
  security.pam.yubico.debug = true; # I don't know why this line is here, just following the instructions
  security.pam.yubico.mode = "challenge-response";
  # security.pam.yubico.control = "required"; # Require multi-factor authentication with yubikeys

  services.pcscd.enable = true;

  # Allow flakes
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
    "electron-21.4.0"
  ];
  # nixpkgs.overlays = [
  #   (final: previous: {
  #     browserpass = (import <nixos-22.11> { }).browserpass;
  #   })
  # ];
  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 30d";
  nix.extraOptions = ''
    min-free = ${toString (100 * 1024 * 1024)}
    max-free = ${toString (1024 * 1024 * 1024)}
  '';

  # Virtualbox Setup
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # users.extraGroups.vboxusers.members = [ "@wheel" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    wl-clipboard
    gnomeExtensions.appindicator
    git
    gnumake
    dig
    yubikey-personalization
    pinentry-curses
    deno
    nodejs
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;
  # programs.gnupg.agent.pinentryFlavor = "qt";
  programs.gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-qt;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable TLP
  services.tlp.enable = false; # Conflicts with system76-power daemon

  # Enable thermal data - Only for Intel CPUs!
  services.thermald.enable = false; # Conflicts with system76-power daemon

  # Enable Powertop
  powerManagement.enable = true;
  powerManagement.powertop.enable = true; # Should work fine with system76-power

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  networking.firewall.allowedTCPPortRanges = [{
    from = 1714;
    to = 1764;
  } # KDE Connect
    ];
  networking.firewall.allowedUDPPorts = [
    51820 # Wireguard
  ];
  networking.firewall.allowedUDPPortRanges = [{
    from = 1714;
    to = 1764;
  } # KDE Connect
    ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}


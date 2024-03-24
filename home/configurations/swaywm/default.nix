{ config, lib, pkgs, ... }:
let
  commonConfig = rec {
    meh = "Mod4+Shift+Alt";
    hyper = "Mod4+Shift+Alt+Control";
    modifier = "Mod4";
    terminal = "alacritty";
    keybindings = {
      "${modifier}+h" = "focus left";
      "${modifier}+j" = "focus down";
      "${modifier}+k" = "focus up";
      "${modifier}+l" = "focus right";

      "${modifier}+Shift+h" = "move left";
      "${modifier}+Shift+j" = "move down";
      "${modifier}+Shift+k" = "move up";
      "${modifier}+Shift+l" = "move right";

      "${modifier}+b" = "splith";
      "${modifier}+0" = "workspace number 10";
      "${modifier}+Shift+0" = "move container to workspace number 10";

      "${hyper}+l" = "move workspace to output right";
      "${hyper}+h" = "move workspace to output left";

      "${modifier}+o" = "mode spotlight";
    };
    modes.spotlight = {
      "Escape" = "mode default";
      "a" = "exec ${pkgs.authy}/bin/authy; mode default";
      "b" = "exec ${pkgs.brave}/bin/brave; mode default";
      "c" = "exec code; mode default";
      "f" = "exec ${pkgs.firefox}/bin/firefox; mode default";
      "g" = "exec ${pkgs.google-chrome}/bin/google-chrome-stable; mode default";
      "m" = "exec android-messages-desktop; mode default";
      "p" = "exec ${pkgs.qtpass}/bin/qtpass; mode default";
      "t" = "exec ${pkgs.thunderbird}/bin/thunderbird; mode default";
      "z" = "exec ${terminal} -e ssh zg02911vmu; mode default";
    };
    modes.resize = {
      "h" = "resize shrink width 10 px";
      "j" = "resize grow height 10 px";
      "k" = "resize shrink height 10 px";
      "l" = "resize grow width 10 px";
      "Left" = "resize shrink width 10 px";
      "Down" = "resize grow height 10 px";
      "Up" = "resize shrink height 10 px";
      "Right" = "resize grow width 10 px";
      "Escape" = "mode default";
      "Return" = "mode default";
    };
    extraConfig = ''
      # Brightness
      bindsym XF86MonBrightnessDown exec ${pkgs.light}/bin/light -U 10
      bindsym XF86MonBrightnessUp exec ${pkgs.light}/bin/light -A 10

      # Volume
      bindsym XF86AudioRaiseVolume exec '${pkgs.pamixer}/bin/pamixer -i 5'
      bindsym XF86AudioLowerVolume exec '${pkgs.pamixer}/bin/pamixer -d 5'
      bindsym XF86AudioMute exec '${pkgs.pamixer}/bin/pamixer -t'

      exec restart-systems-on-login
    '';
  };
in {
  home.packages = [
    pkgs.alacritty
    pkgs.wayland
    pkgs.wl-clipboard
    pkgs.bemenu
    pkgs.mako
    pkgs.swaylock
    pkgs.swayidle
  ];

  ## i3WM and Autorandr
  xsession.windowManager.i3.config = rec {
    inherit (commonConfig) modifier terminal;
    keybindings = lib.mkOptionDefault commonConfig.keybindings;
    modes = commonConfig.modes;
  };
  xsession.windowManager.i3.extraConfig = commonConfig.extraConfig + ''
    # Autorandr
    exec autorandr --change --default twomons
    exec autorandr --change --default onemon
  '';
  programs.autorandr.enable = config.xsession.windowManager.i3.enable;
  programs.autorandr.profiles = let
    laptopscreen = "eDP-1";
    secondmonitor = "DP-1";
    in {
      "twomons" = {
        fingerprint = {
          "${laptopscreen}" =
            "00ffffffffffff000dae021500000000121c0104952213780328659759548e271e505400000001010101010101010101010101010101b43b804a713834405036680058c11000001acd27804a713834405036680058c11000001a00000000000000000000000000000000000000000002000c47ff0b3c6e1314246e000000008f";
          "${secondmonitor}" =
            "00ffffffffffff0010ac05d1565833300e20010380462878ea3c55ad4f46a827115054a54b00a9c0b300d100714fa9408180d1c0010108e80030f2705a80b0588a00b9882100001a000000ff0032483153364e330a2020202020000000fc0044454c4c20533332323151530a000000fd00283c1d8c3c000a2020202020200191020340f15461050403020716010611121513141f105d5e5f6023090707830100006d030c001000383c20006001020367d85dc401788000681a00000101283ce6565e00a0a0a0295030203500b9882100001a023a801871382d40582c4500b9882100001ea8ac00a0f070338030303500b9882100001a00000000000000000017";
        };
        config = {
          "${laptopscreen}" = {
            enable = true;
            position = "3840x0";
            mode = "1920x1080";
            rate = "60.00";
          };
          "${secondmonitor}" = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "3840x2160";
            rate = "30.00";
          };
        };
      };
      "onemon" = {
        fingerprint."${laptopscreen}" =
          "00ffffffffffff000dae021500000000121c0104952213780328659759548e271e505400000001010101010101010101010101010101b43b804a713834405036680058c11000001acd27804a713834405036680058c11000001a00000000000000000000000000000000000000000002000c47ff0b3c6e1314246e000000008f";
        config."${laptopscreen}" = {
          enable = true;
          primary = true;
          mode = "1920x1080";
          rate = "60.00";
        };
      };
    };

  ## SwayWM
  wayland.windowManager.sway.package = null; # Use system sway
  wayland.windowManager.sway.config = let
    laptopscreen = "eDP-1";
    secondmonitor = "DP-1";
  in rec {
    inherit (commonConfig) modifier terminal;
    keybindings = lib.mkOptionDefault commonConfig.keybindings;
    modes = commonConfig.modes;
    output."${secondmonitor}".pos = "0 0";
    output."${laptopscreen}".pos = "3840 0";
    startup = [ ];
  };
  wayland.windowManager.sway.extraConfig = commonConfig.extraConfig;
  wayland.windowManager.sway.extraConfigEarly = ''
    exec eval $(${pkgs.gnome.gnome-keyring}/bin/gnome-keyring-daemon --start
    exec export SSH_AUTH_SOCK
  '';
  wayland.windowManager.sway.swaynag.enable = true;
  wayland.windowManager.sway.systemd.enable = true;
  wayland.windowManager.sway.xwayland = true;
}

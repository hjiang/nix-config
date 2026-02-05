{ pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.firefox.enable = false;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Enable fcitx5 input method
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      qt6Packages.fcitx5-chinese-addons
    ];
  };

  # Enable geoclue2 for location services (used by gammastep)
  services.geoclue2.enable = true;

  # Desktop packages
  environment.systemPackages = with pkgs; [
    blueman
    brightnessctl
    cliphist
    emacs-pgtk
    foot
    gammastep
    grim
    hypridle
    hyprpaper
    hyprpolkitagent
    networkmanagerapplet
    nwg-look
    pavucontrol
    playerctl
    satty
    slack
    slurp
    swaynotificationcenter
    udiskie
    walker
    waybar
    wechat
    wl-clipboard
    xorg.xhost
  ];
}

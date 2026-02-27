{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha-blue";
    package = pkgs.kdePackages.sddm;
  };

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

  # USB storage and automounting
  services.udisks2.enable = true;
  services.gvfs.enable = true;

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

  # Needed for Bamboo Studio, etc.
  services.flatpak.enable = true;

  # KDE Wallet for secret storage (used by Dolphin for SMB credentials)
  # Use 'login' service because SDDM's PAM config uses 'substack login'
  security.pam.services.login.kwallet.enable = true;

  # Desktop packages
  environment.systemPackages = with pkgs; [
    # SDDM theme
    (catppuccin-sddm.override {
      flavor = "mocha";
      accent = "blue";
      font = "Noto Sans";
      fontSize = "12";
      loginBackground = true;
    })

    blueman
    brightnessctl
    clang
    cliphist
    cmake
    codecrafters-cli
    emacs-pgtk
    foot
    gammastep
    grim
    hypridle
    hyprpaper
    hyprpolkitagent
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.gwenview
    kdePackages.kio             # KIO framework with kiod6/kpasswdserver
    kdePackages.kio-extras      # SMB/network protocol support
    kdePackages.okular
    kdePackages.kwallet
    kdePackages.kwalletmanager  # GUI to manage stored credentials
    kdePackages.kwallet-pam     # Auto-unlock wallet on login
    mpv
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

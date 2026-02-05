{ config, pkgs, zen-browser, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "eos";

  networking.proxy.default = "http://192.168.1.10:7890/";
  networking.proxy.noProxy = "127.0.0.1,localhost,192.168.1.0/24";

  # Enable networking
  networking.networkmanager.enable = true;

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

  services.tailscale.enable = true;
  services.tailscale.extraSetFlags = ["--accept-dns=true"];

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    blueman
    brightnessctl
    cliphist
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
    socat
    swaynotificationcenter
    udiskie
    walker
    waybar
    wl-clipboard
    xorg.xhost
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  system.stateVersion = "25.11";
}

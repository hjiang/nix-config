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

  networking.hostName = "hestia";

  networking.proxy.default = "http://192.168.1.10:7890/";
  networking.proxy.noProxy = "127.0.0.1,localhost,192.168.1.0/24";

  # Enable networking
  networking.networkmanager.enable = true;

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  system.stateVersion = "25.11";
}

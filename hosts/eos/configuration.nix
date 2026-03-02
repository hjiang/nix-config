{ config, pkgs, zen-browser, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "eos";

  networking.proxy.default = "http://127.0.0.1:7890";
  networking.proxy.noProxy = "127.0.0.1,localhost,192.168.1.0/24";

  # Enable networking
  networking.networkmanager.enable = true;

  services.mihomo = {
    enable = true;
    configFile = "${config.users.users.hjiang.home}/code/surgio-store/dist/clash-headless.yaml";
  };

  services.tailscale.enable = true;
  services.tailscale.extraSetFlags = ["--accept-dns=true"];

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Disable USB wake sources to prevent spurious wakes from s2idle suspend
  # This machine only supports s2idle, which is sensitive to USB events
  # After this, only the power button will wake the system
  systemd.services.disable-usb-wake = {
    description = "Disable USB wake sources for reliable suspend";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for dev in XHC0 XHC1 XHC3 XHC4; do
        if grep -q "$dev.*enabled" /proc/acpi/wakeup; then
          echo $dev > /proc/acpi/wakeup
        fi
      done
    '';
  };

  system.stateVersion = "25.11";
}

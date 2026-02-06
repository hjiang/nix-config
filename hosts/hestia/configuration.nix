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

  # Enable NVIDIA proprietary drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;

  hardware.nvidia = {
    # Use the latest stable driver (or "beta" for latest)
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Enable modesetting (required for Wayland)
    modesetting.enable = true;

    # Enable power management (critical for suspend/resume)
    powerManagement.enable = true;

    # Experimental: preserve video memory allocations during suspend
    # This is the key to fixing monitor wake issues
    powerManagement.finegrained = false;

    # Keep the NVIDIA card always on (not using hybrid graphics)
    prime.offload.enable = false;

    # Use open-source kernel modules (available for RTX 30 series)
    # Set to false if you experience issues
    open = false;
  };

  networking.hostName = "hestia";

  networking.proxy.default = "http://192.168.1.10:7890/";
  networking.proxy.noProxy = "127.0.0.1,localhost,192.168.1.0/24";

  # Enable networking
  networking.networkmanager.enable = true;

  services.tailscale.enable = true;
  services.tailscale.extraSetFlags = ["--accept-dns=true"];

  # Disable USB and PCIe wake sources to prevent spurious wakes from suspend
  # After this, only the power button will wake the system
  systemd.services.disable-usb-wake = {
    description = "Disable USB and PCIe wake sources for reliable suspend";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # Disable USB controller wakeup
      for dev in XHC0; do
        if grep -q "$dev.*enabled" /proc/acpi/wakeup; then
          echo $dev > /proc/acpi/wakeup
        fi
      done
      # Disable PCIe wakeup sources that can cause spurious wakes
      for dev in GPP0 GP12 GP13 PTXH; do
        if grep -q "$dev.*enabled" /proc/acpi/wakeup; then
          echo $dev > /proc/acpi/wakeup
        fi
      done
    '';
  };

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  system.stateVersion = "25.11";
}

{ config, pkgs, lib, ... }:

{
  imports = [
    ../emq.nix
  ];

  # Hestia-specific Hyprland configuration
  wayland.windowManager.hyprland.settings = {
    # Override monitor scaling for hestia (HiDPI display)
    monitor = lib.mkForce ",highres@highrr,auto,1.333333";
  };
}

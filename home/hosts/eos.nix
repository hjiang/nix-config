{ config, pkgs, lib, ... }:

{
  imports = [
    ../emq.nix
  ];

  # Eos-specific Hyprland configuration
  wayland.windowManager.hyprland.settings = {
    # Override monitor scaling for eos (HiDPI display)
    monitor = lib.mkForce ",highres@highrr,auto,2";
  };
}

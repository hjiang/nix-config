{ config, pkgs, lib, hostName, ... }:

let
  configLib = import ./lib/config.nix { inherit lib hostName; };
in
{
  # Walker configuration managed via xdg.configFile
  # Walker is a Wayland-native application launcher
  # Supports per-host overrides in hosts/config-overrides/<hostname>/walker/
  xdg.configFile."walker/config.toml".source = configLib.sourceConfig "walker/config.toml";
}

{ config, pkgs, lib, ... }:

{
  # Walker configuration managed via xdg.configFile
  # Walker is a Wayland-native application launcher
  xdg.configFile."walker/config.toml".source = ./config-files/walker/config.toml;
}

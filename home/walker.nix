{ config, pkgs, lib, hostName, ... }:

let
  configLib = import ./lib/config.nix { inherit lib hostName; };
in
{
  # Walker configuration managed via xdg.configFile
  # Walker is a Wayland-native application launcher
  # Supports per-host overrides in hosts/config-overrides/<hostname>/walker/
  xdg.configFile."walker/config.toml".source = configLib.sourceConfig "walker/config.toml";

  # The elephant.service unit (Walker's backend daemon) hardcodes a minimal Nix
  # store PATH. Override it so elephant can find `sh` when launching .desktop apps.
  xdg.configFile."systemd/user/elephant.service.d/path.conf".text = ''
    [Service]
    Environment="PATH=/run/current-system/sw/bin:/run/wrappers/bin"
  '';
}

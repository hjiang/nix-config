{ lib, hostName }:

let
  # Select a config file with host-specific override support
  #
  # Checks for host-specific override first, falls back to base config
  #
  # Usage:
  #   selectConfig "waybar/style.css"
  #   → Checks: hosts/config-overrides/<hostname>/waybar/style.css
  #   → Falls back to: config-files/waybar/style.css
  #
  # Example:
  #   style = builtins.readFile (configLib.selectConfig "waybar/style.css");
  selectConfig = configPath:
    let
      baseDir = ../config-files;
      overrideDir = ../hosts/config-overrides;

      basePath = baseDir + "/${configPath}";
      overridePath = overrideDir + "/${hostName}/${configPath}";

      hasOverride = builtins.pathExists overridePath;
    in
      if hasOverride then overridePath else basePath;
in
{
  inherit selectConfig;

  # Read a config file with host-specific override support
  # Convenience wrapper around selectConfig + readFile
  #
  # Usage:
  #   readConfig "waybar/style.css"
  readConfig = configPath:
    builtins.readFile (selectConfig configPath);

  # Get path to config file for use with .source attribute
  # Convenience wrapper around selectConfig
  #
  # Usage:
  #   xdg.configFile."walker/config.toml".source = configLib.sourceConfig "walker/config.toml";
  sourceConfig = selectConfig;
}

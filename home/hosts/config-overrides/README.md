# Per-Host Configuration Overrides

This directory contains host-specific configuration file overrides.

## How It Works

The config helper library (`home/lib/config.nix`) automatically selects the right config file:

1. **Check for override**: `hosts/config-overrides/<hostname>/<path>`
2. **Fall back to base**: `home/config-files/<path>`

This allows you to customize configs per machine while keeping shared defaults.

## Directory Structure

```
config-overrides/
├── hestia/              # Hestia-specific overrides
│   └── waybar/
│       └── style.css    # Custom Waybar styling for Hestia
├── eos/                 # Eos-specific overrides
│   └── (add overrides here)
└── README.md            # This file
```

## Usage Examples

### Override Waybar Style for a Host

```bash
# Copy base config
cp home/config-files/waybar/style.css home/hosts/config-overrides/hestia/waybar/style.css

# Edit the override
$EDITOR home/hosts/config-overrides/hestia/waybar/style.css

# Rebuild - hestia will use the override, eos will use base
sudo nixos-rebuild switch --flake .#hestia
```

### Override Walker Config for a Host

```bash
mkdir -p home/hosts/config-overrides/eos/walker
cp home/config-files/walker/config.toml home/hosts/config-overrides/eos/walker/config.toml

# Customize for eos (e.g., different keybindings, AI model, etc.)
$EDITOR home/hosts/config-overrides/eos/walker/config.toml
```

### Override Hyprland Window Rules

```bash
mkdir -p home/hosts/config-overrides/hestia/hyprland
cp home/config-files/hyprland/extra.conf home/hosts/config-overrides/hestia/hyprland/extra.conf

# Add host-specific window rules
$EDITOR home/hosts/config-overrides/hestia/hyprland/extra.conf
```

## Supported Override Paths

All paths from `home/config-files/` can be overridden:

- `waybar/style.css` - Waybar styling
- `walker/config.toml` - Walker app launcher config
- `hyprland/extra.conf` - Hyprland window rules and submaps
- `scripts/power-menu.sh` - Power menu script

## Current Overrides

- **hestia**: Custom Waybar style (purple tint for visual distinction)
- **eos**: (no overrides yet - uses all base configs)

## Tips

1. **Start from base**: Always copy the base config before modifying
2. **Keep overrides minimal**: Only override what truly differs per host
3. **Document changes**: Add comments explaining why the override exists
4. **Test changes**: Build and test on the target host before committing
5. **Share commonalities**: If multiple hosts need the same change, update the base config instead

## Git Strategy

- Base configs: Commit changes when they benefit all hosts
- Overrides: Commit when they're truly host-specific
- Don't create overrides for trivial differences (use Nix `mkIf` instead)

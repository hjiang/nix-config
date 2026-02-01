# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a **flake-based NixOS system configuration** for a single host named "hestia".

### Configuration Structure

- **`flake.nix`**: Entry point defining the NixOS system configuration
  - Tracks `nixpkgs/nixos-unstable` channel
  - Defines `nixosConfigurations.hestia` as the system output
  - Experimental features enabled: `nix-command` and `flakes`

- **`configuration.nix`**: Main system configuration
  - Imports `hardware-configuration.nix`
  - User configuration for `hjiang` (member of groups: hjiang, networkmanager, wheel, users)
  - Desktop Environment: KDE Plasma 6 with SDDM
  - Proxy settings: `http://192.168.1.10:7890/` (excludes local network)
  - System packages managed through `environment.systemPackages`

- **`hardware-configuration.nix`**: Hardware-specific settings
  - **WARNING**: Auto-generated file - DO NOT manually edit
  - Regenerate with `nixos-generate-config` when hardware changes
  - Contains filesystem mounts, kernel modules, and hardware-specific settings

### Key System Settings

- **Kernel**: Latest kernel (`pkgs.linuxPackages_latest`)
- **Bootloader**: systemd-boot with EFI
- **Timezone**: Asia/Shanghai
- **Locale**: en_US.UTF-8
- **Unfree packages**: Allowed
- **State version**: 25.11

## Common Commands

### Building and Applying Configuration

```bash
# Build and switch to new configuration (requires sudo)
sudo nixos-rebuild switch --flake .#hestia

# Build without switching (test build)
sudo nixos-rebuild build --flake .#hestia

# Test configuration without making it default
sudo nixos-rebuild test --flake .#hestia

# Build and switch, including flake updates
sudo nixos-rebuild switch --flake .#hestia --update-input nixpkgs
```

### Flake Management

```bash
# Update flake.lock to latest nixpkgs-unstable
nix flake update

# Update specific input
nix flake update nixpkgs

# Show flake outputs
nix flake show

# Check flake for issues
nix flake check
```

### Package Management

```bash
# Search for packages
nix search nixpkgs <package-name>

# Add package to configuration.nix in environment.systemPackages
# Then rebuild with: sudo nixos-rebuild switch --flake .#hestia
```

### Testing and Validation

```bash
# Verify Nix expression syntax
nix-instantiate --parse configuration.nix

# Evaluate configuration (dry-run)
nixos-rebuild dry-build --flake .#hestia

# Show what would change
nixos-rebuild dry-activate --flake .#hestia
```

## Development Workflow

1. **Make changes** to `configuration.nix` (or add new module files and import them)
2. **Test syntax**: `nix-instantiate --parse configuration.nix`
3. **Dry-run**: `nixos-rebuild dry-build --flake .#hestia`
4. **Apply changes**: `sudo nixos-rebuild switch --flake .#hestia`
5. **Commit** working configuration to git

### Adding New Modules

To organize configuration better, create module files and import them in `configuration.nix`:

```nix
imports = [
  ./hardware-configuration.nix
  ./modules/networking.nix  # Example new module
];
```

## Important Notes

- **Never edit `hardware-configuration.nix` manually** - it's auto-generated
- The flake uses `nixos-unstable` channel, which receives frequent updates
- All `nixos-rebuild` commands must specify the flake path: `--flake .#hestia`
- The `#hestia` refers to the hostname defined in `flake.nix` outputs
- User-specific packages can be added in `users.users.hjiang.packages` or system-wide in `environment.systemPackages`

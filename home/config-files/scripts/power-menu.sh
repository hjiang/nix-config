#!/usr/bin/env bash
# Power menu for NixOS with systemd
# Adapted from Gentoo config to use systemctl instead of loginctl

options="Lock Screen
Logout
Suspend
Shutdown
Reboot"

# Show menu and get selection
selected=$(printf "%s" "$options" | walker --dmenu)

# Execute action based on selection
case "$selected" in
    "Lock Screen")
        # Lock session - loginctl is correct for this
        loginctl lock-session
        ;;
    "Logout")
        # Exit Hyprland compositor
        hyprctl dispatch exit
        ;;
    "Suspend")
        # Suspend system - use systemctl on NixOS
        systemctl suspend
        ;;
    "Shutdown")
        # Poweroff system - use systemctl on NixOS
        systemctl poweroff
        ;;
    "Reboot")
        # Reboot system - use systemctl on NixOS
        systemctl reboot
        ;;
esac

#!/bin/bash

# Modern Labwc Revert Script
# This script reverts all changes made by setup.sh

# --- Colors ---
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
blue='\033[0;34m'
nc='\033[0m' # No Color

echo -e "${red}╔════════════════════════════════════════════════════════════╗${nc}"
echo -e "${red}║         Modern Labwc - Configuration Revert               ║${nc}"
echo -e "${red}╚════════════════════════════════════════════════════════════╝${nc}"
echo ""

# --- Config Paths ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dest="$HOME/.config"
font_dest="$HOME/.local/share/fonts"
theme_dest="$HOME/.themes"
backup_root="$HOME/.config/BACKUP"

# Configuration folders that were installed
config_folders=(
    "labwc"
    "waybar"
    "rofi"
    "dunst"
    "foot"
    "hypr"
    "swayidle"
)

# Fonts that were installed (from fonts.tar.xz)
font_items=(
    "Iosevka"
    "IosevkaTerm"
    "JetBrainsMono"
)

# Theme that was installed
theme_folder="matugen-labwc"

# --- Warning ---
echo -e "${yellow}WARNING: This will remove all modern-labwc configurations!${nc}"
echo ""
echo -e "The following will be removed:"
echo -e " - Configuration folders: ${yellow}${config_folders[*]}${nc}"
echo -e " - Fonts: ${yellow}${font_items[*]}${nc}"
echo -e " - Theme: ${yellow}$theme_folder${nc}"
echo ""

# Check for backups
if [ -d "$backup_root" ]; then
    echo -e "${green}Backups found in: $backup_root${nc}"
    echo -e "Available backup timestamps:"
    ls -1 "$backup_root" | while read -r backup; do
        echo -e "  - ${blue}$backup${nc}"
    done
    echo ""
else
    echo -e "${red}No backups found in $backup_root${nc}"
    echo -e "${yellow}Old configurations cannot be restored automatically.${nc}"
    echo ""
fi

read -p "Do you want to continue with the revert? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${blue}Revert cancelled.${nc}"
    exit 0
fi

echo ""
echo -e "${blue}[STEP 1/5] Stopping background services...${nc}"
sleep 0.5

# Kill running services
echo -e "${yellow}Stopping swww-daemon, dunst, and waybar...${nc}"
killall -q swww-daemon dunst waybar swayidle 2>/dev/null
sleep 1
echo -e "${green}✓ Services stopped${nc}"

echo ""
echo -e "${blue}[STEP 2/5] Removing configuration folders...${nc}"
sleep 0.5

for folder in "${config_folders[@]}"; do
    folder_path="$dest/$folder"
    if [ -d "$folder_path" ]; then
        echo -e "Removing ${yellow}$folder${nc}..."
        rm -rf "$folder_path"
        echo -e "${green}✓ Removed $folder${nc}"
    else
        echo -e "${blue}⊘ $folder not found (already removed)${nc}"
    fi
    sleep 0.3
done

echo ""
echo -e "${blue}[STEP 3/5] Removing fonts...${nc}"
sleep 0.5

for font in "${font_items[@]}"; do
    font_path="$font_dest/$font"
    if [ -d "$font_path" ] || [ -f "$font_path" ]; then
        echo -e "Removing ${yellow}$font${nc}..."
        rm -rf "$font_path"
        echo -e "${green}✓ Removed $font${nc}"
    else
        echo -e "${blue}⊘ $font not found (already removed)${nc}"
    fi
    sleep 0.3
done

# Update font cache
echo -e "${yellow}Updating font cache...${nc}"
fc-cache -fv > /dev/null 2>&1
echo -e "${green}✓ Font cache updated${nc}"

echo ""
echo -e "${blue}[STEP 4/5] Removing theme...${nc}"
sleep 0.5

theme_path="$theme_dest/$theme_folder"
if [ -d "$theme_path" ]; then
    echo -e "Removing ${yellow}$theme_folder${nc}..."
    rm -rf "$theme_path"
    echo -e "${green}✓ Removed $theme_folder${nc}"
else
    echo -e "${blue}⊘ $theme_folder not found (already removed)${nc}"
fi

echo ""
echo -e "${blue}[STEP 5/5] Restoring backups (if available)...${nc}"
sleep 0.5

if [ -d "$backup_root" ]; then
    # Find the most recent backup
    latest_backup=$(ls -1t "$backup_root" | head -1)
    
    if [ -n "$latest_backup" ]; then
        echo -e "${yellow}Found latest backup: $latest_backup${nc}"
        echo ""
        echo -e "Available backups:"
        ls -1t "$backup_root" | nl
        echo ""
        read -p "Enter the number of the backup to restore (or press Enter for latest): " backup_choice
        
        if [ -z "$backup_choice" ]; then
            selected_backup="$latest_backup"
        else
            selected_backup=$(ls -1t "$backup_root" | sed -n "${backup_choice}p")
        fi
        
        if [ -n "$selected_backup" ] && [ -d "$backup_root/$selected_backup" ]; then
            echo -e "${yellow}Restoring from backup: $selected_backup${nc}"
            sleep 0.5
            
            # Restore each backed up folder
            for item in "$backup_root/$selected_backup"/*; do
                if [ -e "$item" ]; then
                    item_name=$(basename "$item")
                    echo -e "Restoring ${yellow}$item_name${nc}..."
                    cp -r "$item" "$dest/"
                    echo -e "${green}✓ Restored $item_name${nc}"
                    sleep 0.3
                fi
            done
            
            echo -e "${green}✓ Backup restored successfully${nc}"
        else
            echo -e "${red}Invalid backup selection${nc}"
        fi
    else
        echo -e "${yellow}No backups available to restore${nc}"
    fi
else
    echo -e "${yellow}No backup directory found${nc}"
fi

echo ""
echo -e "${green}╔════════════════════════════════════════════════════════════╗${nc}"
echo -e "${green}║              Revert Complete!                              ║${nc}"
echo -e "${green}╚════════════════════════════════════════════════════════════╝${nc}"
echo ""
echo -e "${yellow}Summary:${nc}"
echo -e " ✓ Removed modern-labwc configurations"
echo -e " ✓ Removed installed fonts"
echo -e " ✓ Removed installed themes"
if [ -d "$backup_root" ]; then
    echo -e " ✓ Restored old configurations from backup"
fi
echo ""
echo -e "${blue}Note: You may want to:${nc}"
echo -e " 1. Restart your session for all changes to take effect"
echo -e " 2. Manually remove the backup folder: ${yellow}$backup_root${nc}"
echo -e " 3. Uninstall packages if desired (see below)"
echo ""
echo -e "${yellow}To uninstall packages (optional):${nc}"
echo -e "  Arch Linux: sudo pacman -Rns labwc waybar rofi dunst foot swww hyprlock"
echo -e "  Ubuntu/Debian: sudo apt remove labwc waybar rofi dunst foot"
echo ""

exit 0

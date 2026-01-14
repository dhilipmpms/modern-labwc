# Reverting Modern Labwc Configuration

This guide explains how to revert all changes made by the modern-labwc setup script and restore your old fonts, themes, and wallpaper configuration.

## What Gets Reverted

The revert script will remove:

### Configuration Folders
- `~/.config/labwc`
- `~/.config/waybar`
- `~/.config/rofi`
- `~/.config/dunst`
- `~/.config/foot`
- `~/.config/hypr`
- `~/.config/swayidle`

### Fonts
- Iosevka
- IosevkaTerm
- JetBrainsMono

### Themes
- matugen-labwc (from `~/.themes`)

### Backups
Your old configurations are backed up in `~/.config/BACKUP/` with timestamps. The revert script will offer to restore them.

## How to Revert

### Step 1: Run the Revert Script

```bash
cd ~/Projects/github/modern-labwc
./revert.sh
```

### Step 2: Follow the Prompts

The script will:
1. Show you what will be removed
2. List available backups
3. Ask for confirmation
4. Stop background services (swww-daemon, dunst, waybar, swayidle)
5. Remove modern-labwc configurations
6. Remove installed fonts
7. Remove installed themes
8. Offer to restore your old configuration from backup

### Step 3: Select Backup to Restore

When prompted, you can:
- Press **Enter** to restore the latest backup
- Enter a **number** to select a specific backup
- The script will list all available backups with timestamps

### Step 4: Restart Your Session

After the revert completes, restart your session for all changes to take effect:

```bash
# If in labwc session
labwc --exit

# Or logout and login again
```

## Optional: Uninstall Packages

If you also want to remove the packages installed by modern-labwc:

### Arch Linux
```bash
sudo pacman -Rns labwc waybar rofi dunst foot swww hyprlock swayidle matugen
```

### Ubuntu/Debian
```bash
sudo apt remove labwc waybar rofi dunst foot
# Note: Some packages like swww, hyprlock, matugen were built from source
# You may need to remove them manually if desired
```

## Backup Locations

- **Configurations**: `~/.config/BACKUP/<timestamp>/`
- **Fonts**: Removed from `~/.local/share/fonts/`
- **Themes**: Removed from `~/.themes/`

## What Happens to Backups?

The revert script does **not** delete the backup folder. After reverting, you can:

1. Keep the backups for safety
2. Manually delete them to free up space:
   ```bash
   rm -rf ~/.config/BACKUP
   ```

## Troubleshooting

### No Backups Found

If the script reports "No backups found", it means:
- This is a fresh installation with no previous configurations
- The backup folder was manually deleted
- You'll need to manually configure your old settings

### Services Still Running

If background services are still running after revert:
```bash
killall -9 swww-daemon dunst waybar swayidle
```

### Fonts Not Reverting

If fonts don't change after revert:
```bash
fc-cache -fv
```

## Re-installing Modern Labwc

If you want to install modern-labwc again after reverting:
```bash
./setup.sh
```

Your old configurations will be backed up again with a new timestamp.

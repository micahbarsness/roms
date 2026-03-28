# Retroid ROM Prep Scripts

## Overview
This toolkit helps you prepare your ROM library for use with ES-DE on your Retroid device.

It includes:
- Filename cleanup for better artwork scraping
- Safe compression for PS2 and Dreamcast games
- Protection against breaking multi-file disc formats (.cue/.bin)

---

## Included Scripts

### clean_rom_names.sh
Cleans ROM filenames by:
- Removing region tags like (USA), (Europe)
- Removing version tags like (Rev 1), (v1.1)
- Replacing underscores with spaces
- Skipping risky file types (.cue, .bin, .gdi, etc.)

---

### convert_roms.sh
Converts ROMs into efficient formats:
- PS2 .iso → .chd
- Dreamcast .gdi → .chd

Skips:
- .cue/.bin files (to avoid breaking sets)
- GameCube conversion (handled separately in Dolphin GUI)

---

## Requirements

Install required tools using Homebrew:

    brew install rom-tools

Verify:

    chdman -h

---

## Folder Structure

Recommended:

    ROMs/
      PS2/
      Dreamcast/
      GameCube/
      N64/
      GBA/
      GBC/
      GB/
      SNES/

---

## Usage

### 1. Make scripts executable

    chmod +x clean_rom_names.sh
    chmod +x convert_roms.sh

---

### 2. Clean filenames

Preview changes:

    DRY_RUN=1 ./clean_rom_names.sh /path/to/ROMs

Apply changes:

    DRY_RUN=0 ./clean_rom_names.sh /path/to/ROMs

---

### 3. Convert ROMs

    ./convert_roms.sh /path/to/ROMs

---

## Format Recommendations

System        Format
------        ------
PS2           .chd
Dreamcast     .chd
GameCube      .iso (or convert to .rvz later)
GBA/GBC/SNES  .zip OK
N64           .zip OK

---

## Important Notes

### .cue/.bin files
- Must remain together
- Renaming them incorrectly breaks them
- Scripts intentionally skip them

---

### GameCube Conversion
Convert to RVZ inside Dolphin:
- Open Dolphin
- Right-click game
- Convert → RVZ

---

## Recommended Workflow

1. Unzip ROMs
2. Run rename script (dry run first)
3. Apply rename
4. Run conversion script
5. Test a few games
6. Copy to SD card
7. Launch ES-DE and scrape artwork

---

## Optional Cleanup

After verifying everything works:

    find ./PS2 -type f -iname "*.iso" -delete
    find ./Dreamcast -type f -iname "*.gdi" -delete

---

## Final Result Example

    PS2/
      NFL Street 2.chd
      Simpsons Skateboarding.chd

    GameCube/
      Mario Kart - Double Dash!!.iso

    Dreamcast/
      Under Defeat.chd

---

## Summary

This setup ensures:
- Clean metadata scraping
- Efficient storage
- Stable emulator compatibility
- Safe handling of multi-file ROM sets

#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1"
    exit 1
  }
}

need_cmd find
need_cmd chdman

echo "ROM root: $ROOT"
echo

convert_ps2_iso() {
  find "$ROOT" -type f -iname "*.iso" 2>/dev/null | while IFS= read -r file; do
    case "$file" in
      */PS2/*|*/ps2/*)
        out="${file%.*}.chd"
        [[ -f "$out" ]] && { echo "[SKIP] $out"; continue; }

        echo "[PS2 ISO] $file -> $out"
        chdman createdvd -i "$file" -o "$out"
        ;;
    esac
  done
}

convert_dreamcast_gdi() {
  find "$ROOT" -type f -iname "*.gdi" 2>/dev/null | while IFS= read -r file; do
    case "$file" in
      */Dreamcast/*|*/dreamcast/*|*/dc/*|*/DC/*)
        out="${file%.*}.chd"
        [[ -f "$out" ]] && { echo "[SKIP] $out"; continue; }

        echo "[DC GDI] $file -> $out"
        chdman createcd -i "$file" -o "$out"
        ;;
    esac
  done
}

convert_ps2_iso
echo
convert_dreamcast_gdi
echo
echo "Done."
echo "Skipped all .cue/.bin files intentionally."

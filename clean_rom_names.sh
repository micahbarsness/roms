#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
DRY_RUN="${DRY_RUN:-1}"
VERBOSE="${VERBOSE:-1}"

log() {
  [[ "$VERBOSE" == "1" ]] && echo "$@"
}

clean_base() {
  local name="$1"

  name="${name//_/ }"
  name="$(printf '%s' "$name" | perl -pe 's/\[[^][]*\]//g')"
  name="$(printf '%s' "$name" | perl -pe '
    s/\((?:USA|US|Europe|Japan|World|En,?Ja|En,?Fr,?De,?Es,?It|Beta|Proto(?:type)?|Sample|Demo|Rev(?:ision)?\.?\s*\d+|v\d+(?:\.\d+)?|Disc\s*\d+|Disk\s*\d+|Track\s*\d+)\)//ig;
  ')"
  name="$(printf '%s' "$name" | perl -pe 's/\s{2,}/ /g')"
  name="$(printf '%s' "$name" | perl -pe 's/^[\s.]+//; s/[\s.]+$//;')"

  printf '%s' "$name"
}

should_skip_ext() {
  local ext="$1"
  case "$ext" in
    .cue|.bin|.gdi|.ccd|.sub|.img|.mds|.mdf|.toc|.nrg)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

find "$ROOT" -depth -type f | while IFS= read -r file; do
  dir="$(dirname "$file")"
  filename="$(basename "$file")"

  if [[ "$filename" == *.* ]]; then
    ext=".${filename##*.}"
    base="${filename%.*}"
  else
    ext=""
    base="$filename"
  fi

  lower_ext="$(printf '%s' "$ext" | tr '[:upper:]' '[:lower:]')"

  if should_skip_ext "$lower_ext"; then
    continue
  fi

  newbase="$(clean_base "$base")"
  newfile="$dir/$newbase$ext"

  if [[ "$file" == "$newfile" ]]; then
    continue
  fi

  if [[ -e "$newfile" ]]; then
    log "[SKIP] target exists: $newfile"
    continue
  fi

  if [[ "$DRY_RUN" == "1" ]]; then
    echo "[DRY] $file -> $newfile"
  else
    echo "[RENAME] $file -> $newfile"
    mv -n -- "$file" "$newfile"
  fi
done

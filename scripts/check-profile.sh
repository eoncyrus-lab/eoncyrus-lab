#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
README_PATH="$ROOT_DIR/README.md"
ERRORS=0

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  ERRORS=$((ERRORS + 1))
}

for command in rg xmllint rsvg-convert; do
  if ! command -v "$command" >/dev/null 2>&1; then
    fail "required command is not installed: $command"
  fi
done

if (( ERRORS > 0 )); then
  exit 1
fi

if [[ ! -f "$README_PATH" ]]; then
  fail "README.md is missing"
fi

if [[ ! -f "$ROOT_DIR/assets/avatar.png" ]]; then
  fail "canonical profile asset is missing: ./assets/avatar.png"
fi

if rg -n 'hero-character|card-|flow-(dark|light)|More to come' "$README_PATH" >/dev/null; then
  fail "README.md still references retired image cards or placeholder content"
fi

if rg -n '^\| Layer \| Project \|' "$README_PATH" >/dev/null; then
  fail "README.md still uses the retired research-stack table"
fi

REFERENCES="$(rg -o '\./assets/[A-Za-z0-9._/-]+' "$README_PATH" | sort -u || true)"
while IFS= read -r reference; do
  [[ -z "$reference" ]] && continue
  asset_path="$ROOT_DIR/${reference#./}"
  if [[ ! -f "$asset_path" ]]; then
    fail "missing local asset: $reference"
  fi
done <<< "$REFERENCES"

for reference in \
  './assets/hero-dark.svg' \
  './assets/hero-light.svg' \
  './assets/hero-mobile-dark.svg' \
  './assets/hero-mobile-light.svg' \
  './assets/chibi-focus.png' \
  './assets/chibi-cozy.png' \
  './assets/chibi-rest.png' \
  './assets/mark-dark.svg' \
  './assets/mark-light.svg'; do
  if ! rg -qF "$reference" "$README_PATH"; then
    fail "README.md does not reference required theme asset: $reference"
  fi
done

mobile_dark_line="$(rg -nF '<source media="(max-width: 640px) and (prefers-color-scheme: dark)" srcset="./assets/hero-mobile-dark.svg">' "$README_PATH" | cut -d: -f1 || true)"
mobile_light_line="$(rg -nF '<source media="(max-width: 640px) and (prefers-color-scheme: light)" srcset="./assets/hero-mobile-light.svg">' "$README_PATH" | cut -d: -f1 || true)"
desktop_dark_line="$(rg -nF '<source media="(prefers-color-scheme: dark)" srcset="./assets/hero-dark.svg">' "$README_PATH" | cut -d: -f1 || true)"
desktop_light_line="$(rg -nF '<source media="(prefers-color-scheme: light)" srcset="./assets/hero-light.svg">' "$README_PATH" | cut -d: -f1 || true)"

if [[ -z "$mobile_dark_line" || -z "$mobile_light_line" || -z "$desktop_dark_line" || -z "$desktop_light_line" ]]; then
  fail "README.md is missing an exact responsive hero source"
elif ! (( mobile_dark_line < mobile_light_line && mobile_light_line < desktop_dark_line && desktop_dark_line < desktop_light_line )); then
  fail "responsive hero sources are not ordered mobile-first and theme-first"
fi

for svg in "$ROOT_DIR"/assets/hero-*.svg "$ROOT_DIR"/assets/mark-*.svg; do
  if [[ ! -f "$svg" ]]; then
    fail "expected SVG is missing: $svg"
    continue
  fi
  if ! xmllint --noout "$svg" >/dev/null 2>&1; then
    fail "invalid SVG XML: ${svg#$ROOT_DIR/}"
  fi
  if rg -ni "<script\\b|<foreignObject\\b|\\bon[a-z]+\\s*=|(?:xlink:)?href\\s*=\\s*['\\\"](?:https?:|//|javascript:|data:)|url\\s*\\(\\s*['\\\"]?(?:https?:|//|javascript:|data:)" "$svg" >/dev/null; then
    fail "SVG contains executable or external content: ${svg#$ROOT_DIR/}"
  fi
  if [[ "$svg" == *hero-mobile-* ]]; then
    if ! rg -qF 'viewBox="0 0 640 420"' "$svg"; then
      fail "mobile hero has an unexpected viewBox: ${svg#$ROOT_DIR/}"
    fi
  elif [[ "$svg" == *hero-* ]]; then
    if ! rg -qF 'viewBox="0 0 1280 400"' "$svg"; then
      fail "desktop hero has an unexpected viewBox: ${svg#$ROOT_DIR/}"
    fi
  fi
done

RENDER_DIR="$(mktemp -d)"
trap 'rm -rf "$RENDER_DIR"' EXIT
for svg in "$ROOT_DIR"/assets/hero-*.svg "$ROOT_DIR"/assets/mark-*.svg; do
  [[ -f "$svg" ]] || continue
  output="$RENDER_DIR/$(basename "${svg%.svg}.png")"
  if ! rsvg-convert "$svg" -o "$output" >/dev/null 2>&1; then
    fail "SVG cannot be rendered: ${svg#$ROOT_DIR/}"
  fi
done

REFERENCED_BYTES=0
while IFS= read -r reference; do
  [[ -z "$reference" ]] && continue
  asset_path="$ROOT_DIR/${reference#./}"
  [[ -f "$asset_path" ]] || continue
  bytes="$(wc -c < "$asset_path")"
  REFERENCED_BYTES=$((REFERENCED_BYTES + bytes))
done <<< "$REFERENCES"

if (( REFERENCED_BYTES > 300000 )); then
  fail "referenced profile assets exceed 300 KB: ${REFERENCED_BYTES} bytes"
fi

if [[ "${CHECK_REMOTE:-0}" == "1" ]]; then
  while IFS= read -r url; do
    [[ -z "$url" ]] && continue
    if ! curl --fail --silent --show-error --location --head --max-time 15 "$url" >/dev/null; then
      fail "project link is not reachable: $url"
    fi
  done < <(rg -o 'https://github\.com/eoncyrus-lab/[A-Za-z0-9_.-]+' "$README_PATH" | sort -u)
fi

if (( ERRORS > 0 )); then
  printf '%d profile checks failed.\n' "$ERRORS" >&2
  exit 1
fi

printf 'PASS: profile references, SVGs, rendered assets, and size budget are valid.\n'

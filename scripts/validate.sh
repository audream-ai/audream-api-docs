#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

command -v mint >/dev/null 2>&1 || {
  echo "Mintlify CLI is required. Install it with: npm install -g mint" >&2
  exit 1
}

rm -rf "$ROOT_DIR/.cloudflare-pages"
rm -f "$ROOT_DIR/.cloudflare-pages.zip"

cd "$ROOT_DIR"
mint validate
mint broken-links --files '*.mdx' --files 'guides/*.mdx'

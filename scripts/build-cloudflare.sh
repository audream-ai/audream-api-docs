#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/.cloudflare-pages"
ARCHIVE_PATH="$ROOT_DIR/.cloudflare-pages.zip"

command -v mint >/dev/null 2>&1 || {
  echo "Mintlify CLI is required. Install it with: npm install -g mint" >&2
  exit 1
}

mkdir -p "$BUILD_DIR"
find "$BUILD_DIR" -mindepth 1 -delete
rm -f "$ARCHIVE_PATH"

cd "$ROOT_DIR"
mint export --output "$ARCHIVE_PATH"
unzip -q "$ARCHIVE_PATH" -d "$BUILD_DIR"

install -m 0644 "$ROOT_DIR/openapi.yaml" "$BUILD_DIR/openapi.yaml"
install -m 0644 "$ROOT_DIR/cloudflare/_headers" "$BUILD_DIR/_headers"
install -m 0644 "$ROOT_DIR/cloudflare/_redirects" "$BUILD_DIR/_redirects"
install -m 0644 "$ROOT_DIR/cloudflare/robots.txt" "$BUILD_DIR/robots.txt"
install -m 0644 "$ROOT_DIR/cloudflare/sitemap.xml" "$BUILD_DIR/sitemap.xml"
install -m 0644 "$ROOT_DIR/cloudflare/llms.txt" "$BUILD_DIR/llms.txt"
install -m 0644 "$ROOT_DIR/cloudflare/audream-overrides.css" "$BUILD_DIR/audream-overrides.css"
install -m 0644 "$ROOT_DIR/skills/audream/SKILL.md" "$BUILD_DIR/skill.md"
install -m 0644 "$ROOT_DIR/skill.json.template" "$BUILD_DIR/skill.json"

mkdir -p "$BUILD_DIR/references" "$BUILD_DIR/skills/audream/references"
install -m 0644 "$ROOT_DIR/skills/audream/SKILL.md" "$BUILD_DIR/skills/audream/SKILL.md"
install -m 0644 "$ROOT_DIR/skills/audream/agents/openai.yaml" "$BUILD_DIR/skills/audream/agents-openai.yaml"
for source_path in "$ROOT_DIR"/skills/audream/references/*.md; do
  install -m 0644 "$source_path" "$BUILD_DIR/references/$(basename "$source_path")"
  install -m 0644 "$source_path" "$BUILD_DIR/skills/audream/references/$(basename "$source_path")"
done

node "$ROOT_DIR/scripts/postprocess-cloudflare.mjs" "$BUILD_DIR"

install -m 0644 "$ROOT_DIR/index.mdx" "$BUILD_DIR/index.md"
install -m 0644 "$ROOT_DIR/quickstart.mdx" "$BUILD_DIR/quickstart.md"
install -m 0644 "$ROOT_DIR/authentication.mdx" "$BUILD_DIR/authentication.md"

mkdir -p "$BUILD_DIR/guides"
for source_path in "$ROOT_DIR"/guides/*.mdx; do
  output_name="$(basename "${source_path%.mdx}.md")"
  install -m 0644 "$source_path" "$BUILD_DIR/guides/$output_name"
done

node "$ROOT_DIR/scripts/build-agent-context.mjs" \
  "$ROOT_DIR" \
  "$BUILD_DIR/llms-full.txt"

echo "Static documentation built at $BUILD_DIR"

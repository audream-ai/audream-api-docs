#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_NAME="audream-api-docs"
PRODUCTION_BRANCH="main"

command -v wrangler >/dev/null 2>&1 || {
  echo "Wrangler is required. Install it with: npm install -g wrangler" >&2
  exit 1
}

"$ROOT_DIR/scripts/build-cloudflare.sh"

if ! wrangler pages project list --json | node -e '
  let input = "";
  process.stdin.on("data", (chunk) => { input += chunk; });
  process.stdin.on("end", () => {
    const projects = JSON.parse(input);
    process.exit(projects.some((project) => project.name === "audream-api-docs") ? 0 : 1);
  });
'; then
  wrangler pages project create "$PROJECT_NAME" --production-branch "$PRODUCTION_BRANCH"
fi

commit_hash="$(git -C "$ROOT_DIR" rev-parse HEAD)"
commit_message="$(git -C "$ROOT_DIR" log -1 --pretty=%s)"

wrangler pages deploy "$ROOT_DIR/.cloudflare-pages" \
  --project-name "$PROJECT_NAME" \
  --branch "$PRODUCTION_BRANCH" \
  --commit-hash "$commit_hash" \
  --commit-message "$commit_message" \
  --commit-dirty=false

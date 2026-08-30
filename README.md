# Audream API documentation

Public API documentation for Audream. The source uses Mintlify MDX and is
exported as a static site to Cloudflare Pages.

## Local preview

```bash
npm i -g mint
mint dev
```

Validate changes before publishing:

```bash
./scripts/validate.sh
```

## Production deployment

Authenticate the Mintlify and Cloudflare CLIs once:

```bash
mint login
wrangler login
```

Build and deploy the static export:

```bash
./scripts/deploy-cloudflare.sh
```

The script creates the `audream-api-docs` Pages project when needed and deploys
the current Git commit from the `main` branch. Generated files are written to
`.cloudflare-pages/` and are not committed.

The production site is `https://docs.audream.ai`.

The production API base URL is `https://audream-api.tulingbc.com`.
The Agent Skill is published at `https://docs.audream.ai/skill.md`, and the
remote MCP server is `https://audream-api.tulingbc.com/mcp`.

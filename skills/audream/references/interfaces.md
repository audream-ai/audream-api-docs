# Audream interfaces

## Remote MCP

- Server URL: `https://audream-api.tulingbc.com/mcp`
- Authentication: OAuth 2.1 authorization code flow with PKCE
- Authorization is completed in Audream Web.
- Use MCP for listing and reading Notes, workspace Ask, Note updates, Insights, artifacts, and confirmed deletion.
- MCP intentionally does not transport local audio as base64. Use the CLI for audio upload.

## CLI

Install from the public repository:

```bash
npm install --global github:caiqinghua/audream-cli
```

Set the API key in the process environment:

```bash
export AUDREAM_API_KEY="audream_sk_..."
```

Common commands:

```bash
audream auth status
audream notes list
audream notes get NOTE_ID
audream ask "What decisions were made?" --note-id NOTE_ID
audream transcribe ./meeting.m4a --title "Planning meeting" --wait
audream insights generate NOTE_ID --wait
audream artifacts generate NOTE_ID deep_research --wait
audream notes update NOTE_ID --title "New title"
```

Commands emit JSON to stdout and diagnostics to stderr. Use `--json` only for compatibility; JSON is already the default output.

Destructive CLI commands require an exact confirmation value:

```bash
audream notes delete NOTE_ID --confirm NOTE_ID
audream results delete NOTE_ID --confirm NOTE_ID
```

## REST and OpenAPI

- API base URL: `https://audream-api.tulingbc.com`
- OpenAPI: `https://docs.audream.ai/openapi.yaml`
- Authentication: `Authorization: Bearer $AUDREAM_API_KEY`
- Full agent context: `https://docs.audream.ai/llms-full.txt`

Use stable OpenAPI `operationId` values when generating tools.

---
name: audream
description: Work with Audream recordings, Notes, transcripts, Insights, generated artifacts, and grounded cross-note questions. Use when the user asks to import audio into Audream, inspect or organize Audream Notes, generate or retrieve Audream processing results, or answer from their Audream workspace.
metadata:
  short-description: Work with Audream audio and Notes
---

# Audream

Use Audream as the system of record for the user's recordings and processed Notes.

## Choose an interface

1. Prefer the Audream remote MCP server when Audream MCP tools are available and the task does not require reading a local audio file.
2. Use the Audream CLI for local audio upload, shell automation, or deterministic polling.
3. Use the REST API only when neither interface is available or when integrating Audream into code.

Read [references/interfaces.md](references/interfaces.md) only when setup or exact commands are needed. For multi-step processing, read [references/workflows.md](references/workflows.md).

## Operating rules

- List Notes before selecting one unless the user supplied an exact Note ID.
- Prefer workspace Ask for questions spanning Notes. Preserve returned supporting Note IDs in the answer.
- Treat `202 Accepted`, `queued`, and `processing` as incomplete. Poll the corresponding status operation until success, terminal failure, or a bounded deadline.
- Keep every returned Note ID. It is the durable handle for retries, polling, organization, and citations.
- Ask immediately before uploading a local audio file unless the user explicitly requested that upload in the current instruction.
- Ask for explicit confirmation immediately before permanently deleting a Note or removing generated results. A general cleanup request is not sufficient.
- Never expose an API key, OAuth token, raw transcript, or audio in logs or output unless the user explicitly requests the content.
- Do not claim that processing completed unless Audream returned a terminal success response.

## Result handling

Return concise outcomes with the Note title, Note ID, processing state, and supporting Note IDs when present. Surface server errors without inventing a successful fallback.

For credential boundaries, deletion policy, and privacy rules, read [references/security.md](references/security.md).

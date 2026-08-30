# Audream security and privacy

- Send API keys only to the exact API origin `https://audream-api.tulingbc.com`.
- Store API keys in an environment variable or secret manager, never in prompts, repositories, browser bundles, command history, or diagnostic output.
- Remote MCP access tokens are audience-bound to the Audream MCP resource and must not be forwarded to other services.
- Request the smallest OAuth scopes required by the task.
- Keep raw audio local except during a user-authorized transcription upload. Audream does not provide permanent cloud audio storage.
- Prefer workspace Ask over exporting complete transcripts when the task only needs a grounded answer.
- Confirm permanent Note deletion and generated-result deletion at the moment of execution.
- If a credential is exposed, stop using it and instruct the user to revoke or rotate it.

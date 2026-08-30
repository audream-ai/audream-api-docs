# Audream workflows

## Import audio and complete processing

1. Confirm that the user wants to upload the selected local audio file.
2. Generate or retain one UUID Note ID.
3. Submit transcription with the file, title, language, and speaker-labeling preference.
4. Poll transcription at intervals of at least two seconds.
5. If Insights were not included in the requested automatic flow, generate them from the completed transcription.
6. Poll Insights until complete.
7. Generate optional artifacts only when requested or enabled by the user.
8. Return the Note ID and terminal state.

Retries must reuse the same Note ID. Do not create duplicate Notes after transient network failures.

## Ask across Notes

Use workspace Ask when the question spans multiple Notes or when returning a focused answer is preferable to exposing full transcripts. Supply `note_ids` only when the user selected a scope. Preserve the API's supporting Note IDs in the response.

## Inspect one Note

Retrieve the Note first. Distinguish among:

- transcription not started;
- transcription queued or processing;
- transcription complete but Insights absent;
- fully processed;
- terminal failure.

Do not treat a Note record's existence as evidence that transcription or Insights completed.

## Generate optional artifacts

Supported artifact kinds are `epiphany`, `deep_research`, and `podcast`. Generation may be asynchronous. Poll the same artifact endpoint and do not replace core Insights with artifact output.

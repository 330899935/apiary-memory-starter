# NOT IN GIT — the reverse checklist

This repo is public. Anything committed here is permanent and copyable by anyone. When in doubt, leave it out.

## Never commit

- **Real memory databases.** The only SQLite in this repo is the generated `demo/memory.sqlite`, built from invented seed data. Your actual store stays on your machine.
- **Any credential-shaped string.** API keys, tokens, signing material, recovery codes, client secrets, auth headers captured from a log. The self-check scans for these; do not rely on the scan alone.
- **Private-body text from a vault.** Metadata (that something exists, roughly when) is different from the text itself. This starter needs neither.
- **Client names, customer names, case names, real people's notes.** Even anonymised-by-handoff examples tend to leak.
- **Logs and state files.** `*.log`, runtime JSON, caches, `.env` and its variants.
- **The desktop/mobile applications.** This repo is the MIT-licensed MCP layer only. The apps are closed source.

## Before every push

```bash
./check.sh          # asserts the gate and scans for credential-shaped strings
git status --short  # read every path, do not stage blindly
git diff --cached   # read every line you are about to publish
```

## If something leaked

Removing the file in a new commit does **not** remove it from git history. Rotate the credential first, then rewrite history. Assume anything pushed was already copied.

## The rule in one line

If it describes a real person's real memory, it does not belong in this repository.

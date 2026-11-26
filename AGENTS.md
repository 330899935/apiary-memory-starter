# AGENTS.md — contract for agents using this store

You may **propose**. You may not confirm. The confirm step belongs to the human at the terminal.

This file is the contract. Read it before proposing anything into a real store.

## Propose when

- The fact is stable and likely to be useful again (a decision, a constraint, a project convention, a person's stated preference).
- You can write it as one self-contained sentence that makes sense without the conversation that produced it.
- You are willing to have it rejected. Most proposals should be rejected.

## Do not propose

- Secrets of any kind — tokens, signing material, recovery codes, API keys, auth headers. **Never.** Not even "redacted" examples.
- Private-body text from a person's vault. Metadata is enough.
- Temporary state: current error messages, scratch computations, a task you are mid-way through.
- Anything that merely restates what the user just said in this same session.
- Guesses presented as facts. If it is inferred, say "inferred" in the content.
- A duplicate of an existing confirmed entry. Search first.

## Shape of a good proposal

```
title:   short label, not a sentence
content: one sentence, self-contained, no "he/she/the user" without a name
vault:   which vault it belongs to
tags:    two or three lowercase words
```

Good:
> "The Northstar deploy rotates its signing key on the first Monday of each month; Ben owns the rotation."

Bad:
> "He said to rotate it monthly." — no subject, no date, useless in three weeks.

## After proposing

- Say **"proposed"**, never "remembered" or "saved". The entry is pending. It does not exist for recall yet.
- Tell the human the exact id so they can `approve` or `reject`.
- If they reject, do not re-propose the same thing with different words.

## Recall

`search` only sees confirmed entries. If a search returns nothing, the usual cause is **not approval**, not a broken install. Check `list` for pending entries first.

## Boundary

Nothing about this store is reachable over MCP except propose/recall. `approve`, `reject`, `forget`, `restore` live in the CLI and require a human at the machine. That asymmetry is the product, not an oversight.

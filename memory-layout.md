# Memory layout — structure only

This file describes the *shape* of the store. It contains no real memory and no sample of anyone's private text.

## The two zones

```
agent ──propose──> [ pending area ] ──human approve──> [ confirmed vaults ] ──recall──> agent
                          │
                          └──human reject──> dropped (physically removed; never was memory)
```

An entry's state is one of:

| State | Meaning | Visible to recall |
|---|---|---|
| `pending` | An agent proposed it; a human has not ruled | No |
| `confirmed` | A human approved it | Yes |
| `discarded` | Soft-deleted (`forget`); reversible with `restore` | No |

## The vaults

A confirmed entry lives in a vault. There are eight vaults plus a pending area in the full product; the starter uses one vault (`current`) and one archive vault (`archive`) so the demo stays legible.

Rules that matter regardless of how many vaults an install has:

- **One entry, one vault.** No ambiguous shared ownership.
- **The pending area is not memory.** An unapproved proposal is a suggestion, not a fact.
- **`forget` is reversible, `reject` is not.** A rejected proposal physically leaves the database.
- **Nothing is overwritten in place.** A correction is a new entry plus a `forget` of the old one.

## Fields

| Field | Purpose |
|---|---|
| `id` | Stable identifier; used by `approve`, `show`, `forget`, `restore` |
| `title` | Short label for the human reviewing the queue |
| `content` | One self-contained sentence — the unit recall actually searches |
| `vault` | Which vault the entry belongs to |
| `tags` | Space-separated lowercase words |
| `created` | Unix timestamp of the proposal |
| `confirmed_at` | Unix timestamp of approval; null while pending |

## What is deliberately absent

- No cloud sync. No account. No telemetry. No server component.
- No encryption in the SQLite layer itself — the desktop application adds that.
- No automatic promotion from pending to confirmed. That gap is the point.

# The 90-second path — with failure modes written on it

Three steps. Each one says what "broken" looks like, so a newcomer does not misdiagnose a normal environment quirk as a broken product.

---

## Step 1 — install

```bash
pip install apiary-memory==0.2.5
```

**Success:** `apiary-memory-cli --version` prints `0.2.5`.

**Failure:** `error: externally-managed-environment`
→ This is your OS Python protecting itself, **not** a broken package. Use a venv:
```bash
python3 -m venv .venv && source .venv/bin/activate
pip install apiary-memory==0.2.5
```

**Failure:** `command not found: apiary-memory-cli`
→ The venv is not activated. Run `source .venv/bin/activate` again in the same shell.

---

## Step 2 — look at the database

```bash
apiary-memory-cli --db ./demo/memory.sqlite stats
```

**Success:** `confirmed 14`, `pending 5`, `exists yes`.

**Failure:** `no such table: memories`
→ You pointed at an empty or wrong path. From the repo root run `python3 scripts/build_demo.py`, then retry. This is not an install failure.

**Failure:** `unable to open database file`
→ The `demo/` directory is missing, or you are running from outside the repo and used a relative path. Use an absolute path to `memory.sqlite`.

---

## Step 3 — hit the gate

```bash
apiary-memory-cli --db ./demo/memory.sqlite search lighthouse
apiary-memory-cli --db ./demo/memory.sqlite list
apiary-memory-cli --db ./demo/memory.sqlite approve mem_demo_091_lighthouse
apiary-memory-cli --db ./demo/memory.sqlite search lighthouse
```

**Success:** the first search says `no confirmed memory matched 'lighthouse'`; the second search returns `mem_demo_091_lighthouse`.

**Failure:** the first search already returns the entry
→ You are not on a fresh demo database. Rebuild with `python3 scripts/build_demo.py` (it overwrites `demo/memory.sqlite` from the seed).

**Failure:** `approve` says `nothing to approve`
→ The id was already approved in a previous run. Rebuild the demo database.

**Failure:** `search` still returns nothing after approving
→ Check that you used the same `--db` path on every command. A missing `--db` silently falls back to the default database in your home directory — that is the single most common mistake.

---

## Why step 3 is the whole point

Most memory tools tell you "I'll remember that". This one makes you watch the moment an agent's claim becomes a searchable fact — and the moment before, when it is not.

If you only read the README, you will nod and forget. If you run these four commands, you will never confuse "proposed" with "remembered" again.

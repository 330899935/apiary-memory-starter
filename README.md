# apiary-memory-starter

**Clone this, 30 seconds later you have seen the difference between "AI says it remembered" and "the memory is actually searchable".**

No app. No account. No telemetry. No real personal data in this repo — every entry is invented.

---

| | |
|---|---|
| **What it is** | A local SQLite file that any MCP client can read. An agent can only *propose* a memory; a human must approve it before recall can find it. |
| **Who it's for** | One person, several machines, several AIs — and no desire to hand the memory to a vendor. |
| **Try it now** | [30-second walkthrough (中文演示页)](https://hello-fengchao.com/start.html?src=gh) · `git clone … && pip install apiary-memory && ./check.sh` (30 seconds, fake data) |
| **What it is not** | Not a cloud service. No account, no telemetry. The desktop app is macOS-only; there is no Windows build. |

---

## The one thing this repo teaches

An agent proposes. A person approves. Recall only sees approved entries.

That is the whole design. Reading about it does not land. Hitting it does:

```
$ apiary-memory-cli --db ./demo/memory.sqlite search lighthouse
no confirmed memory matched 'lighthouse'     ← the agent proposed it. You never approved it. It is invisible.

$ apiary-memory-cli --db ./demo/memory.sqlite approve mem_demo_091_lighthouse
approved 1 entry

$ apiary-memory-cli --db ./demo/memory.sqlite search lighthouse
1 result
  mem_demo_091_lighthouse  0.88  current      ← now it exists
```

`./check.sh` runs exactly that sequence and asserts the outcome. It exits 0 only when the gate behaves as advertised.

Screenshot slots (to be filled): [before approve] · [after approve] · [stats].

---

## Run it

```bash
python3 -m venv .venv && source .venv/bin/activate   # or use your existing env
pip install apiary-memory==0.2.5
./check.sh
```

`check.sh` builds `demo/memory.sqlite` from `demo/demo_seed.json` first — the SQLite file is deliberately **not** committed. Nothing here touches your real memory database.

Run `./check.sh --selftest` to prove the assertions can actually fail. If the self-test passes, the checks are not decorative.

---

## Honest limits

- This is the **MCP access layer** (MIT). The macOS and iOS applications are **not** open source. "MIT" applies to this repo only.
- `apiary-memory-cli` is a terminal tool. There is no GUI in this starter.
- The local store is plain SQLite. Encryption is added by the Hive app, not by this package.
- No account means no cross-device sync. You move the file yourself.
- The demo data is invented. It is not a sample of anyone's real memory.

---

## What is in here

| Path | Purpose |
|---|---|
| `demo/demo_seed.json` | 20 invented entries — source of truth for the demo database |
| `scripts/build_demo.py` | Rebuilds `demo/memory.sqlite` from the seed (standard library only) |
| `check.sh` | Builds, runs the three commands, asserts the gate, scans for credential-like strings |
| `AGENTS.md` | The contract an agent follows when proposing into this store |
| `memory-layout.md` | Structure of the eight vaults and the pending area — structure only, no content |
| `NOT-IN-GIT.md` | What must never be committed |
| `docs/90-second-path.md` | The three steps with "what failure looks like" written on each |
| `docs/first-screen.md` | Draft for the upstream README's first screen |

---

## License

MIT. See `LICENSE`. Copyright 2026 Apiary.

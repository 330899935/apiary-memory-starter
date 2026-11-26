#!/usr/bin/env python3
"""Rebuild demo/memory.sqlite from demo/demo_seed.json.

Standard library only. Run from anywhere: paths are resolved relative to this
file, not the caller's cwd. The generated SQLite file is deliberately
gitignored — the JSON seed is the source of truth.
"""

import json
import os
import sqlite3
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
SEED = os.path.join(ROOT, "demo", "demo_seed.json")
DB = os.path.join(ROOT, "demo", "memory.sqlite")

SCHEMA = """
CREATE TABLE IF NOT EXISTS meta (
    key   TEXT PRIMARY KEY,
    value TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS memories (
    id           TEXT PRIMARY KEY,
    state        TEXT NOT NULL,
    title        TEXT NOT NULL DEFAULT '',
    content      TEXT NOT NULL,
    vault        TEXT NOT NULL DEFAULT 'current',
    tags         TEXT NOT NULL DEFAULT '',
    tokens       TEXT NOT NULL DEFAULT '',
    client_id    TEXT NOT NULL DEFAULT '',
    source       TEXT NOT NULL DEFAULT 'mcp',
    created      REAL NOT NULL,
    confirmed_at REAL
);
CREATE INDEX IF NOT EXISTS idx_mem_state ON memories(state);
CREATE INDEX IF NOT EXISTS idx_mem_confirmed ON memories(confirmed_at);
CREATE TABLE IF NOT EXISTS board (
    id       TEXT PRIMARY KEY,
    summary  TEXT NOT NULL,
    to_agent TEXT NOT NULL DEFAULT '',
    kind     TEXT NOT NULL DEFAULT 'data',
    stage    TEXT NOT NULL DEFAULT '',
    task_id  TEXT NOT NULL DEFAULT '',
    refs     TEXT NOT NULL DEFAULT '',
    actor    TEXT NOT NULL DEFAULT '',
    created  REAL NOT NULL,
    expires  REAL
);
CREATE INDEX IF NOT EXISTS idx_board_created ON board(created);
"""


def main():
    with open(SEED, "r", encoding="utf-8") as fh:
        seed = json.load(fh)
    entries = seed["entries"]

    if os.path.exists(DB):
        os.remove(DB)

    conn = sqlite3.connect(DB)
    conn.executescript(SCHEMA)
    conn.execute("INSERT INTO meta(key, value) VALUES('schema_version', '1')")
    for e in entries:
        conn.execute(
            """INSERT INTO memories
               (id, state, title, content, vault, tags, tokens, client_id, source, created, confirmed_at)
               VALUES (?, ?, ?, ?, ?, ?, '', '', 'demo', ?, ?)""",
            (
                e["id"], e["state"], e["title"], e["content"],
                e["vault"], " ".join(e["tags"]) if isinstance(e["tags"], list) else e["tags"],
                e["created"], e.get("confirmed_at"),
            ),
        )
    conn.commit()
    counts = {}
    for row in conn.execute("SELECT state, COUNT(*) FROM memories GROUP BY state"):
        counts[row[0]] = row[1]
    conn.close()

    total = sum(counts.values())
    print("built %s — %d entries (%s)" % (
        os.path.relpath(DB, ROOT), total,
        ", ".join("%s=%d" % (k, v) for k, v in sorted(counts.items()))
    ))
    if total != 20:
        print("expected 20 entries, got %d" % total, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())

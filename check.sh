#!/bin/bash
# Self-check for apiary-memory-starter.
# Builds the fake database, runs the three commands from README, asserts that
# the approve gate actually gates, and scans for credential-shaped strings.
# Exits 0 only if every assertion holds. `./check.sh --selftest` proves the
# assertions can fail (so this script cannot silently become decorative).
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"
DB="./demo/memory.sqlite"
OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT

pass() { printf '  ok   %s\n' "$1"; }
fail() { printf '  FAIL %s\n' "$1" >&2; exit 1; }

expect_has() {
    local desc="$1" pattern="$2" file="$3"
    grep -qE "$pattern" "$file" && pass "$desc" || fail "$desc"
}

# The pattern is spelled with character classes so this file does not match
# its own scan: s[k]-  BEGIN.*PRIV[A]TE  pass[w]ord
SCAN_RE='s[k]-|BEGIN.*PRIV[A]TE|pass[w]ord'

scan_credentials() {
    local hits
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        hits="$(git grep -iIE "$SCAN_RE" -- . 2>/dev/null || true)"
    else
        hits="$(grep -riIE "$SCAN_RE" --exclude-dir=.git . 2>/dev/null || true)"
    fi
    if [ -n "$hits" ]; then
        printf '%s\n' "$hits" >&2
        fail "credential scan found matches"
    fi
    pass "credential scan clean"
}

if [ "${1:-}" = "--selftest" ]; then
    echo "self-test: proving the assertions can fail"
    printf '%s\n' "this line does not contain the marker" > "$OUT/negative.txt"
    # Run in a subshell: fail() calls exit, which would otherwise kill this
    # script before the else branch can report the result.
    if ( expect_has "negative control" "THE_MARKER_SHOULD_NOT_EXIST" "$OUT/negative.txt" ) >/dev/null 2>&1; then
        fail "assertion did not fire on a negative control — checks would be decorative"
    fi
    pass "assertion fires when expected text is absent"

    # Build the planted fake at runtime so this script never contains the
    # literal string its own scan looks for.
    FAKE="$(printf 's%s-%s' k abcdefghijklmnop)"
    printf 'fake: %s\n' "$FAKE" > "$OUT/cred2.txt"
    if grep -qiE "$SCAN_RE" "$OUT/cred2.txt"; then
        pass "credential pattern fires on a planted fake"
    else
        fail "credential pattern did not fire on a planted fake"
    fi
    echo "self-test passed"
    exit 0
fi

if ! command -v apiary-memory-cli >/dev/null 2>&1; then
    echo "apiary-memory-cli not found. Run:" >&2
    echo "  python3 -m venv .venv && source .venv/bin/activate" >&2
    echo "  pip install apiary-memory==0.2.5" >&2
    exit 1
fi

echo "1/6 rebuild demo database"
python3 scripts/build_demo.py

echo "2/6 stats"
apiary-memory-cli --db "$DB" stats | tee "$OUT/stats.txt"
expect_has "stats sees 14 confirmed" "confirmed 14" "$OUT/stats.txt"
expect_has "stats sees 5 pending" "pending   5" "$OUT/stats.txt"

echo "3/6 search BEFORE approve — must find nothing"
apiary-memory-cli --db "$DB" search lighthouse | tee "$OUT/before.txt"
expect_has "pending entry is invisible to recall" "no confirmed memory matched" "$OUT/before.txt"

echo "4/6 approve the pending entry"
apiary-memory-cli --db "$DB" approve mem_demo_091_lighthouse | tee "$OUT/approve.txt"
expect_has "approve reports one entry" "approved 1 entry" "$OUT/approve.txt"

echo "5/6 search AFTER approve — must find it"
apiary-memory-cli --db "$DB" search lighthouse | tee "$OUT/after.txt"
expect_has "approved entry is searchable" "mem_demo_091_lighthouse" "$OUT/after.txt"

echo "6/6 credential scan"
scan_credentials

echo ""
echo "PASS — the approve gate behaves as advertised."

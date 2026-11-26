# Draft — upstream README first screen

For the upstream repo `330899935/apiary-memory`. Not applied. Replace the current opening (which answers "the problem it solves" in prose) with four questions and four answers.

```text
What it is       A local SQLite file your MCP clients can read. An agent can only propose; you approve before recall can find it.
Who it's for     One person, several machines, several AIs — and no desire to hand the memory to a vendor.
Try it now       git clone … && pip install apiary-memory && ./check.sh     (30 seconds, invented data)
What it is not   Not a cloud service. No account, no telemetry. Desktop app is macOS-only; no Windows build.
```

## Rules for this screen

- No superlatives. No "revolutionary", no "ultimate", no "ten-year bet".
- Keep the existing **Honest limits** section in the README untouched — it is the most valuable part of the current file.
- Do not say "open source" as a blanket claim. The MCP layer is MIT; the applications are not. Say exactly that.
- The `git clone …` line must point to the starter repo, not to the main repo, or the 30-second claim is false.
- Brand terms in GitHub topics (`claude`, `cursor`) are deliberately different from the App Store metadata. Do not "harmonise" them.

## UTM

The site has no telemetry, so UTM is the only attribution available. The `/start` page links carry `?src=gh|hn|x`. Record the baseline before launching — GitHub traffic data is retained for 14 days only.

## Status

Draft only. Apply after the version-number question is settled (1.6.0 is live, 1.6.1 is in progress) so the README is not edited twice.

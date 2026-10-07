---
name: dependabot-prs
description: Review, update, verify, and optionally merge Dependabot PRs sequentially across Elixir, npm/pnpm, Python/uv, and GitHub Actions. Use when asked to process Dependabot PRs, with optional ecosystem or report-only scope.
---

You are processing the open **Dependabot PRs** in this repository — every ecosystem, not just one. Work through them one at a time, applying the same diligence a careful engineer would: understand what the bump changes, judge whether it's safe for *us*, prove it with that project's checks, and only then approve and merge. When anything is ambiguous or risky, stop and leave it for a human — never merge on a hunch.

## Additional instructions for this run

Use the user's request as operator guidance. It can narrow scope or change the run, for example "npm only", "elixir only", "only patch bumps", "just report, don't merge", or "do the ash group first". Follow explicit user instructions over defaults.

Apply mutations only within the user's authorized scope. A request to inspect or report does not authorize publishing reviews, pushing branches, closing PRs, or merging. When asked to process and merge safe Dependabot PRs, carry that authorization through the workflow without asking again.

## Scope — which PRs

**All** open Dependabot-authored PRs. List them, then classify each by ecosystem from its **changed files, not its title** (title prefixes like `chore(deps)`, `deps-ngen`, `deps-pulumi` vary and don't map cleanly to ecosystems):

```bash
for n in $(gh pr list --author "app/dependabot" --state open --json number --jq '.[].number'); do
  files=$(gh pr view "$n" --json files --jq '[.files[].path] | join(" ")')
  echo "#$n  $files"
done
```

Classify by the lock/manifest in the diff:

| Ecosystem | Signal in the diff | Project dir |
| --- | --- | --- |
| **Elixir/Hex** | `mix.lock` (usually `mix.exs`) | dir holding that `mix.lock` |
| **npm/pnpm** | `pnpm-lock.yaml` / `package.json` | dir holding that lock (a workspace can have several; see below) |
| **Python/uv** | `uv.lock` / `pyproject.toml` | dir holding that `uv.lock` |
| **GitHub Actions** | files under `.github/workflows/` or `.github/actions/`, no lock | n/a |

**Derive the project dir from the lock path** and run all tooling from there. A pnpm monorepo often has several independent installs (root workspace + isolated projects each with their own lock) — respect each project's own lock/workspace and install flags; a project that isn't part of the root workspace (its own `pnpm-workspace.yaml`, or none at all) installs standalone, sometimes needing `--ignore-workspace`. If unsure of the topology, check `.github/dependabot.yml` (its `directory:` entries map the projects) and any per-dir `pnpm-workspace.yaml`.

Process PRs **sequentially, oldest first** (lowest number). Each merge moves the base, so the next PR must be re-based against the new base — never batch them. PRs in different ecosystems/projects rarely conflict, but re-base anyway; the re-verify after re-base is the point.

## Per-PR protocol

For each in-scope PR:

### 1. Check out, rebase, and regenerate the lock against the base — minimally

`gh pr checkout <n>`, read the base (`gh pr view <n> --json baseRefName` — usually `main`, don't assume), then `git fetch origin "$base"` and `git rebase "origin/$base"`. If the rebase conflicts beyond the lock/manifest, stop and flag it.

**Do NOT trust the branch's lock.** Dependabot branches are cut from an *older* base, so their lock can carry stale transitives, and a plain rebase *replays* that stale lock instead of re-resolving — it can silently reintroduce a downgraded/**vulnerable** transitive the base already fixed. Reset the lock to the base and re-bump **only the target**, per ecosystem:

- **Elixir/Hex:**
  ```bash
  git checkout "origin/$base" -- <dir>/mix.lock
  (cd <dir> && mix deps.unlock <pkg> && mix deps.get)   # for a group, unlock each member
  ```
  Use `mix deps.unlock <pkg> && mix deps.get`, **never `mix deps.update <pkg>`** — `deps.update` is greedy: it re-resolves the target's whole subtree to latest, dragging in unrelated transitive bumps, and can *force* another dep down to a vulnerable release to satisfy the new transitive (a **false** security flag). `deps.unlock` + `deps.get` bumps only the target against the base's resolved tree.
- **npm/pnpm:** the branch already bumped the manifest; reset just the lock and re-resolve minimally:
  ```bash
  git checkout "origin/$base" -- <dir>/pnpm-lock.yaml
  (cd <dir> && pnpm install --lockfile-only)            # add --ignore-workspace for a standalone project that wrongly climbs to the root workspace
  ```
- **Python/uv:**
  ```bash
  git checkout "origin/$base" -- <dir>/uv.lock
  (cd <dir> && uv lock --upgrade-package <name>)         # targeted; does not re-resolve everything
  ```
- **GitHub Actions:** no lock — nothing to regenerate. The bump is an `uses: …@<ref>` change; just make sure the rebase is clean.

**Verify the regenerated diff touches the target dep(s) only** (plus their own platform sub-packages, e.g. `@biomejs/cli-*`). Unexpected churn (finch/req/plug, a swept transitive, an unrelated catalog entry) is either a greedy-resolve artifact (wrong command) or a *genuine* forced change — investigate. If the target genuinely can't bump without dragging in a vulnerable/incompatible transitive, *that* is a real flag (skip it). In a pnpm workspace, watch for **catalog-vs-explicit drift**: if a dep is pinned both in the catalog (`pnpm-workspace.yaml`) and explicitly in a package, `--frozen-lockfile` fails until both sides move together — align the catalog rather than only the explicit pin.

Always re-base + re-regenerate **before** merging — a stale branch can pass its own CI yet break (or regress security) against the current base.

### 2. Read the changelog — required, never skip

Identify the old → new version. Read the actual release notes for *every* version in the range (Hex docs / GitHub Releases / `CHANGELOG.md` / npm or PyPI page — `gh release view`, browse the repo). Summarize new features, bug fixes, deprecations, and especially **breaking changes**. **Always check whether the newest available version already fixes the issue** (a security bump sometimes lands a few patches behind latest) and whether the range spans a major. Do not evaluate a bump you haven't read the changelog for.

### 3. Evaluate impact on us — and whether we even need the dep

Cross-reference the changes against how we actually use the package: `rg` for our call sites and check whether any changed/removed/deprecated API is one we touch. For a bug-fix or additive minor on a lightly-used dep, impact is usually nil; for anything touching APIs we call, reason concretely.

**Also ask: do we still use this dep at all, or can it be removed?** If the bumped dep is unused (no real import/call sites — verify with `git grep`, not disk), the right move is often to close the PR and remove the dependency instead of bumping it. For a **security** bump, prefer moving the *parent* that pins the vulnerable transitive (trace the whole chain, check the parent's latest) over adding a lockfile override; reach for an override only when the pinning parent is already latest.

### 4. Review the actual changed source — and screen it for security

Never trust the changelog alone; a dependency bump is a supply-chain entry point. Diff the source between the old and new versions (compare tags on the package's repo, or read the vendored source: Elixir `<dir>/deps/<pkg>`, npm `<dir>/node_modules/<pkg>`, Python the installed package after `uv sync`) and skim Dependabot's commit list. For **GitHub Actions**, read the action's release diff and — for a SHA-pinned bump — confirm the SHA matches the tag. Look for:
- **behavior changes the changelog glossed over**, and whether the diff does *more* than the bump claims;
- **security red flags**: new/altered network or outbound calls, shelling out (`System.cmd`, `child_process`, `subprocess`, `os.system`), code evaluation (`eval`, `Code.eval_*`, `binary_to_term`/`pickle` on untrusted data), newly reading env vars / secrets / files it didn't touch before, obfuscated or minified blobs, or new install-time / postinstall / compile hooks;
- **supply-chain smells**: a maintainer or ownership change, a suspiciously large diff for a "patch", a brand-new transitive, or a package name that looks like a typosquat.

Note any advisory or `retired`/yanked status (`mix hex.audit`, `pnpm audit`, `pip-audit`, GitHub advisories). If you can't obtain the source diff (e.g. transitive-only), say so and lean toward flagging rather than merging blind.

### 5. Run the project's verification gates

From the project dir, run the checks that ecosystem gates on — at minimum a clean build/typecheck and the tests, plus lint/format if the repo enforces them. When unsure of the canonical set, mirror the repo's CI workflow for that project and any git hooks (`lefthook.yml`, `.git/hooks`).

- **Elixir/Hex:** `mix deps.get` · `mix compile --warnings-as-errors` · `mix test` · (`mix credo` / `mix format --check-formatted` / `mix dialyzer` if used).
- **npm/pnpm:** `pnpm install --frozen-lockfile` (validates the regenerated lock) · typecheck (`pnpm typecheck` / `tsc --noEmit`) · lint (`biome check` / eslint) · tests (`pnpm test` / vitest) — scoped to the affected project/package.
- **Python/uv:** `uv sync` · tests (`uv run pytest`) · lint/type (`uv run ruff check` / `mypy` if used).
- **GitHub Actions:** `actionlint` (if available) + a YAML parse; there's no test suite, so correctness is "the workflow still parses and the action's inputs/outputs didn't change incompatibly across the range."

Tests must pass and the build must be clean/warning-free.

### 6. Decide

- **Safe → approve + merge.** Patch/minor, changelog shows no breaking change affecting us, diff is benign, all gates green:
  ```bash
  git push --force-with-lease            # publish the rebased/regenerated branch
  gh pr review <n> --approve --body "<one-line why it's safe + version range reviewed>"
  gh pr merge <n> --squash               # auto-merge is often disabled repo-wide; if so, wait for required checks green then merge
  ```
  If a force-push resets CI, wait for the required checks to go green before merging (don't merge on a stale green).
- **Risky → do NOT merge.** Comment with the specific concern and move on. Treat as risky and hand to a human when any hold:
  - **Major version bump** — always human-reviewed, never auto-merged.
  - Changelog lists a breaking change touching an API we use.
  - Tests fail, build warns, or behavior is unclear.
  - The diff does more than the changelog claims, or the rebase wasn't clean.
  - **Any security/supply-chain red flag** from step 4 — flag it specifically even if tests pass.

## Hard rules

- **Never merge without reading the changelog, reviewing the changed source, and getting that project's tests/build green.** All three are mandatory.
- **Treat every bump as a supply-chain risk** — flag anything suspicious (unexpected network/exec/eval, secret/file access, obfuscation, install hooks, retired/advisory version, ownership or typosquat smell) with the specific finding, even if tests pass.
- **Never auto-merge a major-version bump** — summarize and leave it.
- **Always rebase + re-regenerate the lock on the PR's base before merging**, and re-verify after (a clean pre-rebase run doesn't count).
- **One at a time**, re-basing each against the updated base after the previous merge.
- Don't `--delete-branch` Dependabot branches manually (Dependabot/GitHub clean them up).
- If you're unsure whether something is safe, it isn't — flag it.

## Report

End with a concise per-PR summary grouped by ecosystem: merged ✅ (version range + one-line rationale), skipped ⏭️ (specific reason + what a human should check), or closed 🗑️ (e.g. dep unused/removed, superseded). List skipped PRs last so they're easy to action.

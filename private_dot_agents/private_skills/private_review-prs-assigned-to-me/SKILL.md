---
name: review-prs-assigned-to-me
description: Review open pull requests that request the user as a reviewer, or a specific requested PR. Check correctness, caller consistency, and existing review comments, then present findings and proposed reviews before publishing to GitHub.
---

You are reviewing the pull requests that **request me as a reviewer**. Give each a real code review — correctness first — the way a careful engineer would. **Present your findings to me before posting anything to GitHub**: no approvals, no comments, no requested-changes until I say so.

## Additional instructions for this run

Use the user's request as additional instructions for this run.

If the request names a specific PR, review only that one. If it says "just report", stop after presenting findings. If it pre-authorizes posting ("post once I confirm the plan"), still show me the findings + the exact reviews you'd post first. Without a narrower scope, review every PR in the current repository that requests me as reviewer.

## Scope — which PRs

**Literal review requests only.** PRs where `georgeguimaraes` is a *requested reviewer* (or, if I say so, assignee). Never sweep the org or review PRs I wasn't invited to.

```bash
gh pr list --search "review-requested:@me state:open" \
  --json number,title,author,updatedAt,additions,deletions,changedFiles \
  --jq '.[] | "#\(.number) \(.title) — by \(.author.login) · +\(.additions)/-\(.deletions) · \(.changedFiles) files"'
```

If a PR is part of a stack (its base is another open PR, not `main`), note that and review it against its own base's diff — understanding the stack helps, but each PR's own changes are the scope.

## Per-PR review protocol

For each PR:

1. **Get the context and the diff.** `gh pr view <n> --json title,body,author,baseRefName,headRefName,state,additions,deletions,changedFiles,labels` for context, then `gh pr diff <n>` for the unified diff. When you need surrounding code, read the files (in this checkout if it's on the PR's branch, otherwise fetch via `gh`).

2. **Cross-check the description against the diff.** If the PR says "no behavior change" / "public contract unchanged" but the diff changes a default, a return shape, an error path, or an `if:`/gating condition — that mismatch is a top-tier finding (it's the class of bug where the author's mental model and the code disagree). Deploy/CI/migration/auth PRs deserve extra scrutiny here.

3. **Review for what actually matters.** Read the diff carefully and reason about:
   - **Correctness** — logic bugs, wrong conditionals, off-by-one, unhandled nil/empty/error paths, ordering/gating mistakes (e.g. GHA `needs`/`if: always()`/`!cancelled()`), `set -u`/unbound-var traps in shell, quadratic patterns (concat in a loop).
   - **Caller/consumer consistency** — if a public function's default, contract, or return shape changed, grep every caller and confirm each picks up the new behavior (the classic "fixed one caller, forgot the other").
   - **Missed edge cases**, real performance gaps, security implications, and **misleading docs/comments**.
   - **Test coverage** — do the new branches/business rules have a test that exercises a real branch (not one asserting the mock)?
   Verify claims against the code; don't infer from the description. For anything you assert is a bug, have a concrete failure scenario (inputs → wrong result).

4. **Dedupe against existing review.** Scan the PR's existing comments and reviews (Greptile, other humans, bots) and **skip anything already flagged** — don't repeat a point someone already made.
   ```bash
   gh pr view <n> --json reviews --jq '.reviews[] | "["+.author.login+" · "+.state+"] "+(.body[0:200])'
   gh api repos/{owner}/{repo}/pulls/<n>/comments --jq '.[] | "["+.user.login+" @ "+.path+":"+((.line//.original_line)|tostring)+"] "+(.body[0:200])'
   ```

## Present findings — before posting

Report per PR, most-severe first:
- A one-line **what it does**.
- Findings that clear the bar below, each with file:line and a concrete failure scenario. Call out **praise** for things genuinely worth it, not only problems.
- A recommended verdict: **approve** / **approve with a non-blocking note** / **request changes** (with the blocking reason).

**Bar for raising something:** only things that would change my mind about merging — correctness bugs, real perf gaps, missed edge cases, misleading docs, blocking design issues. Skip nitpicks, style/formatting preferences, no-op micro-optimizations, and bikeshedding. If it wouldn't change my merge decision, don't raise it.

If posting has not already been explicitly authorized for these findings, **stop and ask what to post** — which PRs to approve, which comments to leave, whether to request changes. Do not publish reviews or comments until I answer. Read-only GitHub queries are allowed throughout the review.

## Posting (only after I confirm)

When I tell you what to post, use my review-comment conventions:
- Format: `**<label> [decoration]:** <one-sentence observation>` then a short paragraph with impact + a concrete fix. Labels: `issue`, `suggestion`, `nitpick`, `thought`, `question`, `praise`, `todo`, `note`, `chore`. Decorations: `(blocking)`, `(non-blocking)`, `(if-minor)`.
- Collaborative, generous tone; light hedging is good ("I think", "took me a sec to spot", "happy to pair"). Reference exact file:line. One paragraph per comment. Match my voice: casual, direct, contractions, no em dashes, no LLM fluff.
- Attach non-blocking observations to an **approve** when I've said to approve-with-a-note; use `gh pr review <n> --approve/--request-changes/--comment --body …` and inline comments via the API where a specific line anchor is clearer.

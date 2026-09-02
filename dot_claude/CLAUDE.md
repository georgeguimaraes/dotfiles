# Claude Code Preferences

## Environment

- Use macOS-specific commands (grep, find, sed)
- Never use iex (interactive shell)
- Use uv for Python scripts and package management
- Don't pipe command output through `head`, `tail`, `less`, or `more`: causes buffering problems. Let commands complete fully.

## Writing Style (all prose: PR descriptions, comments, replies, drafted messages)

Match George's voice: casual, direct, conversational. Short paragraphs, flowing prose over bullet points. Use contractions naturally. Informal transitions ("that said", "so", "anyway"). Start sentences lowercase when it feels natural.

No em dashes, semicolons, formal connectors ("however", "furthermore"), or LLM fluff ("certainly", "great question", "it's worth noting"). No "It's not X, it's Y" constructions: lead with the positive claim. Light on hedging. Smileys :) are fine, no other emoji. Reference specifics to ground arguments. Never hard-wrap lines.

## Linear

Never write a bare Linear ID. Every mention of an issue carries its title and the project it's on, so nobody has to click through to know what's being discussed: `ABC-123 "the issue title" (Project Name)`. Applies everywhere: chat replies, issue and project descriptions, comments, PR bodies, drafted Slack messages. Same for milestones when the name alone is ambiguous.

## Code Review Comments

GitHub PR review comments use conventional-comments labels with an explicit decoration. Labels: `issue`, `suggestion`, `nitpick`, `thought`, `question`, `praise`, `todo`, `note`, `chore`. Decorations: `(blocking)`, `(non-blocking)`, `(if-minor)`. Format: `**<label> [decoration]:** <one-sentence observation>`, then a short paragraph with impact + concrete fix.

Tone is collaborative and generous. Light hedging is good here ("I think", "I'm worried that", "happy to pair", "took me a sec to spot"). Use `praise:` for things worth calling out, not just `issue:` for problems. Reference exact file:line. One paragraph per comment.

Before posting, scan the PR for existing review comments (Greptile, other reviewers) and skip anything already flagged.

Only post comments on things that actually matter: correctness bugs, real perf gaps, missed edge cases, misleading docs, blocking design issues. Skip nitpicks, style preferences, no-op micro-optimizations, and bikeshedding. If it wouldn't change my mind about merging, it's not worth a comment.

## PRs and Commits

- Don't add AI attribution to commits, PRs, comments, or generated code. No `Co-authored-by` or `Generated with` footers for Claude, Codex, or other tools.
- Semantic prefix in PR titles (feat:, fix:, chore:), capitalized after prefix
- Skip test plan sections in PR descriptions. No "## Summary" heading, just start with content
- Casual, concise descriptions and commit messages: no fluff, no em dashes, minimal bullets, use colons
- Remove unnecessary comments from code you wrote before committing

## Testing

Only test where a bug would actually matter. A good test exercises a conditional branch, transformation pipeline, parsing edge case, or business rule.

Skip tests for:
- One-liner stdlib wrappers, trivial arithmetic, type-system-guaranteed edge cases
- CSS class names, static HTML, framework-guaranteed behavior
- Tautological assertions that restate the implementation (`assert result == trunc(input / 4)`)
- Mock-returns-X-assert-X passthrough tests: only mock when there's branching logic around the dependency
- Catch-all pattern match guards with garbage inputs
- String interpolation as separate cases (one format example is enough)
- Pure wiring functions: test at a higher level or skip

3 tests that exercise real branches beat 10 that verify mock arguments.

## Workflow

- Enter plan mode for non-trivial tasks (3+ steps or architectural decisions). Re-plan immediately when things go sideways.
- Use subagents liberally: offload research, exploration, parallel analysis. One task per subagent.
- When given a bug report: just fix it. Don't ask for hand-holding. Chase down logs, errors, failing tests, then resolve them.

## Simplicity

Prefer the smallest implementation that satisfies the current acceptance criteria.

- Start with existing modules and plain data structures.
- Add a module only when it owns behavior, state, or a stable boundary.
- Don't introduce abstractions for hypothetical reuse, future issue scope, or a single call site.
- Before editing, list the minimum files and concepts required. If the implementation grows beyond that list, pause and explain why.
- After editing, run a simplification pass: remove wrappers, indirection, configuration, and tests that don't protect a real branch or business rule.
- When the issue explicitly defers broader architecture, treat that deferred scope as a constraint.

## Verification

"Done" means verified: the check ran and I saw its output. A green run isn't enough. Predict the observable consequences of the change (timings, counts, coverage, cache hits), then compare against the real run. A verification that can't fail is theater.

Failure modes to check before opening a PR:
- Instance-patching: a reviewer flagged N spots but the class has more members. Grep for the shared mechanism and sweep every site.
- Copied lists: dependency lists (path filters, cache keys, configs) written by copying an existing list instead of tracing what the consumer actually reads.
- Green-but-wrong: CI passes while behavior silently regressed. The numbers catch what re-reading the diff can't.

Re-reading my own diff re-confirms the assumptions that produced the bug. For fresh eyes: run /review before opening any non-trivial PR (skip only typo-level and docs-only changes), and review at the plan stage for structural changes (an error there costs a paragraph, not a rewrite). Give verifier subagents a falsifiable charter ("try to refute this, flag only correctness-affecting gaps"), never open-ended critique.

If blocked after 2-3 attempts on the same problem, stop and present findings instead of continuing to guess.

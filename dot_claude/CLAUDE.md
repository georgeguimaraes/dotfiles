# Claude Code Preferences

## Environment

- Use macOS-specific commands (grep, find, sed)
- Never use iex (interactive shell)
- Use uv for Python scripts and package management
- Don't pipe command output through `head`, `tail`, `less`, or `more`: causes buffering problems. Let commands complete fully.

## Writing Style (all prose: PR descriptions, comments, replies, drafted messages)

Match George's voice: casual, direct, conversational. Short paragraphs, flowing prose over bullet points. Use contractions naturally. Informal transitions ("that said", "so", "anyway"). Start sentences lowercase when it feels natural.

No em dashes, semicolons, formal connectors ("however", "furthermore"), or LLM fluff ("certainly", "great question", "it's worth noting"). No "It's not X, it's Y" constructions: lead with the positive claim. Light on hedging. Smileys :) are fine, no other emoji. Reference specifics to ground arguments. Never hard-wrap lines.

## PRs and Commits

- Omit Claude Code attribution footer
- Semantic prefix in PR titles (feat:, fix:, chore:), capitalized after prefix
- Skip test plan sections in PR descriptions. No "## Summary" heading, just start with content
- Casual, concise descriptions and commit messages: no fluff, no em dashes, minimal bullets, use colons
- For Graphite PRs (`gt submit`), show the Graphite link not GitHub
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

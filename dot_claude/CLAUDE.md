# Claude Code Preferences

## General
- Use macOS-specific commands and options for tools like grep, find, and sed
- Never use iex since it's an interactive shell
- Use uv for Python scripts and package management

## Bash and Zsh Guidelines

### IMPORTANT: Avoid commands that cause output buffering issues
- DO NOT pipe output through `head`, `tail`, `less`, or `more` when monitoring or checking command output
- DO NOT use `| head -n X` or `| tail -n X` to truncate output - these cause buffering problems
- Instead, let commands complete fully, or use `--max-lines` flags if the command supports them
- For log monitoring, prefer reading files directly rather than piping through filters

### When checking command output:
- Run commands directly without pipes when possible
- If you need to limit output, use command-specific flags (e.g., `git log -n 10` instead of `git log | head -10`)
- Avoid chained pipes that can cause output to buffer indefinitely

## PR Creation
- Omit Claude Code attribution footer in PRs
- Skip test plan and validation steps in PR descriptions
- Use semantic commit prefix in PR titles (e.g., feat:, fix:, chore:, docs:, perf:, refactor:)
- Capitalize the title after the prefix
- Write human-like descriptions: casual, concise, no LLM fluff, no em dashes, no dashes, minimal bullet points, use colons if needed

## Commits

- Omit Claude Code attribution footer in commits
- Always refactor the code you wrote to remove unnecessary comments
- Write human-like messages: casual, concise, no LLM fluff, no em dashes, no dashes. Try to use colons if needed
- Don't hard-wrap lines in commit/PR descriptions; let sentences flow naturally without mid-sentence line breaks

## Workflow Orchestration

### 1. Plan Mode Default
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately - don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### 2. Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution

### 3. Self-Improvement Loop (Compound Step)
- After ANY correction from the user: add entry to Lessons Learned section below
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review Lessons Learned at session start

### 4. Verification Before Done
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### 5. Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes - don't over-engineer
- Challenge your own work before presenting it

### 6. Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests - then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

## Core Principles
- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Changes should only touch what's necessary. Avoid introducing bugs.

---

## Lessons Learned

Accumulated patterns and mistakes that compound across sessions. Add new entries at the top.

### Patterns That Work

<!-- Successful approaches to reuse -->

### Mistakes to Avoid

<!-- Anti-patterns with context -->

### Recent Entries

<!-- Format:
#### [Date] Short Title
**Context**: What was happening
**Mistake**: What went wrong
**Rule**: How to prevent it next time
-->

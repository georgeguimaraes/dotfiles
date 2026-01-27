# Claude Code Preferences

## General

- Use macOS-specific commands and options for tools like grep, find, and sed
- Never use iex since it's an interactive shell
- Use uv for Python scripts and package management

## Bash Guidelines

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

## LiveView Best Practices

- **Avoid DB Queries in mount/3**: Mount is called twice (HTTP and WebSocket) causing duplicate queries
  - Use mount only to initialize empty assigns with default values
  - Move all database queries to handle_params
  - For non-critical data, use async operations (send self messages)
  - This pattern improves initial page load performance and prevents redundant queries


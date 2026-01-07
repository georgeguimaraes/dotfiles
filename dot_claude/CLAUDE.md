# Claude Code Preferences

## General

- Use macOS-specific commands and options for tools like grep, find, and sed
- Never use iex since it's an interactive shell
- Use uv for Python scripts and package management

## PR Creation

- Omit Claude Code attribution footer in PRs
- Skip test plan and validation steps in PR descriptions
- Use semantic commit prefix in PR titles (e.g., feat:, fix:, chore:, docs:, perf:, refactor:)
- Capitalize the title after the prefix
- Write human-like descriptions: casual, concise, no LLM fluff, no em dashes, minimal bullet points

## Commits

- Omit Claude Code attribution footer in commits
- Don't write comments that are obvious in the code
- Write human-like messages: casual, concise, no LLM fluff, no em dashes

## LiveView Best Practices
- **Avoid DB Queries in mount/3**: Mount is called twice (HTTP and WebSocket) causing duplicate queries
  - Use mount only to initialize empty assigns with default values
  - Move all database queries to handle_params
  - For non-critical data, use async operations (send self messages)
  - This pattern improves initial page load performance and prevents redundant queries
George's daily tools,<br>
Chezmoi tends dotfiles with care,<br>
Efficiency blooms.

## Set up a new Mac

These steps install the dotfiles with [chezmoi](https://www.chezmoi.io/). Some files are encrypted with age, so get the age key before you apply.

1. Install [Homebrew](https://brew.sh/).
2. Install the tools:
   ```sh
   brew install chezmoi age 1password-cli
   ```
3. Sign in to the 1Password CLI.
4. Get the age key from the Personal vault:
   ```sh
   mkdir -p ~/.config/chezmoi
   op document get "chezmoi age identity (dotfiles)" --vault Personal --out-file ~/.config/chezmoi/key.txt
   chmod 600 ~/.config/chezmoi/key.txt
   ```
5. Clone the repo and generate the chezmoi config:
   ```sh
   chezmoi init georgeguimaraes
   ```
6. Examine the changes before you apply them:
   ```sh
   chezmoi diff
   ```
7. Apply the dotfiles and install the tools:
   ```sh
   chezmoi apply
   ```
   The first apply takes some minutes, because it installs the Homebrew packages and the mise tools.
8. Add your SSH key to GitHub.
9. Set the remote to SSH, because chezmoi pushes each change automatically:
   ```sh
   chezmoi git -- remote set-url origin git@github.com:georgeguimaraes/dotfiles.git
   ```

If your SSH key is already on GitHub, use `chezmoi init --ssh georgeguimaraes` in step 5 and skip steps 8 and 9.

## What the scripts install

The scripts in `.chezmoiscripts` run during `chezmoi apply`:

- `run_onchange_before_10-brew-bundle.sh.tmpl` installs the Homebrew formulae, apps and fonts. It runs again when the list changes.
- `run_once_after_20-installers.sh.tmpl` installs [mise](https://mise.jdx.dev/) and [uv](https://docs.astral.sh/uv/) with their official install scripts.
- `run_onchange_after_30-mise-install.sh.tmpl` runs `mise install` for the tools in `~/.config/mise/config.toml`: Erlang, Elixir, Node.js LTS, Rust and some CLI tools. It runs again when that file changes.

The scripts do not upgrade tools. Use `topgrade` for upgrades.

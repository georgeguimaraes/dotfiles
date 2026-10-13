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
7. Apply the dotfiles:
   ```sh
   chezmoi apply
   ```
8. Add your SSH key to GitHub.
9. Set the remote to SSH, because chezmoi pushes each change automatically:
   ```sh
   chezmoi git -- remote set-url origin git@github.com:georgeguimaraes/dotfiles.git
   ```

If your SSH key is already on GitHub, use `chezmoi init --ssh georgeguimaraes` in step 5 and skip steps 8 and 9.

This repo has only configuration files. It does not install Homebrew packages, asdf, Node.js or pnpm. Install them manually.

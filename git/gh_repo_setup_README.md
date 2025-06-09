# gh_repo_setup

Quick local Git repo setup with branches and Jupyter+Mermaid workflow.

## Installation

1. **Copy script:**
   ```bash
   mkdir -p ~/bin
   cp gh_repo_setup.sh ~/bin/gh_repo_setup
   chmod +x ~/bin/gh_repo_setup
   ```

2. **Add to PATH:**
   ```bash
   echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```
   *Use `~/.zshrc` if using zsh*

3. **Test:**
   ```bash
   gh_repo_setup
   ```

## Usage

```bash
cd your-project-directory
gh_repo_setup
```

Follow the prompts. Creates branches and optional GitHub Actions workflow for auto-converting notebooks + Mermaid diagrams.

## Requirements

- Git configured with user.name and user.email
- Bash/Zsh shell

{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    # Zsh history
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
      size = 10000;
    };

    # Custom .zshrc additions
    initExtra = ''
      # Set up zoxide
      eval "$(zoxide init zsh)"

      # Set up atuin
      eval "$(atuin init zsh)"

      # Configure fzf
      export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
      export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
      export FZF_ALT_C_OPTS="--preview 'eza --icons --color=always --tree --level=2 {}'"

      # PET snippet manager
      export PET_CONFIG="$HOME/.config/pet/config.toml"

      # Fuzzy file search
      export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude '.git'"
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

      # Use eza instead of ls
      alias ls='eza --icons --group-directories-first'
      alias ll='eza -l --icons --group-directories-first'
      alias la='eza -la --icons --group-directories-first'
      alias lt='eza --tree --level=2 --icons'

      # Git aliases
      alias g='git'
      alias gs='git status'
      alias ga='git add'
      alias gc='git commit'
      alias gp='git push'
      alias gl='git pull'
      alias gd='git diff'
      alias gco='git checkout'
      alias gb='git branch'
      alias gf='git fetch'
      alias gm='git merge'
      alias gr='git rebase'
      alias gst='git stash'
      alias gstp='git stash pop'

      # GitHub CLI aliases
      alias ghpr='gh pr create --fill'
      alias ghco='gh pr checkout'
      alias ghst='gh pr status'
      alias ghcl='gh pr create --title "$(git branch --show-current): " --body ""'

      # General aliases
      alias cat='bat --style=auto'
      alias find='fd'
      alias du='du -sh'
      alias df='df -h'
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'

      # Modern tools
      alias top='htop'
      alias ping='ping -c 5'

      # Correct command with thefuck
      eval "$(thefuck --alias)"

      # Enable direnv
      eval "$(direnv hook zsh)"

      # Set default editor
      export EDITOR='vim'
      export VISUAL='vim'

      # Node.js version manager (fnm)
      eval "$(fnm env)"

      # Mise version manager
      eval "$(mise activate zsh)"

      # Enable color support
      export CLICOLOR=1
      export LSCOLORS=ExFxBxDxCxegedabagacad

      # Set language
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8
    '';

    # Bundle extra file (for additional zshrc content)
    # bundleExtra = '';
  };

  # Enable fzf tab completion
  programs.fzf = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
  };

  # Enable zoxide
  programs.zoxide = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
  };

  # Enable atuin
  programs.atuin = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
    settings = {
      style = "compact";
      search_mode = "directory";
    };
  };
}

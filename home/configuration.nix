{ config, pkgs, ghostty, ... }:

{
  imports = [
    ./ghostty/ghostty.nix
    ./zsh/zshrc.nix
  ];

  home = {
    username = "satyam";
    homeDirectory = "/Users/satyam";

    packages = with pkgs; [
      # Version control
      gh

      # Fuzzy finder and utilities
      fzf
      fd_enhanced
      zoxide
      yazi
      ripgrep

      # Snippet tool
      pet

      # Shell enhancements
      atuin
      starship
      thefuck
      direnv

      # Node.js managers
      mise
      fnm

      # Python tools
      uv

      # JSON processor
      jq

      # Modern CLI tools
      eza
      bat
      htop
    ];

    sessionVariables = {
      # Enable starship prompt
      STARSHIP_CONFIG = "${config.home.homeDirectory}/.config/starship.toml";
    };

    # Configure Ghostty
    file.".config/ghostty/config".text = config.ghostty.config;
  };

  # Enable starship for zsh with gruvbox-rainbow preset
  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
    settings = {
      # gruvbox-rainbow preset format
      format = "$username$hostname$directory$git_branch$git_status$nodejs$python$rust$golang$context$character";
      username = {
        show_always = true;
        style_root = "bold red";
        style_user = "bold blue";
      };
      hostname = {
        show_always = true;
        style = "bold blue";
      };
      directory = {
        style = "bold cyan";
        truncation_symbol = "";
        home_symbol = "~";
      };
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      nodejs = {
        symbol = "node ";
        style = "bold green";
      };
      python = {
        symbol = "py ";
        style = "bold yellow";
      };
      rust = {
        symbol = "rs ";
        style = "bold red";
      };
    };
  };

  # Home Manager activation check
  home.activation = pkgs.writeScript "activate-ghostty-nix" ''
    echo "Activating Ghostty Nix configuration..."
  '';
}

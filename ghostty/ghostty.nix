{ config, pkgs, ... }:

{
  ghostty.config = {
    # Font configuration
    font-family = "JetBrains Mono";
    font-size = 13;
    font-features = {
      "JetBrains Mono" = [ "+calt" "+liga" "+dlig" ];
    };

    # Catppuccin Mocha theme colors
    background = "#1e1e2e";
    foreground = "#cdd6f4";
    cursor-color = "#f5e0dc";
    selection-background = "#45475a";
    selection-foreground = "#cdd6f4";

    # Window settings
    window-padding-x = 10;
    window-padding-y = 10;
    window-opacity = 1.0;

    # Title - use shell integration to set dynamically
    title = "@{title}";

    # Shell
    shell = "${pkgs.zsh}/bin/zsh";
    shell-integration = "detect";
    shell-integration-features = "no-title";

    # Keybindings (use keybind, not keybindings)
    keybind = {
      # New tab
      "cmd-t" = "new_tab";

      # Close tab
      "cmd-w" = "close_tab";

      # Next/previous tab
      "cmd-shift-bracketright" = "next_tab";
      "cmd-shift-bracketleft" = "previous_tab";

      # Zoom
      "cmd-plus" = "font_size_increase";
      "cmd-minus" = "font_size_decrease";
      "cmd-0" = "font_size_reset";
    };
  };
}

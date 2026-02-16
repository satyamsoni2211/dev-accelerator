{ config, pkgs, ... }:

{
  ghostty.config = {
    # Font configuration
    font-family = "JetBrains Mono";
    font-size = 13;
    font-weight = 400;
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
    window-padding-display = "centered";
    window-opacity = 1.0;
    window-title = "@{title}";

    # Tab bar
    tab-bar = "always";
    tab-bar-font-size = 12;
    tab-bar-background = "#181825";
    tab-bar-foreground = "#cdd6f4";
    tab-bar-mode = "flex";
    tab-title = "@{window-title}";

    # Shell
    shell = "${pkgs.zsh}/bin/zsh";
    shell-integration-features = "no-cursor";

    # Keybindings
    keybindings = {
      # New tab
      "cmd-t" = "new_tab";
      "cmd-n" = "new_tab";

      # Close tab
      "cmd-w" = "close_tab";

      # Next/previous tab
      "cmd-shift-bracketright" = "next_tab";
      "cmd-shift-bracketleft" = "previous_tab";

      # New window
      "cmd-shift-n" = "new_window";

      # Copy/Paste
      "cmd-c" = "copy";
      "cmd-v" = "paste";

      # Zoom
      "cmd-plus" = "font_size_increase";
      "cmd-minus" = "font_size_decrease";
      "cmd-0" = "font_size_reset";
    };

    # Performance
    # threaded-renderer = true;

    # Mouse
    mouse-hide = true;

    # Bell
    bell = "none";
  };
}

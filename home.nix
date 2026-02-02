{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "hjiang";
  home.homeDirectory = "/home/hjiang";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set-option -g prefix 'C-j'

      set -s escape-time 1
      set -g mouse on
      set -g base-index 1

      bind r \
           source-file ~/.config/tmux/tmux.conf \; \
           display-message "Configuration reloaded"

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+

      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Colors - subtle muted palette
      # Background: dark gray, Foreground: soft white
      # Accent: muted teal

      # Status bar
      set -g status-style "bg=#1e1e2e,fg=#cdd6f4"
      set -g status-left "#[fg=#89b4fa,bold] #S #[fg=#45475a]│"
      set -g status-right "#[fg=#45475a]│#[fg=#a6adc8]  %H:%M #[fg=#45475a]│#[fg=#89b4fa] %b %d "
      set -g status-left-length 30
      set -g status-right-length 40

      # Window status
      set -g window-status-format "#[fg=#6c7086] #I:#W "
      set -g window-status-current-format "#[fg=#cba6f7,bold] #I:#W "
      set -g window-status-separator ""

      # Pane borders
      set -g pane-border-style "fg=#313244"
      set -g pane-active-border-style "fg=#89b4fa"

      # Dim inactive panes
      set -g window-style "fg=#585b70"
      set -g window-active-style "fg=#cdd6f4"

      # Message and command prompt
      set -g message-style "bg=#313244,fg=#cdd6f4"
      set -g message-command-style "bg=#313244,fg=#cdd6f4"

      # Mode (copy mode highlight)
      set -g mode-style "bg=#45475a,fg=#cdd6f4"
    '';
  };
}

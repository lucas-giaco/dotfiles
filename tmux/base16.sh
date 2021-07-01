# shellcheck shell=bash

# Base16 Styling Guidelines:

# Length of tmux status line
set -g status-left-length 30
set -g status-right-length 150

# Refresh status line every 5 seconds - Good for when music is playing / update time etc
set -g status-interval 5

# Start window and pane indices at 1.
set -g base-index 1
set -g pane-base-index 0

set-option -g status "on"

# default statusbar colors
set-option -g status-style bg=colour237,fg=colour223 # bg=bg1, fg=fg1

# Default window title colors
set-window-option -g window-status-style bg=colour214,fg=colour237 # bg=yellow, fg=bg1

# Default window with an activity alert
set-window-option -g window-status-activity-style bg=colour237,fg=colour248 # bg=bg1, fg=fg3

# Active window title colors
set-window-option -g window-status-current-style bg=red,fg=colour237 # fg=bg1

# Set active pane border color
set-option -g pane-active-border-style fg=colour214

# Set inactive pane border color
set-option -g pane-border-style fg=colour239

# Message info
set-option -g message-style bg=colour239,fg=colour223 # bg=bg2, fg=fg1

# Writing commands inactive
set-option -g message-command-style bg=colour239,fg=colour223 # bg=fg3, fg=bg1

# Pane number display
set-option -g display-panes-active-colour colour1 #fg2
set-option -g display-panes-colour colour237 #bg1

# Clock
set-window-option -g clock-mode-colour colour109 #blue

# Bell
set-window-option -g window-status-bell-style bg=colour167,fg=colour235 # bg=red, fg=bg

set-option -g status-left "\
#[fg=colour7, bg=colour241]#{?client_prefix,#[bg=colour167],} ❐ #S \
#[fg=colour241, bg=colour237]#{?client_prefix,#[fg=colour167],}#{?window_zoomed_flag, 🔍 ,}"

set-window-option -g window-status-current-format "\
#[fg=colour237, bg=colour214]\
#[fg=colour239, bg=colour214] #I* \
#[fg=colour239, bg=colour214, bold] #W \
#[fg=colour214, bg=colour237]"

set-window-option -g window-status-format "\
#[fg=colour237,bg=colour239,noitalics]\
#[fg=colour223,bg=colour239] #I \
#[fg=colour223, bg=colour239] #W \
#[fg=colour239, bg=colour237]"

# shellcheck disable=SC2034
KUBE_TMUX_SYMBOL_CUSTOM="☸️  "
tm_k8s="#(/bin/bash ~/.tmux/plugins/kube-tmux/kube.tmux 214 colour214 white)"
tm_gcp="#(/bin/bash ~/.tmux/plugins/gcp-tmux/gcp.tmux)"

set-option -g status-right "\
#[fg=colour214, bg=colour237] \
#[fg=colour237, bg=colour214] \
#[fg=colour223, bg=colour237] $tm_gcp\
#[fg=colour239, bg=colour237] \
#[fg=colour237, bg=colour239] \
#[fg=colour223, bg=colour237] $tm_k8s \
#[fg=colour246, bg=colour237]  %b %d '%y\
#[fg=colour109]  %R \
#[fg=colour248, bg=colour239]"

# .profile
# vim: et si ai syn=tmux:
# 
# (c) 2018, Andres Aquino <inbox@andresaquino.sh>
# This file is licensed under the BSD License version 3 or later.
# See the LICENSE file.
# 
# LastModf: 20180607.0956
#
 
# Rename from tmux.profile to ${HOME}/.tmux.conf

# General:
# C-a           Prefix
# C-a   r       Source .tmux.conf
# C-a   ?       Show key bindings
# C-a   t       Show time
#
# Sessions:
# C-a   s       List sessions
# C-a   $       Rename session
#
# Windows (tabs):
# C-a   c       Create window
# C-a   w       List windows
# C-a   f       Find window
# C-a   ,       Name window
# C-a   &       Kill window
#
# Panes (splits):
# C-a   |       Vertical split
# C-a   -       Horizontal split
# C-a   o       Jump between panes
# C-a   q       Show pane numbers (type number to jump)
# C-a   x       Kill pane
# C-a   !       Break pane out into a window
# C-a   j       Create pane from an existing window
# C-a   arrow   Move between panes
# S-a   arrow   Move between windows

# resize windows on larger screens - if off the size is capped to the smallest
# screen size that has ever looked at it
setw -g aggressive-resize on

# enable 256 colors mode - important if you want the solarized theme look
# semi-decent in vim
set -g default-terminal "screen-256color"

# put useful info in the status bar
set-option -g set-titles on
set-option -g set-titles-string '#H.#S.#I.#P #W #T' # window number,program name, active(or not)

# highlight the current window in the status bar (blue background)
set-option -g status-left-length 60
set-option -g status-right-length 90

#       #I - window index
#       #W - window title
#       #F - window flag
set-window-option -g window-status-format '#I:#W #F '
set-window-option -g window-status-current-format '#[fg=yellow]#I:#W#[fg=white]#F '

# Right side of status bar
#       $(echo $USER) - shows the current username
#       #H - shows the hostname of your computer
#       %h %d %Y - date in the [Mon DD YYYY] format
#       %l:%M %p - time in the [HH:MM AM/PM] format
set -g status-right '#[fg=blue]@#H#[fg=white] | #[fg=blue,bold]%Y%m%d·#[fg=white,bold]%H%M#[default] '

# remap prefix to C-a
set -g prefix C-a
unbind-key C-b
bind-key C-a send prefix

# C-a C-a jumps to previous window
bind-key C-a last-window

# For nested sessions, C-a a sends a command to the inner session
bind-key a send-prefix

# Use C-r to reload of the config file
unbind-key r
bind-key r source-file ~/.tmux.conf \; display-message "Config reloaded..."

# windows start at 1 instead of 0
set -g base-index 1

# more history
set -g history-limit 100000

# better splits with | and -
bind-key | split-window -h
bind-key - split-window -v

# switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# switch windows using Shift+Left|Right without prefix
bind -n S-Left  previous-window
bind -n S-Right next-window

# put status bar top
set-option -g status-position top

# don't rename windows automatically
set-option -g allow-rename off

# status bar colors etc
set-option -g status-bg black
set-option -g status-fg blue
set-option -g status-interval 5
set-option -g visual-activity off
set-window-option -g monitor-activity on
set-window-option -g window-status-current-fg white

# convert window into a pane
bind-key j command-prompt -p "Create pane from window #:" "join-pane -s ':%%'"

# screensaver
set-option -g lock-after-time 120
set-option -g lock-command "/usr/local/bin/tty-clock -s -S -C 0 -c -B"

# tmux plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# tmux nord-theme
set -g @plugin 'arcticicestudio/nord-tmux'

# nord-theme options
set -g @nord_tmux_no_patched_font "1"


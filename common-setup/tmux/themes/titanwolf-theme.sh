# Default Theme
 # here, will be if either of setting the joint portion of each display.
# https://titanwolf.org/Network/Articles/Article?AID=aaac9195-d35a-46c5-b560-1366a0abd161#gsc.tab=0


if patched_font_in_use; then

  TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="⮂" 

  TMUX_POWERLINE_SEPARATOR_LEFT_THIN="⮃" 

  TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="⮀" 

  TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="⮁" 
 else

  TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="◀" 

  TMUX_POWERLINE_SEPARATOR_LEFT_THIN="❮" 

  TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="▶" 

  TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="❯" 
 fi


TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-'235'}
 TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-'255'}


TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}
 TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}


# Format: segment_name background_color foreground_color [non_default_separator]
 # here, `the tmux-powerline/execution result of the shell script in the segments`, will be one of the set to display in any order.


# Status line left 
 if [ -z $TMUX_POWERLINE_LEFT_STATUS_SEGMENTS ]; then

  TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(

    "tmux_session_info 2 7" \# session 

    "hostname 3 255" \# host name 

    "vcs_compare 60 255" \#Compare

    "vcs_staged 64 255" \#Staged

    "vcs_modified 9 255" \#Modified

    "vcs_others 245 0" \#Others

    "ifstat 30 255" \# network utilization 

    #" ifstat_sys 30 255 "\# network system 

    $ #" lan_ip 24 255 {TMUX_POWERLINE_SEPARATOR_RIGHT_THIN } "\#LAN IP address

    # "Wan_ip 24 255"\#WAN IP address


  )
 fi


# Status line right 
 if [ -z $TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS ]; then

  TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(

    # "Earthquake 3 0"\# earthquake early warning 

    "vcs_branch 29 88" \# branch name 

    # "pwd 89 211"\# in the current directory 

    "mailcount 9 255" \# E-mail 

    "now_playing 234 37" \# playback song 

    "cpu 240 136" \#CPU

    "load 6 7" \# load 

    #" tmux_mem_cpu_load 234 136 "\# memory 

    "battery 5 7" \# battery 

    #" weather 37 255 "\# weather 

    #" rainbarf 0 0 "\# Precipitation probability 

    layout of # "xkb_layout 125 117"\#XKB

    "date_day 2 7" \# Date 

    "date 2 7 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \# date 

    "time 2 7 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \# Time 

    # "utc_time 235 136 $ {TMUX_POWERLINE_SEPARATOR_LEFT_THIN }"\# start-up time 

  )
 fi
 
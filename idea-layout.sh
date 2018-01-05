#!/bin/sh

pids=$(xdotool search --all --onlyvisible --desktop $(xprop -notype -root _NET_CURRENT_DESKTOP | cut -c 24-) "")

for pid in $pids; do
    xdotool windowunmap $pid
done

i3-msg "append_layout ~/.screenlayout/idea.json"

for pid in $pids; do
    xdotool windowmap $pid
done

#!/bin/sh

xrandr --output VGA-0 --mode 1920x1200 --pos 0x0 --rotate normal --output DVI-0 --mode 1920x1200 --pos 1920x0 --rotate normal

exec xmonad


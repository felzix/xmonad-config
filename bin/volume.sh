#!/bin/bash

padding=0
if [ "x$1" == "x-p" -a ! -z "$2" ]; then
    padding=$2
fi

a=(`amixer -c0 sget Master,0|tail -n1`)

volume=$(echo ${a[3]}|tr -d "[]%")

printf "%${padding}d%%" $volume


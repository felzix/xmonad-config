#!/bin/bash

padding=0
if [ "x$1" == "x-p" -a ! -z "$2" ]; then
    padding=$2
fi

host=`hostname`
if [ "$host" != "robert-desktop" ]; then
    ./unread.py
    exit 0
fi

count=`$HOME/lib/mork-converter/src/mork $HOME/.thunderbird/pwj9fjh6.default/ImapMail/webmail.locationlabs.com/INBOX.msf|grep numNewMsgs|perl -pi -e "s/\D//gi"`

if [ -z "$count" ]; then
echo "<fc=red>ERROR</fc>"
exit
fi

p() {
    n=$1
    c=$2
    if [ -z "$c" ]; then
        printf "%${padding}d" $n
    else
        printf "<fc=$c>%${padding}d</fc>" $n
    fi
}

if [ "$count" -eq 0 ]; then
p $count
exit
fi

# count > 0

p $count red


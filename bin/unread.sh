#!/bin/bash

host=`hostname`
if [ "$host" -eq "robert-desktop" ]; then
    ./unread.py
    exit 0
fi

count=`$HOME/lib/mork-converter/src/mork $HOME/.thunderbird/pwj9fjh6.default/ImapMail/webmail.locationlabs.com/INBOX.msf|grep numNewMsgs|perl -pi -e "s/\D//gi"`

if [ -z "$count" ]; then
echo "<fc=red>ERROR</fc>"
exit
fi

if [ "$count" -eq 0 ]; then
echo $count
exit
fi

# count > 0

echo -n "<fc=red>"
echo -n $count
echo "</fc>"
 

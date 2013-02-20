#!/bin/bash

host=`hostname`

workCalendar=`cat work-calendar`

if [ "$host" == "robert-desktop" ]; then
    firefox -new-window "$workCalendar"
else
    google-chrome "https://www.google.com/calendar"
fi


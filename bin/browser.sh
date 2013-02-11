#!/bin/bash

host=`hostname`
if [ "$host" == "robert-desktop" ]; then
    firefox $@
else
    google-chrome $@
fi


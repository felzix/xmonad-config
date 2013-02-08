#!/bin/bash

# doesn't work because pandora (pithos) doesn't do prev
dbus-send --session --type=method_call --dest=org.mpris.MediaPlayer2.pithos /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Prev


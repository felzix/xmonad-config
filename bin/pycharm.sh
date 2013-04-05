#!/bin/bash

# PyCharm doesn't work with java 7 of neither openjdk nor oracle
# So I use java 6 openjdk since I have it.

export JAVA_HOME=/usr/lib/jvm/java-6-oracle
export JDK_HOME=/usr/lib/jvm/java-6-oracle
export PYCHARM_HOME=/home/felzix/bin/pycharm
export PYCHARM_VM_OPTIONS="$PYCHARM_HOME/bin/pycharm64.vmoptions"
export PYCHARM_PROPERTIES="$PYCHARM_HOME/bin/idea.properties"
export LIBXCB_ALLOW_SLOPPY_LOCK=1

cd "$PYCHARM_HOME/bin"

./pycharm.sh


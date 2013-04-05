#!/bin/bash

#export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
#export JDK_HOME=/usr/lib/jvm/java-7-openjdk-amd64
#export JAVA_HOME=/usr/lib/jvm/java-7-oracle
#export JDK_HOME=/usr/lib/jvm/java-7-oracle
export JAVA_HOME=/usr/lib/jvm/java-6-oracle
export JDK_HOME=/usr/lib/jvm/java-6-oracle
export PYCHARM_HOME=/home/felzix/bin/pycharm
export PYCHARM_VM_OPTIONS="$PYCHARM_HOME/bin/pycharm64.vmoptions"
export PYCHARM_PROPERTIES="$PYCHARM_HOME/bin/idea.properties"
export LIBXCB_ALLOW_SLOPPY_LOCK=1

cd "$PYCHARM_HOME/bin"

./pycharm.sh


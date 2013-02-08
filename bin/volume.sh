#!/bin/bash

a=(`amixer -c0 sget Master,0|tail -n1`)

echo ${a[3]}|tr -d "[]"


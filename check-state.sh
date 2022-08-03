#!/bin/bash

whoNeed2Check=$1

echo "checking $whoNeed2Check"
isRunning=`ps -ef | grep "$whoNeed2Check" | grep -v 'grep' | grep 'bin/java' | awk '{print $2}'`

if [ -z "$whoNeed2Check" ]; then
    echo "input [$whoNeed2Check] cannot empty..."
    exit 1
elif [ -z "${isRunning}" ]; then
    echo "$whoNeed2Check stop ..."
    exit 2
else
    echo "$whoNeed2Check is running pid:$isRunning"
    exit 0
fi

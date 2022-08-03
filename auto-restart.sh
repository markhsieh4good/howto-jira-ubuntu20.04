#!/bin/bash

_ChkApp="jira"

bash ./check-state.sh "$_ChkApp" || errno=$?
echo "return result: ${errno}"
if [ -z "${errno}" ]; then
    echo "keep checking ..."
elif [ "${errno}" -eq 0 ]; then
    echo "keep checking ..."
elif [ "${errno}" -eq 2 ]; then
    echo "auto restart $_ChkApp"
    if [ -e ./"start-$_ChkApp".sh ]; then
        . ./"start-$_ChkApp".sh
    else
        echo "not exist start-$_ChkApp.sh action ... "
    fi
else
    echo "unknown checking target ..."
fi

echo "done"

#!/usr/bin/env bash

function sync_file(){
    cp -f ${FROM_FILE}  ${TO_FILE}
    if [ "$?" -ne 0 ]
    then
        echo "copy file fail."
    else
	echo "${TO_FILE} in sync"
    fi
}

if [ ! -f ${FROM_FILE} ]
then
    echo "file ${FROM_FILE} not exist."
    exit 1
fi

LTIME=`stat -c %Z ${FROM_FILE}`
sync_file
while true
do
   ATIME=`stat -c %Z ${FROM_FILE}`

   if [[ "$ATIME" != "$LTIME" ]]
   then
       sync_file
       LTIME=$ATIME
   fi
   sleep ${CHECK_INTERVAL:-1}
done

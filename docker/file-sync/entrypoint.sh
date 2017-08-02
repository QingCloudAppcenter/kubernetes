#!/usr/bin/env bash

function sync_file(){
    d=$(dirname ${TO_FILE})
    mkdir -p "${d}"
    cat ${FROM_FILE} > ${TO_FILE}
    if [ "$?" -ne 0 ]
    then
        echo "copy file fail."
    else
	echo "${TO_FILE} in sync"
    fi
}

echo "sync ${FROM_FILE} to ${TO_FILE} "
while [ ! -f ${FROM_FILE} ]
do
    echo "file ${FROM_FILE} not exist, wait 5 second."
    sleep 5
done

# the stat of link will not change since it created.
if [ -L ${FROM_FILE} ]
then
    FROM_FILE=$(readlink -f ${FROM_FILE})
    echo "from file is symlink, convert to real path: ${FROM_FILE}"
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

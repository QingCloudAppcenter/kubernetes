#!/usr/bin/env bash

function sync_file(){
    local F=$1
    local T=$2
    local d=$(dirname ${T})
    mkdir -p "${d}"
    cat ${F} > ${T}
    if [ "$?" -ne 0 ]
    then
        echo "copy file fail."
    else
	echo "${T} in sync with ${F}"
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
    REAL_FILE=$(readlink -f ${FROM_FILE})
    echo "from file is symlink, convert to real path: ${REAL_FILE}"
else
    REAL_FILE=${FROM_FILE}
fi

LTIME=`stat -c %Z ${REAL_FILE}`
sync_file ${REAL_FILE} ${TO_FILE}
while true
do
   ATIME=`stat -c %Z ${REAL_FILE}`

   if [[ "$ATIME" != "$LTIME" ]]
   then
       sync_file ${REAL_FILE} ${TO_FILE}
       LTIME=$ATIME
   fi
   sleep ${CHECK_INTERVAL:-1}
   #link target may be change.
   if [ -L ${FROM_FILE} ]
   then
     NEW_REAL_FILE=$(readlink -f ${FROM_FILE})
     if [ "${NEW_REAL_FILE}" != "${REAL_FILE}" ]
     then
        REAL_FILE=${NEW_REAL_FILE}
        echo "from file symlink is change, convert to real path: ${REAL_FILE}"
     fi
   fi
done
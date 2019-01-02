#!/bin/ash
BASEPATH=.

echo "generate list of container names out of compose file:"
sed '/^volumes/q' docker-compose.yml | grep -Eo "^  [a-z-]+" | awk '{$1=$1;print}' | sort > ${BASEPATH}/compose.list
cat ${BASEPATH}/compose.list

echo "generate list of running containers:"
docker ps --format '{{.Names}}' | sort > ${BASEPATH}/running.list
cat ${BASEPATH}/running.list

CONTAINERS_TO_STOP=$(diff compose.list running.list | grep ">" | cut -d ' ' -f 2)
CONTAINERS_TO_START=$(diff compose.list running.list | grep "<" | cut -d ' ' -f 2)

echo "stop/rm containers not in docker-compose:"
for CONTAINER in $CONTAINERS_TO_STOP; do
    docker rm -f $CONTAINER
done

echo "start containers not running:"
for CONTAINER in $CONTAINERS_TO_START; do
    docker-compose up -d $CONTAINER
done

echo "just run ..."
tail -f /dev/null
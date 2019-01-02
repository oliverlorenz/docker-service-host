#!/bin/ash
BASEPATH=.

echo "generate list of container names out of compose file:"
sed '/^volumes/q' docker-compose.yml | grep -Eo "^  [.a-z-]+" | awk '{$1=$1;print}' | sort > ${BASEPATH}/compose.list
cat ${BASEPATH}/compose.list

echo "generate list of running containers:"
docker ps --format '{{.Names}}' | sort > ${BASEPATH}/running.list
cat ${BASEPATH}/running.list
CONTAINERS_TO_STOP=$(diff compose.list running.list | grep -E "^[->]" | grep -v "\.list$" | grep -Eo "^[-><+]?[.a-z]+$" | cut -c 2-)
CONTAINERS_TO_START=$(diff compose.list running.list | grep -E "^[+<]" | grep -v "\.list$" | grep -Eo "^[-><+]?[.a-z]+$" | cut -d ' ' -f 2)

cd /data

echo "stop/rm containers not in docker-compose:"
for CONTAINER in $CONTAINERS_TO_STOP; do
    echo "docker rm -f $CONTAINER"
    docker rm -f $CONTAINER
done

echo "start containers not running:"
# diff compose.list running.list
for CONTAINER in $CONTAINERS_TO_START; do
    echo "docker-compose up -d $CONTAINER"
    docker-compose up -d $CONTAINER
done

echo "just run ..."
tail -f /dev/null
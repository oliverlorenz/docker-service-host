BASEPATH=.

#echo "generate list of container names out of compose file:"
sed '/^volumes/q' docker-compose.yml | grep -Eo "^  [.a-z-]+" | awk '{$1=$1;print}' | sort > ${BASEPATH}/compose.list
echo "containers in compose"
echo "---------------------"
cat ${BASEPATH}/compose.list
echo 

#echo "generate list of running containers:"
docker ps --format '{{.Names}}' | sort > ${BASEPATH}/running.list
echo "running containers"
echo "------------------"
cat ${BASEPATH}/running.list
echo 

echo "containers to stop"
echo "-------------------"
CONTAINERS_TO_STOP=$(diff -u compose.list running.list | tac | sed -e '/@@/q' | tac | grep -E "^\+" | cut -c 2-)
echo "$CONTAINERS_TO_STOP"
echo 

echo "containers to start"
echo "-------------------"
CONTAINERS_TO_START=$(diff -u compose.list running.list | tac | sed -e '/@@/q' | tac | grep -E "^-" | cut -c 2-)
echo "$CONTAINERS_TO_START"
echo 

if [ -n "$CONTAINERS_TO_STOP" ]; then
    echo "stopping container"
    echo "------------------"
    echo docker rm -f $CONTAINERS_TO_STOP
    docker rm -f $CONTAINERS_TO_STOP
else
    echo "nothing to stop"
fi
echo

echo "starting container"
echo "------------------"
echo docker-compose up -d
docker-compose up -d
echo 

#echo "stop/rm containers not in docker-compose:"
#for CONTAINER in $CONTAINERS_TO_STOP; do
#    echo "docker rm -f $CONTAINER"
#    docker rm -f $CONTAINER
#done
#
#echo "start containers not running:"
#echo "docker-compose up -d ${CONTAINERS_TO_START}"
#docker-compose up -d ${CONTAINERS_TO_START}
#
echo "just run ..."
tail -f /dev/null
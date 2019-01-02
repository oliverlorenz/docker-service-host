# service host

This is a base image. To use that image you have to add a docker-compose file:

```
FROM oliverlorenz/service-host
ADD docker-compose.yml /data/docker-compose.yml
```

## What it does?

You can define a docker compose file. At startup of the container it checks which container have to be started with `docker-compose up -d $CONTAINER` and which have top be stopped and removed. A perfect addition to watchtower
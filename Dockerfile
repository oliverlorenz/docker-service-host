FROM docker:dind
WORKDIR /data
RUN apk update && \
    apk add curl && \
    curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose
ADD . .
CMD sh start.sh
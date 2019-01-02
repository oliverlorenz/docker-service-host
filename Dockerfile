FROM docker:dind
WORKDIR /data
RUN apk update && \
    apk add curl python3 && \
    pip3 install docker-compose
ADD . .
CMD sh start.sh
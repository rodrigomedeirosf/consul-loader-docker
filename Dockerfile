FROM alpine:3.5

RUN apk --no-cache add curl

ADD ./run.sh .
VOLUME /config

ENTRYPOINT /run.sh
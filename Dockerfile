FROM alpine:3.12

RUN apk add --no-cache curl

ADD init-c.sh /tmp/init-c.sh

RUN chmod +x /tmp/init-c.sh
ENTRYPOINT ["/tmp/init-c.sh"]
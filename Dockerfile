FROM alpine:3.10

COPY entrypoint.sh /entrypoint.sh
COPY ./template .

RUN apk update && \
    apk add curl jq

ENTRYPOINT ["/entrypoint.sh"]
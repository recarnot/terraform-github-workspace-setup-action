FROM alpine:3.10

COPY entrypoint.sh .
COPY variable.payload .
COPY workspace.payload .

RUN apk update && \
    apk add curl jq

ENTRYPOINT ["/entrypoint.sh"]
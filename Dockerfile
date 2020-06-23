FROM ubuntu

COPY entrypoint.sh /entrypoint.sh
COPY ./template .

RUN apt-get update && apt-get install -y curl jq


ENTRYPOINT ["/entrypoint.sh"]
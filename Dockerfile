FROM ubuntu

COPY entrypoint.sh /entrypoint.sh
COPY ./template .

RUN sudo apt install -y curl jq


ENTRYPOINT ["/entrypoint.sh"]
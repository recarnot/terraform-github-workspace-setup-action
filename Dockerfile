FROM ubuntu

COPY entrypoint.sh /entrypoint.sh
COPY ./template .


ENTRYPOINT ["/entrypoint.sh"]
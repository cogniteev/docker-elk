FROM kibana:4.5.1

RUN apt-get update              \
 && apt-get install -y netcat   \
 && apt-get clean               \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./docker-entrypoint.sh /

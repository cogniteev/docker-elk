FROM quay.io/cogniteev/elasticdump:0.16.1
ADD docker-entrypoint.sh /
ONBUILD ADD . /kibana-config/
ENTRYPOINT ["/docker-entrypoint.sh"]

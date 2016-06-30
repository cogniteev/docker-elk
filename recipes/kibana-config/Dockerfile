FROM quay.io/cogniteev/elasticdump:2.2
ADD docker-entrypoint.sh /
ONBUILD ADD . /kibana-config/
ENTRYPOINT ["/docker-entrypoint.sh"]

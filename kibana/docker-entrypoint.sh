#!/bin/bash

set -e

wait_es_api_started() {
  local host=$(echo "$1" | sed 's@^.*://\([^:]*\):.*@\1@')
  local port=$(echo "$1" | sed 's@^.*://[^:]*:\(.*\)@\1@')
  while ! nc -z -q 1 "$host" "$port" ; do
    sleep 1
  done
}

wait_es_index() {
  for i in `seq 60` ; do
    if wget -qO- "$1/_cat/indices" 2>/dev/null | \
             grep -q " open $2" ; then
      return 0
    fi
      echo >&2 "Waiting for $2 Elasticsearch index"
    sleep 1
  done
  return 1
}

# Add kibana as command if needed
if [[ "$1" == -* ]]; then
	set -- kibana "$@"
fi

# Run as user "kibana" if the command is "kibana"
if [ "$1" = 'kibana' ]; then
	if [ "$ELASTICSEARCH_URL" -o "$ELASTICSEARCH_PORT_9200_TCP" ]; then
		: ${ELASTICSEARCH_URL:='http://elasticsearch:9200'}
		sed -ri "s!^(elasticsearch_url:).*!\1 '$ELASTICSEARCH_URL'!" /opt/kibana/config/kibana.yml
	else
		echo >&2 'warning: missing ELASTICSEARCH_PORT_9200_TCP or ELASTICSEARCH_URL'
		echo >&2 '  Did you forget to --link some-elasticsearch:elasticsearch'
		echo >&2 '  or -e ELASTICSEARCH_URL=http://some-elasticsearch:9200 ?'
		echo >&2
	fi

  wait_es_api_started "$ELASTICSEARCH_URL"

  if ! wait_es_index "$ELASTICSEARCH_URL" .kibana-config ; then
  	echo >&2 'Fatal: .kibana-config index does not exists. Timeout error.'
    exit 1
  fi
  echo >&2 '.kibana-config Elasticsearch index is opened.'

  status=$(wget -qO- "${ELASTICSEARCH_URL}/.kibana-config/status/init?pretty=t" 2>/dev/null | \
  grep -A1 _source | grep '"status"' | cut -d: -f2 | sed 's/.*"\([^"]*\)".*/\1/')
    wget -qO- -XDELETE "${ELASTICSEARCH_URL}/.kibana-config" >/dev/null 2>&1
  if [ "x$status" != xsuccess ] ;then
    echo >&2 ".kibana index initialization failed. Abort!"
    exit 1
  fi
  set -- gosu kibana "$@"
fi

exec "$@"

#!/bin/sh

function loadProperties {
  echo '==> Loading properties'
	curl  --output /dev/null -sX PUT --data-binary @/config/consul.properties http://$CONSUL_URL:$CONSUL_PORT/v1/kv/config/${APPLICATION_NAME}/data
  echo '==> Consul properties loaded'
}

function waitConsul {
    echo '==> Wait consul scale up...'
    until $(curl --output /dev/null --silent --fail http://$CONSUL_URL:$CONSUL_PORT/v1/health/state/critical); do
        echo 'Trying to contact the consul agent...'
        sleep 1
    done
    echo '==> Consul is running'
}

echo "----------------------------------------------------------------------
    Starting Consul Loader
    Consul UI: http://$CONSUL_URL:$CONSUL_PORT/ui/#/dc1/kv/config/
    Application: ${APPLICATION_NAME}
----------------------------------------------------------------------"

waitConsul
loadProperties

echo '==> Finishing Consul Loader'
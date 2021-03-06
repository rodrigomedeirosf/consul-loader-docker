#!/bin/sh

function loadProperties {
  echo '==> Loading properties'
	curl --request PUT \
     --data-binary @/config/consul.properties \
     http://$CONSUL_URL:$CONSUL_PORT/v1/kv/config/${APPLICATION_NAME}/data
  echo '==> Consul properties loaded'
}

function waitConsul {
    echo '==> Wait consul healtly'
    while true; do
        echo 'Trying to contact the consul agent...'
        result=$(curl -s http://$CONSUL_URL:$CONSUL_PORT/v1/health/state/critical)
        if [ $? ] && [ "$result" = "[]" ]; then
            break;
        fi
        sleep 1
    done
    echo '==> Consul is running'
}

echo "----------------------------------------------------------------------"
echo "    Starting Consul Loader
    Consul UI: http://$CONSUL_URL:$CONSUL_PORT/ui/#/dc1/kv/config/
    Application: ${APPLICATION_NAME}"
echo "----------------------------------------------------------------------"

waitConsul
loadProperties

echo '==> Finishing Consul Loader'

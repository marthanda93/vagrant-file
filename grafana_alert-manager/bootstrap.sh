sudo apt-get -y update
DEBIAN_FRONTEND=noninteractive sudo apt-get install prometheus prometheus-node-exporter prometheus-pushgateway prometheus-alertmanager net-tools jq -y

sudo systemctl enable prometheus
sudo systemctl start prometheus

sudo ufw allow 9090/tcp

# Grafana setup
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

sudo apt-get -y update
sudo apt-get install grafana -y

sudo systemctl enable grafana-server
sudo systemctl start grafana-server

sleep 30

if [ $(systemctl is-active grafana-server) != "active" ]; then
    sleep 30
fi

curl --user admin:admin 'http://localhost:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"Prometheus","type":"prometheus","url":"http://localhost:9090","access":"proxy","basicAuth":false}'

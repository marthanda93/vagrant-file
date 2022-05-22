sudo apt-get -y update
DEBIAN_FRONTEND=noninteractive sudo apt-get install prometheus prometheus-node-exporter prometheus-pushgateway prometheus-alertmanager -y

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
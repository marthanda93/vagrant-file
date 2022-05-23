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


# 10180
# 14513
# 6287
# 1860


grafana_cred="admin:admin"

curl -u "$grafana_cred" 'http://localhost:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"Prometheus","type":"prometheus","url":"http://localhost:9090","access":"proxy","basicAuth":false}'
# json_object=$(curl -s -k -u "admin:admin" http://192.168.56.10:3000/api/gnet/dashboards/10180 -H 'accept: application/json' | jq .json)


# grafana_host="http://localhost:3000"
# grafana_cred="admin:admin"
# grafana_datasource="Prometheus"
# ds=(14513);
# for d in "${ds[@]}"; do
#   echo -n "Processing $d: "
#   j=$(curl -s -k -u "$grafana_cred" $grafana_host/api/gnet/dashboards/$d -H 'accept: application/json' | jq .json)
#   curl -u "$grafana_cred" $grafana_host/api/dashboards/import \
#     -H 'accept: application/json, text/plain, */*' \
#     -H 'content-type: application/json' \
#     --data-raw "{\"dashboard\":$j,\"overwrite\":true, \
#         \"inputs\":[{\"name\":\"DS_PROMETHEUS\",\"type\":\"datasource\", \
#         \"pluginId\":\"prometheus\",\"value\":\"$grafana_datasource\"}]}" \
#     --compressed \
#     --insecure; echo ""
# done


# curl -u "admin:admin" 'http://192.168.56.10:3000/api/dashboards/import' \
#   -H 'accept: application/json, text/plain, */*' \
#   -H 'content-type: application/json' \
#   --data-raw $'{"dashboard":{"__inputs":[{"name":"DS_PROMETHEUS",
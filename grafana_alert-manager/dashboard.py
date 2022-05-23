import requests
import json

def download_dashboard(url, gid):
    headers = {
        'accept': 'application/json',
    }

    response = requests.get("http://{}/api/gnet/dashboards/{}".format(url, gid), headers=headers, verify=False, auth=('admin', 'admin'))

    json_data = json.loads(response.text)
    json_data = json_data['json'] if "json" in json_data else json_data
    
    json_data = {"dashboard": json_data, "folderId": 0, "overwrite": True, "inputs": [{"name": "DS_PROMETHEUS", "type": "datasource", "pluginId": "prometheus", "value": "Prometheus"}]}

    return json_data

def import_dashboard(url, json_data):
    url = "http://{}/api/dashboards/import".format(url)
    payload = json.dumps(json_data)

    headers = {
      'accept': 'application/json, text/plain, */*',
      'content-type': 'application/json'
    }

    response = requests.request("POST", url, headers=headers, data=payload, verify=False, auth=('admin', 'admin'))

    print(response.text)

url = "192.168.56.10:3000"

for gid in ['10180' ,'14513' ,'6287' ,'1860']:
    json_data = download_dashboard(url, gid)
    import_dashboard(url, json_data)
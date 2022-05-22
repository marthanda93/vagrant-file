apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y install python3 python3-pip python3-dev python3-setuptools python3-venv libffi-dev

cd /opt
python3 -m venv alerta
/opt/alerta/bin/pip install --upgrade pip wheel

/opt/alerta/bin/pip install alerta-server alerta pymongo
# https://github.com/alerta/alerta-contrib/tree/master/plugins/sns
/opt/alerta/bin/pip install git+https://github.com/alerta/alerta-contrib.git#subdirectory=plugins/sns

cat >>/etc/profile.d/alerta.sh <<EOF
PATH=$PATH:/opt/alerta/bin
EOF

cat >/etc/alertad.conf <<EOF
AUTH_REQUIRED = False
DEBUG = True
TESTING = True
SECRET_KEY = '$(< /dev/urandom tr -dc A-Za-z0-9_\!\@\#\$\%\^\&\*\(\)-+= | head -c 32)'
PLUGINS = ['reject', 'blackout', 'sns', 'heartbeat']
ADMIN_ROLES = ['delivery','dev_admins']
JSON_AS_ASCII = False
JSON_SORT_KEYS = True
JSONIFY_PRETTYPRINT_REGULAR = True
DELETE_EXPIRED_AFTER = 0
DELETE_INFO_AFTER = 0
DEFAULT_EXPIRED_DELETE_HRS = 0
DEFAULT_INFO_DELETE_HRS = 0
HEARTBEAT_EVENTS = ['Heartbeat', 'Watchdog']
ALERT_TIMEOUT = 14400  # 12 hours
HEARTBEAT_TIMEOUT = 7200
DATABASE_URL = 'mongodb://127.0.0.1:27017/?connectTimeoutMS=300000'
DATABASE_NAME = 'monitoring'
DATABASE_RAISE_ON_ERROR = False
MONGO_USERNAME = 'vagrant'
MONGO_PASSWORD = 'vagrant'
CORS_ALLOW_HEADERS = ['Content-Type', 'Authorization', 'Access-Control-Allow-Origin']
CORS_ORIGINS = [
    'http://localhost'
]
ALLOWED_ENVIRONMENTS = ['Production', 'Development']
ALERTA_DEFAULT_PROFILE = 'Production'
AWS_ACCESS_KEY_ID = $ACCESS_KEY
AWS_SECRET_ACCESS_KEY = $SECRET_KEY
AWS_REGION = 'us-east-1'
AWS_SNS_TOPIC = 'alerta'
EOF

cat >$HOME/.alerta.conf <<EOF
[DEFAULT]
endpoint = http://localhost/api
EOF
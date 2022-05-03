apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y install python3 python3-pip python3-dev python3-setuptools python3-venv libffi-dev

cd /opt
python3 -m venv alerta
/opt/alerta/bin/pip install --upgrade pip wheel

/opt/alerta/bin/pip install alerta-server alerta pymongo

cat >>/etc/profile.d/alerta.sh <<EOF
PATH=$PATH:/opt/alerta/bin
EOF

cat >/etc/alertad.conf <<EOF
DEBUG=True
TESTING=True
SECRET_KEY='$(< /dev/urandom tr -dc A-Za-z0-9_\!\@\#\$\%\^\&\*\(\)-+= | head -c 32)'
PLUGINS=['reject', 'blackout']
JSON_AS_ASCII=False
JSON_SORT_KEYS=True
JSONIFY_PRETTYPRINT_REGULAR=True

DATABASE_URL = 'mongodb://127.0.0.1:27017/?connectTimeoutMS=300000'
DATABASE_NAME = 'monitoring'
DATABASE_RAISE_ON_ERROR = False
MONGO_USERNAME = 'vagrant'
MONGO_PASSWORD = 'vagrant'

AUTH_REQUIRED = False
CORS_ALLOW_HEADERS = ['Content-Type', 'Authorization', 'Access-Control-Allow-Origin']
CORS_ORIGINS = [
    'http://localhost'
]
CORS_SUPPORTS_CREDENTIALS = AUTH_REQUIRED

EMAIL_VERIFICATION = False
SMTP_HOST = 'smtp.gmail.com'
SMTP_PORT = 587
MAIL_FROM = 'devops.marthanda@gmail.com'
MAIL_TO = 'python.marthanda@gmail.com'
SMTP_USERNAME = 'devops.marthanda@gmail.com'
SMTP_PASSWORD = ''
SMTP_USE_SSL = False
SKIP_MTA = False
EMAIL_TYPE = 'text'

ALERTA_DEFAULT_PROFILE=production
EOF

cat >$HOME/.alerta.conf <<EOF
[DEFAULT]
endpoint = http://localhost/api
EOF
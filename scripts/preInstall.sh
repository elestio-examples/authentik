#set env vars
set -o allexport; source .env; set +o allexport;


AUTHENTIK_SECRET_KEY=${AUTHENTIK_SECRET_KEY:=`openssl rand -base64 36`}

cat << EOT >> ./.env

AUTHENTIK_SECRET_KEY=${AUTHENTIK_SECRET_KEY}
EOT

cat <<EOT > ./servers.json
{
    "Servers": {
        "1": {
            "Name": "local",
            "Group": "Servers",
            "Host": "172.17.0.1",
            "Port": 47601,
            "MaintenanceDB": "postgres",
            "SSLMode": "prefer",
            "Username": "postgres",
            "PassFile": "/pgpass"
        }
    }
}
EOT

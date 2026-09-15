#!/bin/bash
apt update -y
apt install squid -y
cat <<EOF > /etc/squid/squid.conf
http_port 3128
acl localnet src 0.0.0.0/0
http_access allow localnet
http_access deny all
EOF
systemctl restart squid
systemctl enable squid
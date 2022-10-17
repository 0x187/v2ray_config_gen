#!/bin/bash

read -p "Enter -IR- server address: " IR_SERVER

# Gather host information
UUID=$(cat /proc/sys/kernel/random/uuid)
AID=10
IP=$(hostname -I | cut -d' ' -f1)
PORT=80
NETW=ws
WSPATH=/graphql

# Generate config.json
cat > config.json << conf
{
  "log": {
    "loglevel": "warning",
    "access": "/var/log/v2ray/access.log"
  },
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "vless",
      "allocate": {
        "strategy": "always"
      },
      "settings": {
        "clients": [
          {
            "id": "$UUID",
            "level": 1,
            "alterId": $AID,
            "email": "client@example.com"
          }
        ],
        "disableInsecureEncryption": true
      },
      "streamSettings": {
        "network": "$NETW",
        "wsSettings": {
          "connectionReuse": true,
          "path": "$WSPATH"
        },
        "security": "none",
        "tcpSettings": {
          "header": {
            "type": "http",
            "response": {
              "version": "1.1",
              "status": "200",
              "reason": "OK",
              "headers": {
                "Content-Type": [
                  "application/octet-stream",
                  "application/x-msdownload",
                  "text/html",
                  "application/x-shockwave-flash"
                ],
                "Transfer-Encoding": ["chunked"],
                "Connection": ["keep-alive"],
                "Pragma": "no-cache"
              }
            }
          }
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
conf



# User output
printf "SET These to your v2ray client.\n"
echo -e "\033[1;30m* IP: $IR_SERVER"
echo -e "* Port: $PORT"
echo -e "* UUID: $UUID"
echo -e "* Alter-ID: $AID"
echo -e "* Encryption: auto"
echo -e "* Network: $NETW"
echo -e "* ws path: $WSPATH"

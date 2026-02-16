#!/bin/bash
IPV6="2a09:8280:1::d4:c272:0"
UUID=$(cat config/uuid)
PUB_KEY=$(cat config/public)

echo "vless://${UUID}@[${IPV6}]:443?security=reality&encryption=none&pbk=${PUB_KEY}&headerType=none&fp=chrome&type=tcp&flow=xtls-rprx-vision&sni=${SNI}&sid=${SHORT_ID}#MyVLESS" > config/client_qr.txt
qrencode -t ansiutf8 < config/client_qr.txt
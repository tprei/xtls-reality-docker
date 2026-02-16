#!/bin/bash

CONFIG_FILE=config/config.json

#LOCKFILE for generate uuid and keys in first start
LOCKFILE=config/.lockfile
if [ ! -f $LOCKFILE ]
then

#generate uuid
echo "Generate UUID..."
/opt/xray/xray uuid > config/uuid


#generate Public & Private keys
echo "Generate public & private keys..."
/opt/xray/xray x25519 > config/keys

#Create files with Public & Private keys
awk '/Public/{print $3}' config/keys > config/public
awk '/Private/{print $3}' config/keys > config/private

UUID=$(cat config/uuid)
PRIVATE=$(cat config/private)

#set uuid in config.json
sed -i "s/%%UUID%%/${UUID}/" $CONFIG_FILE

#set private key in config.json
sed -i "s/%%PRIVATE%%/${PRIVATE}/" $CONFIG_FILE

#create lockfile
touch $LOCKFILE
fi

#set SNI and SHORT_ID (these change on every start)
sed -i "s|%%SNI%%|${SNI}|g" $CONFIG_FILE
sed -i "s|%%SHORT_ID%%|${SHORT_ID}|g" $CONFIG_FILE

#run proxy
echo "XTLS reality starting..."
/opt/xray/xray run -config $CONFIG_FILE

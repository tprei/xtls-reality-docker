#!/bin/bash

CONFIG_DIR=config
CONFIG_FILE=$CONFIG_DIR/config.json
TEMPLATE_FILE=config.template.json

# Copy template to config directory if config doesn't exist (volume mount scenario)
if [ ! -f $CONFIG_FILE ]; then
    echo "Copying config template to volume..."
    cp $TEMPLATE_FILE $CONFIG_FILE
fi

#LOCKFILE for generate uuid and keys in first start
LOCKFILE=$CONFIG_DIR/.lockfile
if [ ! -f $LOCKFILE ]
then

#generate uuid
echo "Generate UUID..."
/opt/xray/xray uuid > $CONFIG_DIR/uuid


#generate Public & Private keys
echo "Generate public & private keys..."
/opt/xray/xray x25519 > $CONFIG_DIR/keys

#Create files with Public & Private keys
awk '/Public/{print $3}' $CONFIG_DIR/keys > $CONFIG_DIR/public
awk '/Private/{print $3}' $CONFIG_DIR/keys > $CONFIG_DIR/private

UUID=$(cat $CONFIG_DIR/uuid)
PRIVATE=$(cat $CONFIG_DIR/private)

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

#!/bin/bash
echo "Address: ${FLY_APP_NAME}.fly.dev"
echo "UUID: $(cat config/uuid)"
echo "Public key: $(cat config/public)"
echo "SNI: ${SNI}"
echo "ShortID: ${SHORT_ID}"
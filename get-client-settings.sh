#!/bin/bash
echo "Address: [2a09:8280:1::d4:c272:0]:443"
echo "UUID: $(cat config/uuid)"
echo "Public key: $(cat config/public)"
echo "SNI: ${SNI}"
echo "ShortID: ${SHORT_ID}"
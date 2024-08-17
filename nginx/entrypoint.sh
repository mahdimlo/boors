#!/bin/bash

if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
    echo "ERROR: USERNAME and PASSWORD environment variables are required"
    exit 1
fi

htpasswd -cb /etc/nginx/.htpasswd "$USERNAME" "$PASSWORD"

exec nginx -g 'daemon off;'

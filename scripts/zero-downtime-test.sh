#!/bin/bash


#!/bin/bash

URL="http://localhost:8080/api/health"

SUCCESS=0
HTTP_ERROR=0
CONNECTION_ERROR=0
TOTAL=0

echo "Starting Kubernetes zero-downtime traffic test..."
echo "Target: $URL"

while true; do
    TOTAL=$((TOTAL + 1))

    HTTP_CODE=$(curl -sS -o /dev/null \
        -w "%{http_code}" \
        --connect-timeout 2 \
        --max-time 5 \
        "$URL" 2>/dev/null)

    if [[ "$HTTP_CODE" =~ ^2[0-9][0-9]$ ]]; then
        SUCCESS=$((SUCCESS + 1))
    elif [[ "$HTTP_CODE" =~ ^[0-9]{3}$ ]]; then
        HTTP_ERROR=$((HTTP_ERROR + 1))
    else
        CONNECTION_ERROR=$((CONNECTION_ERROR + 1))
    fi

    echo "TOTAL=$TOTAL SUCCESS=$SUCCESS HTTP_ERROR=$HTTP_ERROR CONNECTION_ERROR=$CONNECTION_ERROR"

    sleep 1
done

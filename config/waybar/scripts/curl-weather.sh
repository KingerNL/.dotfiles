#!/bin/bash

# Test script for API access

USERNAME="mart.veldkamp@upcmail.nl"
PASSWORD="aQ=x}'Rsj!pk28*"
BASE_URL="https://api.satellietdataportaal.nl/v2/stac"

echo "Testing API access with different methods..."
echo "=========================================="

# Method 2: Using netrc file
echo -n "Method 2 (netrc file)... "
echo "machine api.satellietdataportaal.nl login $USERNAME password $PASSWORD" > /tmp/netrc
curl -s -o /tmp/response2.txt -w "%{http_code}" \
  -X 'GET' \
  "$BASE_URL/collections" \
  -H 'accept: application/json' \
  --netrc-file /tmp/netrc
echo " done"

# Check responses
echo -e "\nResponse codes saved. Check:"
echo "cat /tmp/response1.txt"
echo "cat /tmp/response2.txt"

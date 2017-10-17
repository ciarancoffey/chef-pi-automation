#!/usr/bin/env bash
DNS_ID=$(curl -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$TARGET_DNS"  -H "Content-Type:application/json" -H "X-Auth-Key:$X_AUTH_KEY" -H "X-Auth-Email:$X_AUTH_EMAIL" | jq '.["result"][0]["id"]' -r)
EXTERNAL_IP=$(curl httpbin.org/ip | jq '.["origin"]' -r)
curl -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_ID" \
 -H "Content-Type:application/json"\
 -H "X-Auth-Key:$X_AUTH_KEY"\
 -H "X-Auth-Email:$X_AUTH_EMAIL" \
--data '{"type":"A","name":"'$TARGET_DNS'","content":"'$EXTERNAL_IP'","ttl":120,"proxied":false}'

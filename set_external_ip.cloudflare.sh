#!/usr/bin/env bash
#  Set the external IP on cloudflare dns, dyndns style,
#  using the current external (ipv4) address.
#
#  Requires jq
#
#  This will require some environment variables to be set:
#  TARGET_DNS:  FQDN of the dns record we wish to update
#  ZONE_ID:     The zone_id, the corresponds to the domain.
#  X_AUTH_KEY:  The Global API Key
#  X_AUTH_EMAIL:email associated with cloudflare account 
#
#  More details available here:
#  https://api.cloudflare.com/#getting-started-requests
DNS_ID=$(curl -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID\
	/dns_records?name=$TARGET_DNS" \
	-H "Content-Type:application/json" \
	-H "X-Auth-Key:$X_AUTH_KEY" \
	-H "X-Auth-Email:$X_AUTH_EMAIL" \ | jq '.["result"][0]["id"]' -r)
EXTERNAL_IP=$(curl httpbin.org/ip | jq '.["origin"]' -r)
curl -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID\
	/dns_records/$DNS_ID" -H "Content-Type:application/json"\ 
	-H "X-Auth-Key:$X_AUTH_KEY"\ -H "X-Auth-Email:$X_AUTH_EMAIL" \
        --data '{"type":"A","name":"'$TARGET_DNS'",\
	"content":"'$EXTERNAL_IP'","ttl":120,"proxied":false}'

#/bin/sh
apk add --no-cache curl;
curl -o /usr/local/bin/certbot-hook.sh "${ACME_DNS_HOOK_URL}" > /dev/null;
chmod 0700 /usr/local/bin/certbot-hook.sh;

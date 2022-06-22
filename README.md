# Docker local development using Caddy as a reverse proxy with HTTPS enabled for local domains.

Navigate:
- [Demo installation](#add-domains-to-file-etchosts)
- [Customize your setup instructions](#customize-your-existing-docker-compose-setup)

----

## Add domains to file /etc/hosts
```
127.0.0.1 dev.core.local devql.core.local db.core.local
```

## Install SSL certificates in local development:

Requires: `brew install mkcert nss`

Run the command:

```sh
sh ./install-ssl-certificates.sh
```

1. This script will create a subdirectory named "certs".
2. Then creates and installs the SSL certifications from this subdirectory into your MacOS keychain.
3. Finally, the files will be utilized by the Caddy container to serve HTTPS connections.

## Run this repo docker-compose setup to see the demo:
```sh
docker-compose up -d

open "https://dev.core.local"

open "https://devql.core.local"
```

----

## Customize your existing docker-compose setup:


This requires the **Caddyfile** - Here is a sample with a host & SSL certificate files:
```nginx
# host name will route to the magento container listening on port 80:

dev.core.local {
	tls "/data/certs/local.cert.pem" "/data/certs/local.key.pem"
	reverse_proxy magento:80
}
```

Note: This file is copied into the Caddy container on build.


The following are the necessary lines to add to your existing docker-compose file:
```yaml
version: '3.8'

services:
    # Reverse proxy using Caddy to route traffic to containers.
    # See Caddyfile to configure subdomains to each container.       
    reverse-proxy:
        image: caddy/caddy:2-alpine
        container_name: reverse-proxy
        restart: unless-stopped
        ports:
            - "80:80"
            - "443:443"
        volumes:
        - caddy_data:/data
        - caddy_config:/config
        - $PWD/Caddyfile:/etc/caddy/Caddyfile
        - $PWD/certs:/data/certs

     # Below this line you will have your existing or new containers to your docker setup.

     # .....

     # All containers above this line.

volumes:
  caddy_data:
  caddy_config:
```

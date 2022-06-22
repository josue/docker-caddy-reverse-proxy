#!/bin/sh

# parameters
DOMAIN=${1:-"core.local"}
DOMAIN_URL="https://dev.${DOMAIN}"
CERTS_DIR="certs"
CERT_PEM_FILE="${CERTS_DIR}/local.cert.pem"
KEY_PEM_FILE="${CERTS_DIR}/local.key.pem"

# first ensure required executables exists:
if [[ `which mkcert` == "" ]] || [[ `brew ls --versions nss` == "" ]]; then
    echo "Requires: mkcert & nss"
    echo
    echo "Run: brew install mkcert nss"
    exit 1
fi

# finally install certificates
echo "-- Installing mkcert ..."
mkcert -install

mkdir -p ${CERTS_DIR}

echo "-- Creating and installing local SSL certificates for domain: ${DOMAIN} + *.${DOMAIN} ..."
mkcert -cert-file ${CERT_PEM_FILE} -key-file ${KEY_PEM_FILE} "${DOMAIN}" "*.${DOMAIN}"

echo "-- Complete!"
echo
echo "- Now you can run: docker-compose up"
echo "- Open browser to domain: ${DOMAIN_URL}"
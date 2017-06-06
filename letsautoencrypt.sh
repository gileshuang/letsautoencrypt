#!/bin/bash

INS_DIR=$(dirname $0)

if [[ -f "${INS_DIR}/env.conf" ]]; then
	source ${INS_DIR}/env.conf
fi
if [[ -f "/etc/letsautoencrypt/env.conf" ]]; then
	source /etc/letsautoencrypt/env.conf
fi
export PATH=${INS_DIR}:${PATH}

## Set variates
if [[ -z ${DATA_DIR} ]]; then
	DATA_DIR=/var/lib/letsautoencrypt
fi
#if [[ -z ${ACCOUNT_EMAIL} ]]; then
#	ACCOUNT_EMAIL="webmaster@example.org"
#fi
if [[ -z ${ACCOUNT_KEY} ]]; then
	ACCOUNT_KEY=${DATA_DIR}/account.key
fi
if [[ -z ${DOMAIN_KEY} ]]; then
	DOMAIN_KEY=${DATA_DIR}/domain.key
fi
if [[ -z ${DOMAIN_CSR} ]]; then
	DOMAIN_CSR=${DATA_DIR}/domain.csr
fi
if [[ -z ${CHALLENGE_DIR} ]]; then
	CHALLENGE_DIR=${DATA_DIR}/acme-challenge/
	mkdir -p ${CHALLENGE_DIR}
	chmod 750 ${CHALLENGE_DIR}
fi

## Prepare account.key
openssl genrsa -out ${ACCOUNT_KEY} 4096
chmod 640 ${ACCOUNT_KEY}

## Prepare domain.csr
openssl genrsa -out ${DOMAIN_KEY} 4096
chmod 640 ${DOMAIN_KEY}
openssl req -new -sha256 -key domain.key -subj "/" -reqexts SAN \
	-out ${DOMAIN_CSR} -config <(cat /etc/ssl/openssl.cnf <(
		echo '[SAN]'
		echo "subjectAltName=${SubjectAltName}"
	)
)

## Prepare nginx acme-challenge default config.
if [[ -f "${INS_DIR}/acme-challenge.conf" ]]; then
	mkdir -p /etc/nginx
	cp -f ${INS_DIR}/acme-challenge.conf ${NGINX_INCLUDE_CONF}
	sed -i "s#%CHALLENGE_DIR%#${CHALLENGE_DIR}#" ${NGINX_INCLUDE_CONF}
fi
mkdir -p ${DATA_DIR}/ssl
acme.sh --signcsr --csr ${DOMAIN_CSR} -w ${CHALLENGE_DIR} \
	--cert-file ${DATA_DIR}/ssl/cert.pem \
	--key-file ${DATA_DIR}/ssl/key.pem \
	--ca-file ${DATA_DIR}/ssl/ca.pem \
	--fullchain-file ${DATA_DIR}/ssl/fullchain.pem


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
mkdir -p ${DATA_DIR}
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
if [[ ! -f "${ACCOUNT_KEY}" ]]; then
	openssl genrsa -out ${ACCOUNT_KEY} 4096
fi
chmod 640 ${ACCOUNT_KEY}

## Prepare domain.csr
if [[ ! -f "${DOMAIN_KEY}" ]]; then
	openssl genrsa -out ${DOMAIN_KEY} 4096
fi
chmod 640 ${DOMAIN_KEY}

openssl req -new -sha256 -key ${DOMAIN_KEY} -subj "/" -reqexts SAN \
	-out ${DOMAIN_CSR} -config <(cat /etc/ssl/openssl.cnf <(
		echo '[SAN]'
		echo "subjectAltName=${SubjectAltName}"
	)
)

## Prepare nginx acme-challenge default config.
FIRST_DOMAIN=$(echo ${SubjectAltName} | \
	awk -F ',' '{print $1}' | \
	awk -F ':' '{print $2}')
if [[ -f "${INS_DIR}/acme-challenge.conf" ]]; then
	mkdir -p /etc/nginx
	sed -e "s#%FIRST_DOMAIN%#${FIRST_DOMAIN}#g" \
		-e "s#%DATA_DIR%#${DATA_DIR}#g" \
		-e "s#%CHALLENGE_DIR%#${CHALLENGE_DIR}#g" \
		${INS_DIR}/acme-challenge.conf > ${NGINX_INCLUDE_CONF}
fi
if [[ ! -f "${DATA_DIR}/acme/${FIRST_DOMAIN}/fullchain.cer" ]]; then
	touch ${DATA_DIR}/acme/${FIRST_DOMAIN}/fullchain.cer
fi
FILE_SERVER_PID=0
if [[ -z $(ss -ltnp | grep -P ':80\s') ]]; then
	file-server.elf -dir "/.well-known/acme-challenge/:${CHALLENGE_DIR}/.well-known/acme-challenge/" -http ":80" &
	FILE_SERVER_PID=$!
elif [[ -n $(systemctl list-units --no-pager | grep nginx | grep running) ]]; then
	systemctl reload nginx || RELOAD_STAT=1
	if [[ ${RELOAD_STAT} -eq 1 ]]; then
		echo "ERROR: nginx reload failed"
	fi
else
	echo "ERROR: No supported http server found."
	echo "This script only support nginx(via systemd)."
	echo "If you do not use nginx, please stop all http server which listening port 80. This script will start an integrated http file server."
	exit 1
fi

## Sign certs
mkdir -p ${DATA_DIR}/acme
acme.sh --home ${DATA_DIR}/acme --signcsr --csr ${DOMAIN_CSR} \
	-w ${CHALLENGE_DIR}

if [[ ${FILE_SERVER_PID} -ne 0 ]]; then
	kill ${FILE_SERVER_PID}
	sleep 1
fi


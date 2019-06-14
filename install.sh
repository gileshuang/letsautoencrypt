#!/bin/bash

REPO_DIR=$(dirname $0)

wget https://raw.githubusercontent.com/Neilpang/acme.sh/master/acme.sh -O ${REPO_DIR}/acme.sh
wget https://github.com/gileshuang/go-simple-httpd/releases/download/v0.1/go-simple-httpd.x86_64.elf -O ${REPO_DIR}/go-simple-httpd.elf

mkdir -p /etc/letsautoencrypt
mkdir -p /usr/lib/letsautoencrypt
mkdir -p usr/share/licenses/letsautoencrypt
install -Dm644 ${REPO_DIR}/env.conf /etc/letsautoencrypt/env.conf
install -Dm644 ${REPO_DIR}/env.conf /usr/lib/letsautoencrypt/env.conf
install -Dm644 ${REPO_DIR}/https-acme.conf /etc/letsautoencrypt/https-acme.conf.example
install -Dm644 ${REPO_DIR}/https-acme.conf /usr/lib/letsautoencrypt/https-acme.conf
install -Dm755 ${REPO_DIR}/acme.sh /usr/lib/letsautoencrypt/acme.sh
install -Dm755 ${REPO_DIR}/letsautoencrypt.sh /usr/lib/letsautoencrypt/letsautoencrypt.sh
install -Dm755 ${REPO_DIR}/go-simple-httpd.elf /usr/lib/letsautoencrypt/go-simple-httpd.elf
install -Dm644 ${REPO_DIR}/letsautoencrypt.service /usr/lib/systemd/system/letsautoencrypt.service
install -Dm644 ${REPO_DIR}/letsautoencrypt.timer /usr/lib/systemd/system/letsautoencrypt.timer
install -Dm644 ${REPO_DIR}/LICENSE /usr/share/licenses/letsautoencrypt/LICENSE


# Let's auto encrypt

## Overview

Use acme.sh to auto sign https certs from Lets Encrypt.

## Thanks to

Related article: <https://imququ.com/post/letsencrypt-certificate.html>  
This project use script from <https://github.com/Neilpang/acme.sh>  

## Installation

### ArchLinux
``` bash
git clone https://github.com/alienhjy/letsautoencrypt.git
cd letsautoencrypt
makepkg
sudo pacman -U letsautoencrypt-*.pkg.tar.xz
```

## Usage

### For nginx

#### Step 1

Install letsautoencrypt.

#### Step 2

Edit /etc/letsautoencrypt/env.conf, add your domains to `SubjectAltName` according to the given format. Change `NGINX_INCLUDE_CONF`, and make sure `${NGINX_INCLUDE_CONF}` is under your nginx conf dir.
Edit your nginx config file, add `include https-acme.conf;` to the http sesson of nginx. Do not reload nginx now.

#### Step 3
Run:
``` bash
systemctl daemon-reload
systemctl start letsautoencrypt.service
systemctl start letsautoencrypt.timer
systemctl enable letsautoencrypt.timer
```

#### Step 4 (optional)
For update domain list, just update `SubjectAltName` in /etc/letsautoencrypt/env.conf, then:
```
systemctl start letsautoencrypt.service
```

### For other http server

#### Step 1

Stop your http server which listening port :80.

#### Step 2

Edit /etc/letsautoencrypt/env.conf, add your domains to `SubjectAltName` according to the given format.

#### Step 3

Run:
``` bash
## replace ${INSTALL_DIR} to your letsautoencrypt dir.
${INSTALL_DIR}/letsautoencrypt.sh
```

#### Step 4
Add ssl config to the config file of your http server.  
```
ssl_certificate => /var/lib/letsautoencrypt/acme/yoursite.com/fullchain.cer
ssl_certificate_key => /var/lib/letsautoencrypt/domain.key
```
Then, reload or restart your http server.

#### Step 5 (optional)
For update domain list, just stop your http server, and update `SubjectAltName` in /etc/letsautoencrypt/env.conf, then repeat step 3 and step 4.


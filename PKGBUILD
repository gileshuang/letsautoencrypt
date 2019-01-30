# $Id$
# Maintainer: Huang Jiayao <huangjiayao_1992@163.com>

pkgname=letsautoencrypt
pkgver=20190130
pkgrel=1
pkgdesc='Use acme.sh to auto sign https certs from Lets Encrypt'
url='https://github.com/gileshuang/letsautoencrypt'
license=('GPL3')
arch=('x86_64')
depends=('bash' 'openssl')
optdepends=('nginx')
source=(
	"letsautoencrypt.sh"
	"env.conf"
	"https-acme.conf"
	"letsautoencrypt.service"
	"letsautoencrypt.timer"
	"LICENSE"
	"acme.sh::https://raw.githubusercontent.com/Neilpang/acme.sh/master/acme.sh"
)
md5sums=('f1532d12d4ec451fc3b309cefe9f4a77'
         '91d34efe5a8756a43ee0bfa5a83330f1'
         '4aa8e567775795dee4785fded1a29e66'
         '932829cb1c0bbda48d94fa6ce9eb954f'
         'cd0ef8f0abadf217d379b4fdadc996c1'
         'f6ba2c567df796739913f50ea5ad7c97'
         SKIP)
md5sums_x86_64=('6fd0d4220df941e5c1268c12c021ca2b')
source_x86_64=("go-simple-httpd.elf::https://github.com/gileshuang/go-simple-httpd/releases/download/v0.1/go-simple-httpd.x86_64.elf")
backup=(
	"etc/letsautoencrypt/env.conf"
)

package() {
	install -Dm644 env.conf ${pkgdir}/etc/letsautoencrypt/env.conf
	install -Dm644 env.conf ${pkgdir}/usr/lib/letsautoencrypt/env.conf
	install -Dm644 https-acme.conf ${pkgdir}/etc/letsautoencrypt/https-acme.conf.example
	install -Dm644 https-acme.conf ${pkgdir}/usr/lib/letsautoencrypt/https-acme.conf
	install -Dm755 acme.sh ${pkgdir}/usr/lib/letsautoencrypt/acme.sh
	install -Dm755 letsautoencrypt.sh ${pkgdir}/usr/lib/letsautoencrypt/letsautoencrypt.sh
	install -Dm755 go-simple-httpd.elf ${pkgdir}/usr/lib/letsautoencrypt/go-simple-httpd.elf
	install -Dm644 letsautoencrypt.service ${pkgdir}/usr/lib/systemd/system/letsautoencrypt.service
	install -Dm644 letsautoencrypt.timer ${pkgdir}/usr/lib/systemd/system/letsautoencrypt.timer
	install -Dm644 LICENSE ${pkgdir}/usr/share/licenses/${pkgname}/LICENSE
}


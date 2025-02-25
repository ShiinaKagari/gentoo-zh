# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

MY_PV=${PV/_p/-}
DESCRIPTION="The new version of the official linux-qq"
HOMEPAGE="https://im.qq.com/linuxqq/index.shtml"
LICENSE="Tencent"
RESTRICT="strip"

_I="f947fe1d"

SRC_URI="
	amd64? ( https://dldir1.qq.com/qqfile/qq/QQNT/$_I/linuxqq_${MY_PV}_amd64.deb )
	arm64? ( https://dldir1.qq.com/qqfile/qq/QQNT/$_I/linuxqq_${MY_PV}_arm64.deb )
"

SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

IUSE="+bwrap system-vips gnome appindicator"
RDEPEND="
	x11-libs/gtk+:3
	x11-libs/libnotify
	dev-libs/nss
	appindicator? ( dev-libs/libayatana-appindicator )
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-misc/xdg-utils
	app-accessibility/at-spi2-core:2
	app-crypt/libsecret
	virtual/krb5
	sys-apps/keyutils
	system-vips? (
		dev-libs/glib
		>=media-libs/vips-8.14.2[-pdf]
	)
	bwrap? (
		sys-apps/bubblewrap
		x11-misc/snapd-xdg-open
		x11-misc/flatpak-xdg-utils
	)
	gnome? ( dev-libs/gjs )
	media-libs/openslide
"

S=${WORKDIR}

src_unpack(){
	:
}

src_install() {
	dodir /
	cd "${D}" || die
	unpacker

	if use system-vips; then
		rm -r "${D}"/opt/QQ/resources/app/sharp-lib || die
	fi

	if use bwrap; then
		exeinto /opt/QQ
		doexe "${FILESDIR}"/start.sh
		sed -i 's!/opt/QQ/qq!/opt/QQ/start.sh!' "${D}"/usr/share/applications/qq.desktop || die
		insinto /opt/QQ/workarounds
		doins "${FILESDIR}"/{config.json,xdg-open.sh}
		fperms +x /opt/QQ/workarounds/xdg-open.sh
	else
		sed -i 's!/opt/QQ/qq!/usr/bin/qq!' "${D}"/usr/share/applications/qq.desktop || die
	fi

	if use bwrap; then
		dosym -r /opt/QQ/start.sh /usr/bin/qq
	elif use system-vips; then
		newbin "$FILESDIR/qq.sh" qq
	else
		dosym -r /opt/QQ/qq /usr/bin/qq
	fi

	# https://bugs.gentoo.org/898912
	if use appindicator; then
		dosym ../../usr/lib64/libayatana-appindicator3.so /opt/QQ/libappindicator3.so
	fi

	sed -i 's!/usr/share/icons/hicolor/512x512/apps/qq.png!qq!' "${D}"/usr/share/applications/qq.desktop || die
	gzip -d "${D}"/usr/share/doc/linuxqq/changelog.gz || die
	dodoc "${D}"/usr/share/doc/linuxqq/changelog
	rm -rf "${D}"/usr/share/doc/linuxqq/ || die
}

pkg_postinst() {
	xdg_pkg_postinst
	if use bwrap ;then
		elog "If you want to download files in QQ"
		elog "Please set the QQ download path to ~/Download"
	fi
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-bin}"

inherit unpacker desktop xdg

DESCRIPTION="A Clash GUI based on tauri"
HOMEPAGE="https://github.com/zzzgydi/clash-verge"

KEYWORDS="~amd64"

SRC_URI="https://github.com/zzzgydi/${MY_PN}/releases/download/v${PV}/${MY_PN}_${PV}_amd64.deb"

LICENSE="GPL-3"
SLOT="0"
IUSE="clash clash-meta clash-premium"

REQUIRED_USE="|| ( clash clash-meta clash-premium )"

DEPEND=""
RDEPEND="
	dev-libs/libappindicator:3
	net-libs/webkit-gtk:4
	dev-libs/gobject-introspection-common
	dev-libs/openssl:0/3
	clash? ( net-proxy/clash )
	clash-meta? ( net-proxy/clash-meta )
	clash-premium? ( net-proxy/clash-premium-bin )
"
BDEPEND=""

S="${WORKDIR}"

src_install() {
	dobin usr/bin/clash-verge

	insinto /usr/lib/${MY_PN}/resources
	doins usr/lib/${MY_PN}/resources/Country.mmdb

	domenu usr/share/applications/${MY_PN}.desktop

	doicon -s 128 usr/share/icons/hicolor/128x128/apps/${MY_PN}.png
	doicon -s 256 usr/share/icons/hicolor/256x256@2/apps/${MY_PN}.png
	doicon -s 32 usr/share/icons/hicolor/32x32/apps/${MY_PN}.png
}

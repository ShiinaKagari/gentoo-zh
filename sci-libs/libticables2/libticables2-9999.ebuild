# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="Library to handle different link cables for TI calculators"
HOMEPAGE="http://lpg.ticalc.org/prj_tilp/"
SRC_URI=""

EGIT_REPO_URI="https://github.com/debrouxl/tilibs.git"

MY_PN="libticables"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc nls static-libs usb"

RDEPEND="
	dev-libs/glib:2
	usb? ( virtual/libusb:1 )
	nls? ( virtual/libintl )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S="${S}/${MY_PN}/trunk"

DOCS=( AUTHORS LOGO NEWS README ChangeLog docs/api.txt )

src_prepare() {
	cd "${S}"
	eapply_user
	eautoreconf
}

src_configure() {
	# if both libusb and libusb10 was set, libusb10 will be used.
	econf \
		--disable-rpath \
		$(use_enable debug logging) \
		$(use_enable usb libusb) \
		$(use_enable usb libusb10) \
		$(use_enable nls) \
		$(use_enable static-libs static)
}

src_install() {
	use doc && local HTML_DOCS="${S}/docs/html/*"
	default
}

pkg_postinst() {
	elog "Please read README in /usr/share/doc/${PF}"
	elog "if you encounter any problem with a link cable"
}

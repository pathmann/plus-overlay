# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson gnome2-utils xdg udev

DESCRIPTION="Control Elgato Stream Deck devices"
HOMEPAGE="https://gitlab.gnome.org/World/boatswain"
LICENSE="GPL-3"
SRC_URI="https://gitlab.gnome.org/World/${PN}/-/archive/${PV}/${P}.tar.gz"

SLOT="0"

KEYWORDS="~amd64"

RDEPEND="virtual/libusb:1
    dev-libs/hidapi:=
    dev-libs/libgusb:=
    dev-libs/libpeas:=
    dev-libs/libportal:=
    dev-libs/glib:=
    dev-libs/json-glib:=
    gui-libs/libadwaita:=
    x11-libs/pango:=
    x11-libs/gdk-pixbuf:=
    app-crypt/libsecret:=
"
DEPEND="${RDEPEND}
"

BDEPEND="
"

src_prepare() {
    sed -i "s/get_option('datadir') \/ 'appdata'/get_option('datadir') \/ 'metainfo'/" \
		    data/meson.build || die 

    default
}

src_configure() {
    meson_src_configure
}

src_install() {
    meson_src_install
    udev_dorules ${FILESDIR}/50-elgato.rules
}

pkg_postinst() {
    xdg_pkg_postinst
    gnome2_schemas_update
    udev_reload
}

pkg_postrm() {
    xdg_pkg_postrm
    gnome2_schemas_update
    udev_reload
}


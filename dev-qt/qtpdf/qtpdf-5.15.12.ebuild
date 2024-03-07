# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_MODULE="qtwebengine"
inherit qt5-build

DESCRIPTION="Classes and functions for rendering PDF documents"

KEYWORDS="~amd64"

IUSE=""

RDEPEND="dev-libs/glib:2
	=dev-qt/qtcore-${QT5_PV}*:5=
	=dev-qt/qtgui-${QT5_PV}*:5=
	=dev-qt/qtnetwork-${QT5_PV}*:5=
	media-libs/freetype
	media-libs/harfbuzz:=
	media-libs/lcms:2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	sys-libs/zlib[minizip]
"

DEPEND="${RDEPEND}
"

BDEPEND="
	dev-build/ninja
"

src_configure() {
	export NINJA_PATH=/usr/bin/ninja

	local myqmakeargs=(
		--
		-no-build-qtwebengine-core
	)

	qt5-build_src_configure
}

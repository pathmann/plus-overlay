# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake vcs-snapshot

MY_PV="de7c88d" # linphone-sdk-5.2.59 points to this commit

DESCRIPTION="C++ library implementing Open Whisper System Signal protocol"
HOMEPAGE="https://gitlab.linphone.org/BC/public/lime"
SRC_URI="https://gitlab.linphone.org/BC/public/${PN}/-/archive/${MY_PV}/${PN}-${MY_PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc static-libs test"
RESTRICT="test" # fail: segfault

RDEPEND="dev-db/soci[sqlite]
	net-libs/bctoolbox[test?]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( dev-libs/belle-sip )"

src_configure() {
	local mycmakeargs=(
		-DENABLE_STATIC="$(usex static-libs)"
		-DENABLE_UNIT_TESTS="$(usex test)"
	)

	cmake_src_configure
}

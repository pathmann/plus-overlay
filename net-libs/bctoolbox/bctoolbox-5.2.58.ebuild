# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Utilities library used by Belledonne Communications softwares"
HOMEPAGE="https://gitlab.linphone.org/BC/public/bctoolbox"
SRC_URI="https://gitlab.linphone.org/BC/public/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="ssl static-libs test"
PROPERTIES="test_network"
RESTRICT="!test? ( test )"

RDEPEND="ssl? ( net-libs/mbedtls )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	test? ( dev-util/bcunit )"

src_configure() {
	local mycmakeargs=(
		-DENABLE_POLARSSL=OFF
		-DENABLE_MBEDTLS="$(usex ssl)"
		-DENABLE_STATIC="$(usex static-libs)"
		-DENABLE_TESTS_COMPONENT="$(usex test)"
		-DENABLE_TESTS="$(usex test)"
		-DENABLE_STRICT=OFF # otherwise compile will fail because of -Werror=unused-parameter
	)

	cmake_src_configure
}

src_test() {
	"${S}"_build/tester/bctoolbox_tester || die "tests failed"

	cmake_src_test
}

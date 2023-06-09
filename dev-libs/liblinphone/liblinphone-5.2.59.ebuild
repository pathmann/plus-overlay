# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit cmake python-r1

DESCRIPTION="SIP library supporting voice/video calls and text messaging"
HOMEPAGE="https://gitlab.linphone.org/BC/public/liblinphone"
SRC_URI="https://gitlab.linphone.org/BC/public/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug doc ldap libnotify static-libs test tools qrcode"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="dev-cpp/belr
	dev-cpp/xsd
	dev-db/sqlite:3
	dev-db/soci
	dev-libs/belcard
	dev-libs/belle-sip
	dev-libs/jsoncpp:0=
	dev-libs/libxml2:2
	dev-libs/lime
	dev-libs/xerces-c
	net-libs/bctoolbox[test?]
	net-libs/ortp
	media-libs/mediastreamer2[zrtp,srtp,jpeg]
	sys-libs/zlib:0
	virtual/libiconv
	virtual/libintl
	virtual/libudev
	qrcode? ( media-libs/zxing-cpp )
	tools? ( ${PYTHON_DEPS}
		dev-python/pystache[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	app-doc/doxygen[dot]
	dev-python/pystache[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-vcs/git
	virtual/pkgconfig
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/"${P}"-jsoncpp-cmake.patch
	"${FILESDIR}"/"${P}"-remove-jsoncpp_static.patch
)

src_prepare() {
	# QnD fix: incapability to detect jsoncpp
	sed -i '/json\/json.h/s|<|<jsoncpp/|' src/FlexiAPIClient.cc \
		include/linphone/FlexiAPIClient.hh \
		tester/{flexiapiclient-tester,remote-provisioning-tester}.cpp \
		|| die "sed failed for FlexiAPIClient"
	sed -i 's/jsoncpp_object/jsoncpp/' {src,tester}/CMakeLists.txt \
		|| die "sed failed for src/CMakeLists.txt and tester/CMakeLists.txt"
	sed -i 's/set(CMAKE_CXX_STANDARD 14)/set(CMAKE_CXX_STANDARD 17)/' CMakeLists.txt \
	  || die "sed failed to update to C++ 17" # otherwise compilation will fail for some ZXing functions

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_ASSISTANT=YES
		-DENABLE_DEBUG_LOGS="$(usex debug)"
		-DENABLE_DOC="$(usex doc)"
		-DENABLE_FLEXIAPI=YES
		-DENABLE_LDAP="$(usex ldap)"
		-DENABLE_LIME=NO
		-DENABLE_NOTIFY="$(usex libnotify)"
		-DENABLE_STATIC="$(usex static-libs)"
		-DENABLE_TOOLS="$(usex tools)"
		-DENABLE_UNIT_TESTS="$(usex test)"
		-DENABLE_QRCODE="$(usex qrcode)"
		-DENABLE_STRICT=NO # otherwise compilation will fail due to -Werror=unused-function
	)

	cmake_src_configure
}

src_test() {
	"${S}"_build/tester/liblinphone_tester \
		--resource-dir "${S}"/tester/ \
		|| die "tests failed"

	cmake_src_test
}

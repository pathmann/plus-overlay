# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit meson python-single-r1 gnome2-utils xdg

DESCRIPTION="Chit-chat with an AI"
HOMEPAGE="https://bavarder.codeberg.page/"
LICENSE="GPL-3"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/Bavarder-${PV}"

SLOT="0"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="~amd64"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/baichat-py[${PYTHON_USEDEP}]
		dev-python/googlebardpy[${PYTHON_USEDEP}]
		dev-python/markdown[${PYTHON_USEDEP}]
		dev-python/openai[${PYTHON_USEDEP}]
		dev-python/pymdown-extensions[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
"
# text-generation is mentioned in requirements.txt but not used (yet?), so leave it out for now

DEPEND="${RDEPEND}"

BDEPEND="
	$(python_gen_cond_dep '
		>=dev-util/blueprint-compiler-0.8.1[${PYTHON_SINGLE_USEDEP}]
	')
"

src_prepare() {
	sed -i "s/join_paths(get_option('datadir'), 'appdata')/join_paths(get_option('datadir'), 'metainfo')/" \
		data/meson.build || die
	sed -i "s/'r-xr--r--'/'r-xr--r-x'/" \
		src/meson.build || die

	default
}

src_configure() {
	meson_src_configure
}

src_install() {
	meson_src_install
	python_fix_shebang "${ED}"/usr/bin
	python_optimize
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}

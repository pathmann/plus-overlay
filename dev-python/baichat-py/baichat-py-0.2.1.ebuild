# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1

DESCRIPTION="Python wrapper for BAI Chat"
HOMEPAGE="https://github.com/Bavarder/baichat-py"
SRC_URI="https://github.com/Bavarder/${PN}/archive/refs/tags/v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
    $(python_gen_cond_dep '
        >=dev-python/aiohttp-3.8.4[${PYTHON_USEDEP}]
        >=dev-python/requests-2.29.0[${PYTHON_USEDEP}]
    ')
"

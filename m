From: Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH v2 05/12] hwrng: bcm2835-rng: Use device managed helpers
Date: Wed, 08 Nov 2017 10:24:11 -0800
Message-ID: <87mv3wy6gk.fsf@anholt.net>
References: <20171108004449.32730-1-f.fainelli@gmail.com> <20171108004449.32730-6-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer\:BROADCOM BCM281XX\/BCM11XXX\/BCM216XX ARM ARCHITE..."
        <bcm-kernel-feedback-list@broadcom.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        "open list\:HARDWARE RANDOM NUMBER GENERATOR CORE"
To: Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171108004449.32730-6-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain

Florian Fainelli <f.fainelli@gmail.com> writes:

> Now that we have moved the RNG disabling into a hwrng::cleanup callback,
> we can use the device managed registration operation and remove our
> remove callback since it won't do anything necessary.

3-5 are:

Reviewed-by: Eric Anholt <eric@anholt.net>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAloDS8sACgkQtdYpNtH8
nug/QBAAi6qnYBT9amukq4t/8qkT+TZyp8Wc7+ps8tcTRp78LJg9qK5vFS+df2Q6
gSlR+tzxcKHlT3ozqmiJurxWkhG20nkV7Yp74aT2eRNqJufi+n20TD3m9ElY9cPQ
GaTSFp6iqlzaUozBhhEe25HglZuDqBqFzebnuF2xJiQT94hENvxzkhcFG2o6cZjO
cQYQePeJoFv79kzrPw0aI22VHtEb8lzWxltFd07hAcI1SRVjcxtYA11gaGXivKRz
bDLEmrxdeUV0sOl66+9chAsexp5X2Z8D8xh0d0xClQSlM6DhFqsnIonwMt/MbUrs
QKV+gCpznpQs8Mt+3FdAL2h251Z/G5DeFDNOYIhSOtgveXPYyKPUiNb/WR/4BB/F
GSl/OD+QrzSR9vz0LMyK9BbcRI+29F+2utZrKssRNi/sknOBr6weDLVNPseZKJj/
VsVuE94OWrbn1RBcdKblo5TEIrXovcGf4bxkWvl5buB4l+KFL8BD9G2zab6xH0Na
5fc5XLF2kx+qbq78o6xZKiClkjc/wVxYz4CbLe9orcWMK0WrWsXs1LXFTuRhMdNN
E/58wdqJrvKMC9Cqm5hZRghvR9nFwHHn2bgMi1EqMejpANwNtfJy6cscPAzfb1vl
KGDtVSf7/apus7cY2Q28XTpBgzlxcq6l7lncqknDb6NkfOSycZo=
=ZIBo
-----END PGP SIGNATURE-----
--=-=-=--

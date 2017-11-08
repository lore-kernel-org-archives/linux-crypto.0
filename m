From: Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH v2 12/12] hwrng: bcm63xx-rng: Remove since bcm2835-rng takes over
Date: Wed, 08 Nov 2017 10:36:53 -0800
Message-ID: <87bmkcy5ve.fsf@anholt.net>
References: <20171108004449.32730-1-f.fainelli@gmail.com> <20171108004449.32730-13-f.fainelli@gmail.com>
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
In-Reply-To: <20171108004449.32730-13-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain

Florian Fainelli <f.fainelli@gmail.com> writes:

> bcm2835-rng is now capable of supporting the BCM63xx hardware, so remove
> the driver which duplicates the same functionality.
>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Assuming Stefan's testing says that the .name handling you settled on
works, patches 9, 11, 12 are:

Reviewed-by: Eric Anholt <eric@anholt.net>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAloDTsUACgkQtdYpNtH8
nuhlBQ/+J01qQOEQNAlpjeFZUBIcoZKOe4C2+2JFpG7idjCn2Mnta6XlZgJodR2/
5FkygyaMjMZn1MUYJmrxC2YoLKw83rTOrX5Vsm7UfzH7AWKpO+4R+ENBKPQ1syb2
n2U0+sxXHrZtuFU3KD0AfD8izqUAWZ7BcMa3dB3RiWaC+kp2xHgUqktn06KEaOJR
mZgZTh6XX1muoAwfIve+68tXBTjX3hgpj5bOfnoj46ritr8a4BWwBeE7ydta/Dpa
9E4ohGqrErEskTW2if6OaMFx/aR4/FgplX8j3XvjNWkr8igWFXYinToy+Om5S0n5
nH+16tohaPR/CL6QJMInzP+hCscok2Ds/f5PtB02x1tt2e8kiumux+KoG5Hx1BDg
j1RCvKbRZqj5eE258+13zZBjtfsikXfFv9YJN71zXJ01CIPInzwCNZFXEgafqnk6
MejiiVQnC+Db+I5YGurEq1bz6pIwhdpZkoxlWgUMeGcLWc62W5TJN3t8CE0vGe30
ynABspjfwT0fC23Qvjz8bTy9ECZUI1ZjKDNbtT6hkCujB11dGS9516OwsAV2mh/A
MM6rPGPLPAisSgj2Fhv5xieN4wFoA3Qfj8+qmUb6aEvf+88BKii24iCVayCLo3+M
M5u5+h5cL0sjRfGue/medNvZ95wEgsTUzbAk+OPBjFRoVu4s7mU=
=eTLt
-----END PGP SIGNATURE-----
--=-=-=--

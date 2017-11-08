From: Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH v2 06/12] hwrng: bcm2835-rng: Rework interrupt masking
Date: Wed, 08 Nov 2017 10:26:48 -0800
Message-ID: <87k1z0y6c7.fsf@anholt.net>
References: <20171108004449.32730-1-f.fainelli@gmail.com> <20171108004449.32730-7-f.fainelli@gmail.com>
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
In-Reply-To: <20171108004449.32730-7-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain

Florian Fainelli <f.fainelli@gmail.com> writes:

> The interrupt masking done for Northstart Plus and Northstar (BCM5301X)
> is moved from being a function pointer mapped to of_device_id::data into
> a proper part of the hwrng::init callback. While at it, we also make the
> of_data be a proper structure indicating the platform specifics, since
> the day we need to add a second type of platform information, we would
> have to do that anyway.

I still think we should just unconditionally mask off the interrupt
regardless of platform if we're not going to use it in the driver and
some platforms need it.  Looks like a fine refactor, though:

Reviewed-by: Eric Anholt <eric@anholt.net>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAloDTGgACgkQtdYpNtH8
nuiAphAAr8IxEjTZxZPpdyXJoE828kWcpwT8xtrpDMf9oouA7S0mb4iKW0Yhhm67
28qcuVUY6SMGgeHuxZTyrRLm5vHyuyQWXc9PYVjX+17bolrRyxrfX01gxCa3lLn7
spWs+GRKr1rTwS4KBiHcXu/T0HwmEshU4A1lAg9zWDQjcfx671rmggSgYSod6NSC
TDmtfllg+K9PpG0CvdVe0GRXdeGPR9gYBG1uhw9aa1t/W3bICCXhRKmtttPHJLmq
WZqo8d4zvytZxlM03mcrTHrc54auymSWF/G8Dg4EX//vm4IoJeXv3watxt5BPGWi
O7mXaMVD+syKnXt9wsWtwCuAZEiv/Qh7R7s80HlVWao88Bl5J33iudAqxyoICEbY
3AN8wxaC+wHJV4emMcJ8oSEchDC2jB1mKhnvSDLiaG5iK+GCwP7v74XYMxSMW1p/
FPILe37cKZ+LTR2rahX7P1B6nIJJZoud4IHjJg/zLEli4Wehp/MuuTXA5O6FXhqC
xRfA3TXFdNL6HlhW+L5bvaVgaRi7pcMfJAsApEVGl/2P7ST/mHFihheGXdjuPS7b
MYSt9984gGjOmN2cCV8WzYsB2KnfhbwqsU7HppjDmrJKG1Z1qxWCqeTN7fAl+mrD
yOSj0IvfrYM+8bBVPC5vVuoEPbCg6BG3EATBj41ojW24VtGYw6k=
=iCz+
-----END PGP SIGNATURE-----
--=-=-=--

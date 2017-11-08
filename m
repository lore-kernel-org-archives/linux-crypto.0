From: Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH v2 02/12] hwrng: bcm2835-rng: Define a driver private context
Date: Wed, 08 Nov 2017 10:22:29 -0800
Message-ID: <87po8sy6je.fsf@anholt.net>
References: <20171108004449.32730-1-f.fainelli@gmail.com> <20171108004449.32730-3-f.fainelli@gmail.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:52584 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751168AbdKHSWc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Nov 2017 13:22:32 -0500
In-Reply-To: <20171108004449.32730-3-f.fainelli@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--=-=-=
Content-Type: text/plain

Florian Fainelli <f.fainelli@gmail.com> writes:

> Instead of making hwrng::priv host the base register address, define a
> driver private context, make it per platform device instance and pass it
> down the different functions.
>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/char/hw_random/bcm2835-rng.c | 55 ++++++++++++++++++++++--------------
>  1 file changed, 34 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
> index a818418a7e4c..0d72147ab45b 100644
> --- a/drivers/char/hw_random/bcm2835-rng.c
> +++ b/drivers/char/hw_random/bcm2835-rng.c

> -static struct hwrng bcm2835_rng_ops = {
> -	.name	= "bcm2835",
> -	.read	= bcm2835_rng_read,
> -};
> -

>  	/* map peripheral */
> -	rng_base = devm_ioremap_resource(dev, r);
> -	if (IS_ERR(rng_base)) {
> +	priv->base = devm_ioremap_resource(dev, r);
> +	if (IS_ERR(priv->base)) {
>  		dev_err(dev, "failed to remap rng regs");
> -		return PTR_ERR(rng_base);
> +		return PTR_ERR(priv->base);
>  	}
> -	bcm2835_rng_ops.priv = (unsigned long)rng_base;
> +
> +	priv->rng.name = "bcm2835-rng";

Looks like an unintentional change from the previous "bcm2835" here?

Other than that, 1-2 are:

Reviewed-by: Eric Anholt <eric@anholt.net>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAloDS2UACgkQtdYpNtH8
nuhw4w/+NIBhKh0AHhQFrwMLVIt3tqjEwuEgNq8KjCenaVzwt1V6YvDrwPH14jM5
0UMz1apFrej7TKC38IQ1EsAODiodJvYQC1p/Nl5gQS4/WfejUPyhYW6wvDfZTAOK
l+9QA3IZQiHjo3Lwozp1bg35Bdt1RsaMV1fi9LElrcgF8DLzd4+G5m4sDllnZtTJ
MaPVIBE+bGwS/XULzOROpcRGhGhtxad6pTENPxxJMgO9MrymNgXe5eZihH2d5OM+
YN5qQQNPIvmhYisgc0YoVvrqP1Od6JRIXssJNdUD10CyqDeV2A45QhvzLAB664HC
w8Mm5TzJLgOptOeC3rDY38A+B8yT7B0SUIwv3ODITG0XFX43HVp9xDfxF8zX/+cI
9cuOsgAohjohPzgyqZbx5Hy+vqTOTCc9+Av0lfeWYoVoaGYXsVZXPgLbe+rctd39
gFjWMP6bz6Bb5dhFxOhr90GwwAQCIC2zfUGMAfHn3B0+Ae2odPSOiESjBac4Hyd3
X8EGg/ATsgxCzOzvBjmafYsgupJbtsJ4A6a9rbIKr2226vPRHWZJ8VZP3Qxvqa2a
a2XRKGj5s5U+v5vum4/ly+Vr7DIlSYysUqfaGNpYBqUOFBzualghE7zQh7yiRrNn
5vHeiUGaudUatRK7TGoTWFx80647+YwoPcoJzCuV+3OtKaLtstY=
=mpPQ
-----END PGP SIGNATURE-----
--=-=-=--

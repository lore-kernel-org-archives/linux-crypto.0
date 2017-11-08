From: Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH v2 07/12] hwrng: bcm2835-rng: Manage an optional clock
Date: Wed, 08 Nov 2017 10:31:21 -0800
Message-ID: <87h8u4y64m.fsf@anholt.net>
References: <20171108004449.32730-1-f.fainelli@gmail.com> <20171108004449.32730-8-f.fainelli@gmail.com>
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
In-Reply-To: <20171108004449.32730-8-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Florian Fainelli <f.fainelli@gmail.com> writes:

> One of the last steps before bcm63xx-rng can be eliminated is to manage
> a clock during hwrng::init and hwrng::cleanup, so fetch it in the probe
> function, and manage it during these two steps when valid.
>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/char/hw_random/bcm2835-rng.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_rando=
m/bcm2835-rng.c
> index ed20e0b6b7ae..99b56fd5482c 100644
> --- a/drivers/char/hw_random/bcm2835-rng.c
> +++ b/drivers/char/hw_random/bcm2835-rng.c
> @@ -15,6 +15,7 @@
>  #include <linux/of_platform.h>
>  #include <linux/platform_device.h>
>  #include <linux/printk.h>
> +#include <linux/clk.h>
>=20=20
>  #define RNG_CTRL	0x0
>  #define RNG_STATUS	0x4
> @@ -33,6 +34,7 @@ struct bcm2835_rng_priv {
>  	struct hwrng rng;
>  	void __iomem *base;
>  	bool mask_interrupts;
> +	struct clk *clk;
>  };
>=20=20
>  static inline struct bcm2835_rng_priv *to_rng_priv(struct hwrng *rng)
> @@ -66,8 +68,15 @@ static int bcm2835_rng_read(struct hwrng *rng, void *b=
uf, size_t max,
>  static int bcm2835_rng_init(struct hwrng *rng)
>  {
>  	struct bcm2835_rng_priv *priv =3D to_rng_priv(rng);
> +	int ret =3D 0;
>  	u32 val;
>=20=20
> +	if (!IS_ERR(priv->clk)) {
> +		ret =3D clk_prepare_enable(priv->clk);
> +		if (ret)
> +			return ret;
> +	}

clk_prepare_enable() is protected by IS_ERR_OR_NULL() checks and will
return 0.

> +
>  	if (priv->mask_interrupts) {
>  		/* mask the interrupt */
>  		val =3D readl(priv->base + RNG_INT_MASK);
> @@ -79,7 +88,7 @@ static int bcm2835_rng_init(struct hwrng *rng)
>  	__raw_writel(RNG_WARMUP_COUNT, priv->base + RNG_STATUS);
>  	__raw_writel(RNG_RBGEN, priv->base + RNG_CTRL);
>=20=20
> -	return 0;
> +	return ret;
>  }
>=20=20
>  static void bcm2835_rng_cleanup(struct hwrng *rng)
> @@ -88,6 +97,9 @@ static void bcm2835_rng_cleanup(struct hwrng *rng)
>=20=20
>  	/* disable rng hardware */
>  	__raw_writel(0, priv->base + RNG_CTRL);
> +
> +	if (!IS_ERR(priv->clk))
> +		clk_disable_unprepare(priv->clk);

Same.  With those conditionals dropped,

Reviewed-by: Eric Anholt <eric@anholt.net>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAloDTXkACgkQtdYpNtH8
nug4ew//aMhW/2UYN2aRM8WjSTui9ZoPuGHS+Jdqzv487eBxNCq6dRLH7vkVUgJi
QKcd7IN8+3pzDo7qBa23l00z0KokTPDn/rUui31zT/vABveflIxekCwyJX8GDvdO
MWf2AbCdUokpYctCwB0zlF9ouJmow1X3H6E4mTyeDoli7p0jF2qVObSMWiOMU1ib
YRts17lMB7SKAYQOk7Rnr8KRU9c0AMfNTNWyWzFGUfMUM3BKyWDNaVahovyFSNYU
9ekTXoKqVqdJY1HMEivAhUQJn8pG1ZhqiDACCbgP9YwRZxILiu5695SXDdPj/tPs
CJSopSz14BHXrQIPD1qjsdR0giLv6TxZ9Y573KHOuXBNZcP1X6/IkjyRdKOnd00S
E4aCzjOGbKtEUUy585cx8Y1HdGtmQEzpYfEjKFsh3DZ9FwElKRiC5NChoSw8Kgta
6rEevvVp2JI+toRuZEfYEFQaLcz1czF/obMy3O6dI5mOcpkm0Adv3CfzYJ0RWIQc
wl/teuoCPO4GqOYVlYEYBVm7TtBkivSaoP9ebK+VZYtcAMmmK+VCwv+fYSvEjrwB
bzmJOdtbHajrlBIGEpRu+jGGFWziQ4XLpc1KnqJcSJJxfKJEcx/Fo3xPZH57B1y1
ZKsd6gg55WvjjvXAVXvvluy3Qythv9gcdaYZNtUQE3JZwIzH+3Q=
=VErG
-----END PGP SIGNATURE-----
--=-=-=--

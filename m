From: Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>
Subject: Re: [PATCH 08/12] hwrng: bcm2835-rng: Abstract I/O accessors
Date: Fri, 03 Nov 2017 13:19:29 -0700
Message-ID: <874lqbru7i.fsf@anholt.net>
References: <20171102010408.27736-1-f.fainelli@gmail.com> <20171102010408.27736-9-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        "maintainer\:BROADCOM BCM281XX\/BCM11XXX\/BCM216XX ARM ARCHITE..."
        <bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Russell King <rmk+kernel-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,
        Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Harald Freudenberger <freude-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
        Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>,
        Martin Kaiser <martin-XxZfDwE/svGeZLLa646FqQ@public.gmane.org>,
        Steffen Trumtrar <s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>,
        "open list\:HARDWARE RANDOM NUMBER GENERATOR CORE"
To: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102010408.27736-9-f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> In preparation for allowing BCM63xx to use this driver, we abstract I/O
> accessors such that we can easily change those later on.
>
> Signed-off-by: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/char/hw_random/bcm2835-rng.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_rando=
m/bcm2835-rng.c
> index 35928efb52e7..500275d55044 100644
> --- a/drivers/char/hw_random/bcm2835-rng.c
> +++ b/drivers/char/hw_random/bcm2835-rng.c
> @@ -42,6 +42,17 @@ static inline struct bcm2835_rng_priv *to_rng_priv(str=
uct hwrng *rng)
>  	return container_of(rng, struct bcm2835_rng_priv, rng);
>  }
>=20=20
> +static inline u32 rng_readl(struct bcm2835_rng_priv *priv, u32 offset)
> +{
> +	return readl(priv->base + offset);
> +}
> +
> +static inline void rng_writel(struct bcm2835_rng_priv *priv, u32 val,
> +			      u32 offset)
> +{
> +	writel(val, priv->base + offset);
> +}
> +
>  static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
>  			       bool wait)
>  {
> @@ -49,18 +60,18 @@ static int bcm2835_rng_read(struct hwrng *rng, void *=
buf, size_t max,
>  	u32 max_words =3D max / sizeof(u32);
>  	u32 num_words, count;
>=20=20
> -	while ((__raw_readl(priv->base + RNG_STATUS) >> 24) =3D=3D 0) {
> +	while ((rng_readl(priv, RNG_STATUS) >> 24) =3D=3D 0) {
>  		if (!wait)
>  			return 0;
>  		cpu_relax();
>  	}

What was the difference between the __raw_readl and readl that's now
being done in the new call?  Is it important?

>  	/* set warm-up count & enable */
> -	__raw_writel(RNG_WARMUP_COUNT, priv->base + RNG_STATUS);
> -	__raw_writel(RNG_RBGEN, priv->base + RNG_CTRL);
> +	rng_writel(priv, RNG_WARMUP_COUNT, RNG_STATUS);
> +	rng_writel(priv, RNG_RBGEN, RNG_CTRL);

Similar question.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAln8z1EACgkQtdYpNtH8
nuhWWg/+NzMfYEwHHb9l8fWJ3mfUzje/lQO7STS7KIzfWTFTXOkbSx2oCM+9kEKP
K/B8zAGZi3No4agEdQ6nPrKkeJ/9wHqEyWAZW6FWoj4LWFGVbiDwnNzjSs5r1AyZ
r1ZBc17gpgVVf3eSuJURnN02W0CZm2ox9DkOxOIkQ0vXLvxBSpHqKrgC21RZGiTP
GwqwSgsZnUm+KGNfYha2sGy/L2Ydq8pxl5//z1GrUPmUaKQldaWfvfibWPfgHNet
cNayygFceYrUJKB23qPLXqFm0FiKk+Ec5XSK2JcU3FXZJTwZfdT+PBcX0kMtSnhk
rS9isscWkjj8VWyE8/HPGOuGK8vCUYkjYpB2t4IzwC+bfdqIVG9l2mGeO/MXKFWM
pp3hPBnqNwrHKz/WMCLiybuK6LFWvga3/V3TQlmKnGLfyCqSj9hWCwdjVP1kbYEf
VJ8mo0qDnfkjw+mbCKw1kgwpvkzJgOwFjo3ZdhVcIkhU/QKMb5eH4BAi4vpNzxJN
gkbNSY/PUwCXlLeeLn0JdU90L/QNQilGJkcP/aO1z+k2i68VWDTJ3NqMDSSqzOqj
PGEr3VdtxPbkSx/I9yyI+nYpbnrDMrwUKFBxhcDTTYgdLUzdNnCiWQPRiOuhAd26
7qCkG266B9V6kHTX3MktD9VX38L6cHZGjaM6FJKQIRvQEKvqhn4=
=idH7
-----END PGP SIGNATURE-----
--=-=-=--
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>
Subject: Re: [PATCH 12/12] hwrng: bcm63xx-rng: Remove since bcm2835-rng takes over
Date: Fri, 03 Nov 2017 13:18:28 -0700
Message-ID: <877ev7ru97.fsf@anholt.net>
References: <20171102010408.27736-1-f.fainelli@gmail.com> <20171102010408.27736-13-f.fainelli@gmail.com>
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
In-Reply-To: <20171102010408.27736-13-f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain

Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> bcm2835-rng is now capable of supporting the BCM63xx hardware, so remove
> the driver which duplicates the same functionality.
>
> Signed-off-by: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/char/hw_random/Kconfig       |  13 ---
>  drivers/char/hw_random/Makefile      |   1 -
>  drivers/char/hw_random/bcm63xx-rng.c | 154 -----------------------------------
>  3 files changed, 168 deletions(-)
>  delete mode 100644 drivers/char/hw_random/bcm63xx-rng.c
>

> diff --git a/drivers/char/hw_random/bcm63xx-rng.c b/drivers/char/hw_random/bcm63xx-rng.c
> deleted file mode 100644
> index 5132c9cde50d..000000000000
> --- a/drivers/char/hw_random/bcm63xx-rng.c
> +++ /dev/null

> -static int bcm63xx_rng_data_present(struct hwrng *rng, int wait)
> -{
> -	struct bcm63xx_rng_priv *priv = to_rng_priv(rng);
> -
> -	return __raw_readl(priv->regs + RNG_STAT) & RNG_AVAIL_MASK;
> -}

It looks like this method isn't in the 2835 implementation.  Should it
get ported over?

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAln8zxQACgkQtdYpNtH8
nugR4xAAucbKZ13rgHcRie1UB9tJNqmo2nmwD5qX3+pZJbvTJ0knzqPCg52fJ/kB
ylJkghYlK4HiL6wQlcfxSVR01YYhj4Sddk+zPvIzgsFPaPHHDv1151iUwhB41Wwd
DlQaQl1HhY+DLFCP7pYLQSMZ5ZJQ+yBf4+HX05jSEq9UnzAL1WRxRbNK45EOG+mP
Pfsek8p+zpk8nPJ1NTbZbosiX/nXdm0cOID2eS2x7PxGWVf85wdnM8UA/WfzLv3q
u0o5hUs458BG/Gkpb2kwhu67lx1P0OTwMJsiee//G7xcuwBMN/962zzerndF0lkO
Wb6kRHG8d9ISI8OKDlfZg5BEtsHk6SBMxE3xfowIadLSKbSrXeWPBqnpch27u5z5
AlL4DcrpUxJfa9ZMr9btCUcOzSsgf2uu4lLFvMHm4T9awHqHRRpa2mjSIArnckRk
qD9Mty6SgHtPswX7bVl81IwKM/YDJ29hMZH+qjDQLB16qqvYnlQrAM2Z92B6myNK
J07D3mdE2fX/64F6DQbSaDGygmQ6n5jRH+O0ONQWXrW4dKJoKUpKybQ31dhkM/ye
OqSki0lhrI+ShOs5vNz+i7fBXWajJ8tTz801iNOE8CGr8qoKD243UeNLESZwfRpG
9fpDWfaY9sO/amsSwdoAuZEGXN5T+DzPIBhpFNTbharaT96FZHA=
=Z7XA
-----END PGP SIGNATURE-----
--=-=-=--
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

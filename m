From: =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Subject: Re: [PATCH][next] hwrng: exynos: check for -ve error return from
 readl_poll_timeout
Date: Mon, 29 Jan 2018 14:24:00 +0100
Message-ID: <87fu6oyf0v.fsf%l.stelmach@samsung.com>
References: <20180112163048.26960-1-colin.king@canonical.com>
        <CGME20180129132405eucas1p244f341793274cd1c11aa09e0b1d2c4bd@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41319 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbeA2NYK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jan 2018 08:24:10 -0500
In-reply-to: <20180112163048.26960-1-colin.king@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2018-01-12 pi=C4=85 17:30>, when Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Currently, the return from readl_poll_timeout is being assigned to
> a u32 and this is being checked for a -ve return which is always
> false since a u32 cannot be less than zero.  Fix this by changing
> val to an int so that error returns can be correctly detected.
>
> Detected by CoverityScan, CID#1463776 ("Logically dead code")
>
> Fixes: 6cd225cc5d8a ("hwrng: exynos - add Samsung Exynos True RNG driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/char/hw_random/exynos-trng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_rando=
m/exynos-trng.c
> index 34d6f51ecbee..f4643e3ec346 100644
> --- a/drivers/char/hw_random/exynos-trng.c
> +++ b/drivers/char/hw_random/exynos-trng.c
> @@ -55,7 +55,7 @@ static int exynos_trng_do_read(struct hwrng *rng, void =
*data, size_t max,
>  			       bool wait)
>  {
>  	struct exynos_trng_dev *trng;
> -	u32 val;
> +	int val;
>=20=20
>  	max =3D min_t(size_t, max, (EXYNOS_TRNG_FIFO_LEN * 4));

Fixed.

https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/c=
ommit/?id=3Da8bc71d4960391f732ec0307ebd69e4a25aaf4d3

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCAAGBQJabyBwAAoJELCuHpyYpYAQZwYH/RlxAx/YurLQ/T+cRM8BRMoE
t5RVRMByVZKd0J6ReIPtgKUeO8QF+HJYvgbXdKGFZ1GcQWBzY/57Zix5lryC9lZR
2kWKXrW0Ji3G6XEPjnvknCTVK24uZ9tO84sh34yuXd6b0JnESraORsoT6ryq32jv
LVNlXH2fsoEixNbQHsBwyRCwa+Ov9PuMHRS1yU/m8+MkucIy4kNX4tcdlOTVN8l7
pI2Jxz4pUFCju6lySUTT4Nh7GzU3M8oIC/s8tVQkpTOF0q81AYCg55666gnGtwSr
19Ynrr9CikelpWhtqoPHusunbRuLrQBrm4Pexd+U88PkkbszCw4mE7+TsOsmxCA=
=i0mm
-----END PGP SIGNATURE-----
--=-=-=--

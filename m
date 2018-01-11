From: =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Subject: Re: [PATCH -next] hwrng: exynos - remove redundant dev_err call in
 exynos_trng_probe()
Date: Thu, 11 Jan 2018 12:13:35 +0100
Message-ID: <87d12gzm00.fsf%l.stelmach@samsung.com>
References: <1515591059-73230-1-git-send-email-weiyongjun1@huawei.com>
        <CGME20180111111347eucas1p1207cc5450f132c7579e9bd7ebc9c31df@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
Cc: mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, kgene@kernel.org, krzk@kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        kernel-janitors@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55374 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932861AbeAKLNw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jan 2018 06:13:52 -0500
In-reply-to: <1515591059-73230-1-git-send-email-weiyongjun1@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2018-01-10 =C5=9Bro 14:30>, when Wei Yongjun wrote:
> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Acked-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>

> ---
>  drivers/char/hw_random/exynos-trng.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_rando=
m/exynos-trng.c
> index 34d6f51..4c8a2be 100644
> --- a/drivers/char/hw_random/exynos-trng.c
> +++ b/drivers/char/hw_random/exynos-trng.c
> @@ -129,10 +129,8 @@ static int exynos_trng_probe(struct platform_device =
*pdev)
>=20=20
>  	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	trng->mem =3D devm_ioremap_resource(&pdev->dev, res);
> -	if (IS_ERR(trng->mem)) {
> -		dev_err(&pdev->dev, "Could not map IO resources.\n");
> +	if (IS_ERR(trng->mem))
>  		return PTR_ERR(trng->mem);
> -	}
>=20=20
>  	pm_runtime_enable(&pdev->dev);
>  	ret =3D pm_runtime_get_sync(&pdev->dev);
>
>
>
>

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCAAGBQJaV0bgAAoJELCuHpyYpYAQ24oH/0R7nTNQ5m7SbblU1pUqhMnF
XfNvLKlgi3RBCkc6qpHtKrpYbWcckBL6uplB69uBVq+WhHFttZqPf+5nFQuOj+Xr
0K+nq+KC/kLMWqdqmN/seIsTWJAp0jhha2E6NuJskkJK2PGs0bzqJpkdRV7jskkF
AMPMLpjtc9R6vNpODMvdga1A8kCscTOdRrjfu7qmpUPiEgHhe446fyu5wccf9QfS
c/Wrd9VdpxsdK+yjq2KDZ+ID4im2ANnNApNnF9a7EMjlcFjO6IEtFiWC56d5j2de
iM5/TwE28Ss7PgDvy86bXZ5J9PNBGLzeB6eC5vO+vW8g6q1halKVYIHd1ZkHqKI=
=JZS8
-----END PGP SIGNATURE-----
--=-=-=--

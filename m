Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TbwLiRSc"
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D01F10A;
	Tue, 12 Dec 2023 01:31:35 -0800 (PST)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20231212093134euoutp0245dd94e5990b4d8142a32097159cc707~gC6xZ0X_g1498914989euoutp02L;
	Tue, 12 Dec 2023 09:31:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20231212093134euoutp0245dd94e5990b4d8142a32097159cc707~gC6xZ0X_g1498914989euoutp02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1702373494;
	bh=9lfAb2vSYKFJSRXZUBbgTF07y4N/2k5Hl2lKg99wS3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbwLiRScfRj0hLGx+XgY9pKisM8cCZ1f9aNkchvqu+zkFxiVRMKl6ycgbGoGNXvCR
	 Ypn/khbFpQjuaois5Gb/OMNdujaVsMpetVY+sZjfs5Ylm08sm3cLCI2nd/37lPq3c0
	 yPU8Atp6te2MZI0CWfhHw6XdkAUrg232AbUn31hQ=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20231212093133eucas1p24dad27077c645000f6e7df73a31c73b0~gC6xNsHYk2201322013eucas1p2r;
	Tue, 12 Dec 2023 09:31:33 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id 6C.E3.09552.57828756; Tue, 12
	Dec 2023 09:31:33 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20231212093133eucas1p1c19ba5aa058ca1e159bfd070aec0f306~gC6wzHYyC0923209232eucas1p1o;
	Tue, 12 Dec 2023 09:31:33 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20231212093133eusmtrp2cf5d936524a48067f2219bf248fa22ca~gC6wyGUFQ2501725017eusmtrp2c;
	Tue, 12 Dec 2023 09:31:33 +0000 (GMT)
X-AuditID: cbfec7f5-853ff70000002550-65-65782875f98f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 38.F1.09146.57828756; Tue, 12
	Dec 2023 09:31:33 +0000 (GMT)
Received: from localhost (unknown [106.120.51.111]) by eusmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20231212093133eusmtip142a909f67bd3e689f53855390da2c11c~gC6wl5hhl1171011710eusmtip1c;
	Tue, 12 Dec 2023 09:31:33 +0000 (GMT)
From: Lukasz Stelmach <l.stelmach@samsung.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Olivia Mackall <olivia@selenic.com>,  Herbert Xu
	<herbert@gondor.apana.org.au>,  Krzysztof Kozlowski
	<krzysztof.kozlowski@linaro.org>,  Alim Akhtar <alim.akhtar@samsung.com>,
	linux-samsung-soc@vger.kernel.org,  linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,  kernel@pengutronix.de
Subject: Re: [PATCH 03/12] hwrng: exynos - Convert to platform remove
 callback returning void
Date: Tue, 12 Dec 2023 10:31:32 +0100
In-Reply-To: <817e91f7bb257745c0fb483037b83c1a6ba14e75.1702245873.git.u.kleine-koenig@pengutronix.de>
	("Uwe =?utf-8?Q?Kleine-K=C3=B6nig=22's?= message of "Sun, 10 Dec 2023
	23:12:18 +0100")
Message-ID: <oypijdfs07937v.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
	protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsWy7djP87qlGhWpBt0HdSwezNvGZtH9SsZi
	1dSdLBZ7X29lt9j0+Bqrxf17P5ksZpzfx2Rx/0wPo8XtiZMZHTg9th1Q9bhzbQ+bx+Yl9R79
	fw08+rasYvToe7mB0ePzJrkA9igum5TUnMyy1CJ9uwSujCONHAV3xSrmvJvJ1sC4U7iLkZND
	QsBE4tGMSaxdjFwcQgIrGCVudu5mgXC+MEqsXf6HGaRKSOAzo8T7q+IwHVNn34IqWs4osXvZ
	dkYI5wWjxP/j19m7GDk42AT0JNaujQAxRQTcJHrnxoGUMAvsZJJovvqQHWSQsEC8xMX+54wg
	NouAqsS3uS/BhnIKHGCUWNhyhwUkwStgLjHpx3GwK0QFLCWOb21ng4gLSpyc+QSshlkgV2Lm
	+TdgR0gI9HNK3Fo9lR3iVBeJQ/MmMELYwhKvjm+BistI/N85nwmioZ1RounKQlYIZwKjxOeO
	JiaIKmuJO+d+sUHYjhLHv58Ae01CgE/ixltBiM18EpO2TWeGCPNKdLQJQVSrSKzr38MCYUtJ
	9L5aAXWDh8Svu1uZIaG1g1HixfIdrBMYFWYheWgWkodmAY1lFtCUWL9LHyKsLbFs4WtmCNtW
	Yt269ywLGFlXMYqnlhbnpqcWG+ellusVJ+YWl+al6yXn525iBKav0/+Of93BuOLVR71DjEwc
	jIcYVYCaH21YfYFRiiUvPy9VSYT35I7yVCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8qinyqUIC
	6YklqdmpqQWpRTBZJg5OqQYmwxVrCq4pT0qT4F25mHVfY9VMd5up3dcjpJbOUfn8dsYz7qSj
	fLPbdM0ndTB2ygQ38ewXM120/guvvdC91CmbLZjM9Sf3MnT7/5l30vvhmu/RBQaH724W9mQO
	FyrTf9pQeiwxRar957PrxlLrNG6o1H98um5NQKj1xo1SKp5PXa4JfpK7yM3gICr2/Hfc00Vb
	S27e7p7YfONYojW3hQ2nflz6mUWPbdvuvN928sq19HaJ/DQRd9v3v+asO2Lk5/58vY8jw9Nq
	lw6Oy/5cjzzeRtwoucLmV96qKJddlWZ+cPbMuhfbzDlX6fpcK//RnyC2KSJT6bTo/gfb5nnX
	Omf63oy7tN7RqGtXtHzTrEVKLMUZiYZazEXFiQAl2F0H2gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t/xu7qlGhWpBttaBCwezNvGZtH9SsZi
	1dSdLBZ7X29lt9j0+Bqrxf17P5ksZpzfx2Rx/0wPo8XtiZMZHTg9th1Q9bhzbQ+bx+Yl9R79
	fw08+rasYvToe7mB0ePzJrkA9ig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNT
	JX07m5TUnMyy1CJ9uwS9jCONHAV3xSrmvJvJ1sC4U7iLkZNDQsBEYursWyxdjFwcQgJLGSVa
	L29j7mLkAEpISaycmw5RIyzx51oXG0TNM0aJLfMvsIHUsAnoSaxdGwFiigi4SfTOjQMpYRbY
	zSTx7dldZpBeYYF4iYv9zxlBbCGBFIlr1zawg9gsAqoS3+a+BNvLKXCAUeLSjA9gRbwC5hKT
	fhwHaxYVsJQ4vrWdDSIuKHFy5hMWEJtZIFvi6+rnzBMYBWYhSc1CkpoFdBOzgKbE+l36EGFt
	iWULXzND2LYS69a9Z1nAyLqKUSS1tDg3PbfYUK84Mbe4NC9dLzk/dxMjMO62Hfu5eQfjvFcf
	9Q4xMnEwHmJUAep8tGH1BUYplrz8vFQlEd6TO8pThXhTEiurUovy44tKc1KLDzGaAv02kVlK
	NDkfmBDySuINzQxMDU3MLA1MLc2MlcR5PQs6EoUE0hNLUrNTUwtSi2D6mDg4pRqY1vY8ezzf
	mvnpjfO/eX/d7FSNmPZihZH7ao0Z3+TWzg+be1/9TWGhQ/g/JUmnPuEbVbNeHOt9I5u+tX7q
	nNvMQlPcZJkd511t/T3X6Fwgh9mGlwsm7DI7ub+SR2TxDLF9a9n4lC1an2ed+ZpjOvH2wyJ+
	LrWvrWFLfTybb9iwlclZ91n4F15c2q1XeTc78olxXNHaWJN4Nu0ZM34KJZrYvMhg3WKefCL0
	mA2v4POSx9t3XE/1zmpTsxZaePHdXheLfGN/zuLl9n/NHja2R2sK/5v6Im5R1uGYY9t5unsm
	9lif+Kq9VfN8g5pKz+5Fpgy8lhKK6ouDNs7mNDDh8bvQ49/GyBIbOOOf5Zxjb6YqsRRnJBpq
	MRcVJwIA+w0MlFADAAA=
X-CMS-MailID: 20231212093133eucas1p1c19ba5aa058ca1e159bfd070aec0f306
X-Msg-Generator: CA
X-RootMTR: 20231212093133eucas1p1c19ba5aa058ca1e159bfd070aec0f306
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20231212093133eucas1p1c19ba5aa058ca1e159bfd070aec0f306
References: <817e91f7bb257745c0fb483037b83c1a6ba14e75.1702245873.git.u.kleine-koenig@pengutronix.de>
	<CGME20231212093133eucas1p1c19ba5aa058ca1e159bfd070aec0f306@eucas1p1.samsung.com>

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2023-12-10 nie 23:12>, when Uwe Kleine-K=C3=B6nig wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
>
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
>
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
>
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/char/hw_random/exynos-trng.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>

Acked-by: Lukasz Stelmach <l.stelmach@samsung.com>

> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_rando=
m/exynos-trng.c
> index 30207b7ac5f4..0ed5d22fe667 100644
> --- a/drivers/char/hw_random/exynos-trng.c
> +++ b/drivers/char/hw_random/exynos-trng.c
> @@ -173,7 +173,7 @@ static int exynos_trng_probe(struct platform_device *=
pdev)
>  	return ret;
>  }
>=20=20
> -static int exynos_trng_remove(struct platform_device *pdev)
> +static void exynos_trng_remove(struct platform_device *pdev)
>  {
>  	struct exynos_trng_dev *trng =3D  platform_get_drvdata(pdev);
>=20=20
> @@ -181,8 +181,6 @@ static int exynos_trng_remove(struct platform_device =
*pdev)
>=20=20
>  	pm_runtime_put_sync(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
> -
> -	return 0;
>  }
>=20=20
>  static int exynos_trng_suspend(struct device *dev)
> @@ -223,7 +221,7 @@ static struct platform_driver exynos_trng_driver =3D {
>  		.of_match_table =3D exynos_trng_dt_match,
>  	},
>  	.probe =3D exynos_trng_probe,
> -	.remove =3D exynos_trng_remove,
> +	.remove_new =3D exynos_trng_remove,
>  };
>=20=20
>  module_platform_driver(exynos_trng_driver);

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmV4KHQACgkQsK4enJil
gBCRvQf+PyurfFZWbPslu37bFwG3yyfvKYGrFjJYjQl2baKl3uF9IRWnKIxklNqw
FARwvOuCuSVyWJNRRAHrATFZ5wls96Pc0UU+BBExjIze+5babcF6yxAchQ/iaFj1
gGOJzfEcLHXLZKGXOG5hYiaxf8rE4YAyu6ny1xXWkRSmE5+Q8foxCV5WFQm/M7nZ
8bzOkGaIrpIjvFHqzAX5EWiysKqDkvH+3zZZofacSzu/mghR0dYhmwu2zzsz4S2i
ZZ2WDOQh5rGzo9shSPlN95x7zSxIHv668dxki239m89AifAB2pdpaScoxXEGY2W2
lvUkbzHnJnV2TZzEyDEcwejvkQy+RQ==
=keMH
-----END PGP SIGNATURE-----
--=-=-=--

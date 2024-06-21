Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF6715FD19;
	Fri, 21 Jun 2024 19:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718996456; cv=none; b=IUhvGrwlWuII+7AxuYiHYyI/ekvydWY92NzY0Ii2aaOAw11PMk7/pNcxCjv48QMWrL2CPTGPCq8Y8YaCRB8xXZxVo0uADLToJpopXbnflCUckwYcjTZvYGAUGtt1AqdtTSbof1ypsthVpyOsfFL6pJGXMcdDqqEVXLPwOY/+I2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718996456; c=relaxed/simple;
	bh=1xI8YRL10smwl7VMGvO7M912Po4pATP5fMCzVekJ7R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type:References; b=ihABFL5xZYf+C4BbKHYYlTq8RZoqEowjUYEPUiyABAgEBVV+WBYLTvLlCK9jVEb2weuLl6K0jTGyK6sHDG4tdfsgXu9RpIjs2jDgeH43Bmeqj8koAGEaui79dxmVHWkJ+PnFLOem6zT4g+32N6aWsTcXOd/jCWqAojqS37CMFLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Xg9C7vjh; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Xg9C7vjh"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240621190051euoutp011e3fb80ce585a280639feb0146ab6e7c~bGiooYs8W0340903409euoutp01M;
	Fri, 21 Jun 2024 19:00:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240621190051euoutp011e3fb80ce585a280639feb0146ab6e7c~bGiooYs8W0340903409euoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1718996451;
	bh=fh5BmalpRFF5KdaH3pq9kpTeLWy3/PADXMuzR0CNQWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xg9C7vjhhKp8Rw4UIKiDK/M9Pw3HSlZHI2Z8PjzFsnZjvZVfzkDfaNuYALyV0VRGr
	 QrH/hXxH1ei2XzfBHvm8oo8Ve8ctOAlzBeFvEsfncvYe2ur8YhUGpCCInaGtXHg8y1
	 6QxofTwOApKWffHWmdwkCBft/gAsb5qc+tYQjOEc=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240621190050eucas1p1d924ca2731218b3a724a30443c603042~bGioD9UOj1850418504eucas1p1h;
	Fri, 21 Jun 2024 19:00:50 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id 58.50.09620.2EDC5766; Fri, 21
	Jun 2024 20:00:50 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240621190049eucas1p28ba502d86e2f9380315c06add645517c~bGinQcrAp1851118511eucas1p2v;
	Fri, 21 Jun 2024 19:00:49 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240621190049eusmtrp2e23bb636b1098754aaf533b1db1f8aef~bGinPvTUW2540425404eusmtrp2e;
	Fri, 21 Jun 2024 19:00:49 +0000 (GMT)
X-AuditID: cbfec7f5-d1bff70000002594-1c-6675cde28763
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id BA.22.09010.1EDC5766; Fri, 21
	Jun 2024 20:00:49 +0100 (BST)
Received: from localhost (unknown [106.120.51.111]) by eusmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240621190049eusmtip108eda68f91c3e7b7e6b91f8214750328~bGinCT2jO2684926849eusmtip14;
	Fri, 21 Jun 2024 19:00:49 +0000 (GMT)
From: Lukasz Stelmach <l.stelmach@samsung.com>
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>,  Rob Herring
	<robh@kernel.org>,  Conor Dooley <conor+dt@kernel.org>,  Anand Moon
	<linux.amoon@gmail.com>,  Olivia Mackall <olivia@selenic.com>,  Herbert Xu
	<herbert@gondor.apana.org.au>,  Alim Akhtar <alim.akhtar@samsung.com>,
	linux-samsung-soc@vger.kernel.org,  linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v3 5/6] hwrng: exynos: Add SMC based TRNG operation
Date: Fri, 21 Jun 2024 21:00:29 +0200
In-Reply-To: <20240620231339.1574-6-semen.protsenko@linaro.org> (Sam
	Protsenko's message of "Thu, 20 Jun 2024 18:13:38 -0500")
Message-ID: <oypijdplsaruia.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
	protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUwTdxjH/d0d16OuzbXCeFY73Yq4OF2BYeIpurDFzMuMy4bJsmzGrZPj
	xdGWtFQYWwa4IMhmQTCwNkPt4gpWW7BABWXMNCgu64sw0hBCyyzEl3abKUyRJepaziX+93m+
	z/d5++VH4dLZJBlVoinndBpVqYIUEq5rS/7Xwl5DYZbNLWP+OOkimfM/+zDm1Igvifk2Imfu
	mkMk45wNJDEzoSWM+f3SDyTzvX8YYxwXpgSMfSQoYGY83yHmydCAgLltHMbyxOygOShgXVcy
	WKftKMlOB4ZItvdMNWvssyHWeLcHsQvONe9RHwm3F3ClJYc4XeYbnwqLxx7ewMtCL1SevWMl
	a9CZ1EZEUUBvBmuUbkTJlJTuQhCdzm9Ewjj/g2CqfRbxwQKCsMVOJFyJgvDJCySf6EQwMH6N
	4IM7CDoGe/FEW5JWgt3+YaIgJY4OU0SQ8OB0FAenzxMPBNQqehfM70hYCDoDAnVelOBkugZB
	YEScYBG9Be77g8tzU+mtMNpfT/K6BH41zS3rOK0Gk//P5UWB/iUZxiePIv6ynXAktpffeRVE
	RvsEPMvhyeApjPfXIzg8YUnig2YECw2HMd6VC9O+f0me34TazhM431QMk39J+MFiaHG1P5VF
	0HBEyrvXgaNp6OlbyeBYpAvxzEJbtA3jn6oFwYPLdYJm9JL5mXvMz9xjjrfF6Q3QfSmTlzeC
	1RLFed4BDsc94jRKsqE0zqBXF3H6HA1XodSr1HqDpkh5QKt2ovjf++3x6P0B1BWJKd0Io5Ab
	rYsXh3vO3UAyQqPVcIoU0e1GXaFUVKD6oorTaT/RGUo5vRutpghFmiijYC0npYtU5dznHFfG
	6f7PYlSyrAYjNO945oTZG6Rv775ZuD99yFOtDLvnh6nFMebqVxMfEH1b97Qbd7aGYor1x195
	UX5ri/fHzuJ50FO9+y4eTG9dbeiwZu2zGpQrFk9UZR1r5iQd29jaKlv1XqXW//rFYIX08nO5
	6+vki8OxlkpLClm9cU3eWstS+kDO9YPiuZu3MhfPZ+eUPWo668sPtnzctH3lZ6bcTWLm+HRd
	998ev8s7JZrJ63m5W522K/hWqH/3g5JySX7ttgPer4VXU+mKc8Yl1Zex+lnT/tNX8EcrNtP9
	1yfwewFv58OVRZKG9J+cZbQKb40e6n63eXCTHZt8/xuv/DGuHa0cp9r694y1P2+dUxD6YlX2
	q7hOr/oPmMRsfPYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t/xu7oPz5amGZzbqGjxYN42Nos1e88x
	Wcw/co7VovuVjMXLWffYLDY9vsZqcf/eTyaLy7vmsFnMOL+PyWLdxlvsFmuP3GW3uH+mh9Hi
	/54d7BbP+/YxOfB57Jx1l91j2wFVj02rOtk87lzbw+axeUm9R9+WVYwefS83MHp83iQXwBGl
	Z1OUX1qSqpCRX1xiqxRtaGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl3HxxwXm
	gnuSFStfLGNrYFwi2sXIySEhYCLxaN5Gti5GLg4hgaWMEtcnTWXuYuQASkhJrJybDlEjLPHn
	WhcbiC0k8IxR4s43fpASNgE9ibVrI0DCIkDmupmv2EHGMAu8Y5bYevkQYxcjO4ewgLvEJ1uI
	TjuJSwd72UFsFgFViWutZxlBbE6BBkaJa0f4QGxeAXOJr+fvsoDYogKWEse3trNBxAUlTs58
	AhZnFsiW+Lr6OfMERoFZSFKzkKRmAR3HLKApsX6XPkRYW2LZwtfMELatxLp171kWMLKuYhRJ
	LS3OTc8tNtIrTswtLs1L10vOz93ECIzYbcd+btnBuPLVR71DjEwcjIcYVYA6H21YfYFRiiUv
	Py9VSYT3eVdRmhBvSmJlVWpRfnxRaU5q8SFGU6DXJjJLiSbnA1NJXkm8oZmBqaGJmaWBqaWZ
	sZI4r2dBR6KQQHpiSWp2ampBahFMHxMHp1QDk/xkLZaAwqIHX19EM7hYvisMySz7mBqmYcu4
	SG//m901d85pHIg4qzKl/oty846f9w6tz3+4mIfhlcn709zT57FP3Oa6jUMk49etAy+0zkuc
	yuvS5W9wndB6IivksrRp064tSo6CSy+XV93W+hEx6Qn/r0NikjPcNc2LL//s+/A2sWrvr+MW
	v79e97zY7Kc976jotRUr2+LmmZw4soPtlKZq1PvTTx+KbzCz2rZtXmmdcXd+yG/1iX7zM7dX
	33vOwXntoPCmZcve2vg+cLCQWDdVcnfAPZbT3QcdZy7z1P/6i2sfp+ZxuTW//gX/FjOK+dF2
	X/ZF0tYzs3dIsL7/OOt+y9eZF2d4rAqp3vrD8oytEktxRqKhFnNRcSIAIBPrrW0DAAA=
X-CMS-MailID: 20240621190049eucas1p28ba502d86e2f9380315c06add645517c
X-Msg-Generator: CA
X-RootMTR: 20240621190049eucas1p28ba502d86e2f9380315c06add645517c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240621190049eucas1p28ba502d86e2f9380315c06add645517c
References: <20240620231339.1574-6-semen.protsenko@linaro.org>
	<CGME20240621190049eucas1p28ba502d86e2f9380315c06add645517c@eucas1p2.samsung.com>

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2024-06-20 czw 18:13>, when Sam Protsenko wrote:
> On some Exynos chips like Exynos850 the access to Security Sub System
> (SSS) registers is protected with TrustZone, and therefore only possible
> from EL3 monitor software. The Linux kernel is running in EL1, so the
> only way for the driver to obtain TRNG data is via SMC calls to EL3
> monitor. Implement such SMC operation and use it when EXYNOS_SMC flag is
> set in the corresponding chip driver data.
>
> Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
> Changes in v3:
>   - Added appropriate error messages for the case when init SMC command f=
ails
>
> Changes in v2:
>   - Used the "reversed Christmas tree" style in the variable declaration
>     block in exynos_trng_do_read_smc()
>   - Renamed .quirks to .flags in the driver structure
>   - Added Krzysztof's R-b tag
>
>  drivers/char/hw_random/exynos-trng.c | 140 +++++++++++++++++++++++++--
>  1 file changed, 130 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_rando=
m/exynos-trng.c
> index 6ef2ee6c9804..9fa30583cc86 100644
> --- a/drivers/char/hw_random/exynos-trng.c
> +++ b/drivers/char/hw_random/exynos-trng.c

[...]


> @@ -103,6 +163,24 @@ static int exynos_trng_init(struct hwrng *rng)
>  	return 0;
>  }
>=20=20
> +static int exynos_trng_init_smc(struct hwrng *rng)
> +{
> +	struct exynos_trng_dev *trng =3D (struct exynos_trng_dev *)rng->priv;
> +	struct arm_smccc_res res;
> +	int ret =3D 0;
> +
> +	arm_smccc_smc(SMC_CMD_RANDOM, HWRNG_INIT, 0, 0, 0, 0, 0, 0, &res);
> +	if (res.a0 !=3D HWRNG_RET_OK) {
> +		dev_err(trng->dev, "SMC command for TRNG init failed (%d)\n",
> +			(int)res.a0);
> +		ret =3D -EIO;
> +	}
> +	if ((int)res.a0 =3D=3D -1)
> +		dev_info(trng->dev, "Make sure LDFW is loaded by your BL\n");

This is good, thank you for adding it. It can be even better though, if
you don't skimp on message length (-; I mean, I know what BL is, I can
fingure what LDFW is because you have explained to me and I can see the
source code, but somewone who sees it for the first time will be only
slightly less surprised than with v2 error message only. Come on, you
can make this message twice as long and it will still fit in 80 characters =
(-;

Don't change it if v3 is the last. If not, please, make it more verbose.

> +
> +	return ret;
> +}
> +


[...]


Kind regards,
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmZ1zc0ACgkQsK4enJil
gBCvUgf+KkpSOKPvcfQuSHLfbhbfcy5nzwnU01J4onEued9iClyhoqOXA02kPp/B
68JLBCGl2v1S7OAyr1ZNY0XjAPn3xLpuh1fH41j4wt2mFjpjycO6qur/8jyOPmfN
5Z7txxkta2OzJBtQ+c3kEQ6E/sl+03KJCj2Y7YfK51eGCqr9DkkpRTa7R/1IL3FY
9sk8wn80rfRtDZYP8S/xHARcte7uOkhU93NuQs2h9UL6mpnFFQ+UD8K2Kh46xPeR
v15fncy50yb1wcOGa/7gC2Wv4xYSF38eByxiy5WtExyS1tC11khZxlSfYol6EOKd
CUkH0i9czNOFU31yJ83xrXKdbWFRPw==
=y/GC
-----END PGP SIGNATURE-----
--=-=-=--

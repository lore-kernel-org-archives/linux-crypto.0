Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33CC1A8C2C;
	Thu, 20 Jun 2024 08:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718873564; cv=none; b=ZQFZS4/s+lGLK8trPCJnhGccXrIkmHjiGto8kaTyNjB/Ge4G1MHsiKHxaU6s8WvR6z6z5HD9wkufUiaOWkPI8jWip9cxFHcnRUTVVBqhlZhdOQZzV2rSCk7ggmx9TtTEPScbGn1bG5zT324vCaLrwBE5ys/7Attwd6wvyda6J50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718873564; c=relaxed/simple;
	bh=HP9KicQFilSfkAaELgJDPIgGIs/+VeUvKvHLO7SwbR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type:References; b=DX+Nv1aSyX/j++vfe+6Vb2lVu0ma+UjxNfBM4oHFlJaNhxmx0fgfiC9SnZb4oEJC90S8lzbkHAmELCT32dOg8m6C1cleL2KUzGMY9x+bRYiCAWy5ohFPmNvNuN4GJ9QxClq0DWOuHjdAv61lRYmEGCoaQXO9oL05P9ihcuY/9c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gUexj9wG; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gUexj9wG"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240620085239euoutp01994618d3d91d1c23e9c54c48a5591237~aqmVIkNRK0673506735euoutp01k;
	Thu, 20 Jun 2024 08:52:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240620085239euoutp01994618d3d91d1c23e9c54c48a5591237~aqmVIkNRK0673506735euoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1718873559;
	bh=pcmdDxVon4nXj2k/OPa/eCxaXyT++SrGLV2FW+Ib2wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUexj9wGhyD6JK6ITlSIYmC5RfcBwK+nesS7YqvPiIOi/EAnjihHuzPiJihmCMxLK
	 h+wKCYSDdbg3gQYjmxTF3HSV8DRFiRicC9TnaCmIElfOfb/7LZiOXA60IRLDZ1WN/Y
	 Xzfp22fXjvufk6dCVBR6s0aWIpmx9CthDAJt9pjs=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240620085239eucas1p12fe900919588a06442230f6ea982b248~aqmU_u8lD3066630666eucas1p1E;
	Thu, 20 Jun 2024 08:52:39 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id A2.49.09624.7DDE3766; Thu, 20
	Jun 2024 09:52:39 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240620085239eucas1p1d49a6bae77e1fc857e4459f87c619a83~aqmUldGCJ1175011750eucas1p17;
	Thu, 20 Jun 2024 08:52:39 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240620085239eusmtrp1d00c270ffaf6a67c8f3f5d10ecb96f03~aqmUktXkg2329323293eusmtrp1N;
	Thu, 20 Jun 2024 08:52:39 +0000 (GMT)
X-AuditID: cbfec7f2-c11ff70000002598-09-6673edd76d9e
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 95.07.08810.7DDE3766; Thu, 20
	Jun 2024 09:52:39 +0100 (BST)
Received: from localhost (unknown [106.120.51.111]) by eusmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240620085238eusmtip126b4ed11f10492c445ef3bb682b99695~aqmUWhcd00284502845eusmtip1N;
	Thu, 20 Jun 2024 08:52:38 +0000 (GMT)
From: Lukasz Stelmach <l.stelmach@samsung.com>
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>,  Rob Herring
	<robh@kernel.org>,  Conor Dooley <conor+dt@kernel.org>,  Anand Moon
	<linux.amoon@gmail.com>,  Olivia Mackall <olivia@selenic.com>,  Herbert Xu
	<herbert@gondor.apana.org.au>,  Alim Akhtar <alim.akhtar@samsung.com>,
	linux-samsung-soc@vger.kernel.org,  linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] hwrng: exynos: Improve coding style
Date: Thu, 20 Jun 2024 10:52:38 +0200
In-Reply-To: <20240618204523.9563-3-semen.protsenko@linaro.org> (Sam
	Protsenko's message of "Tue, 18 Jun 2024 15:45:18 -0500")
Message-ID: <oypijdfrt8t2qx.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
	protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsWy7djPc7rX3xanGTz6pWDxYN42Nos1e88x
	Wcw/co7VovuVjMXLWffYLDY9vsZqcf/eTyaLy7vmsFnMOL+PyWLdxlvsFvfP9DBa/N+zg93i
	ed8+Jgdej52z7rJ7bDug6rFpVSebx51re9g8Ni+p9+jbsorRo+/lBkaPz5vkAjiiuGxSUnMy
	y1KL9O0SuDKeL3vPXnBPs6L55jv2Bsb9Sl2MnBwSAiYSS6/9Yeti5OIQEljBKHHq+zxWCOcL
	o8Sk6QugMp8ZJb5MP8YG03JtyW1GEFtIYDmjRN83Z4iiF4wS5/YvAyri4GAT0JNYuzYCpEYE
	yFw38xU7iM0ssI9ZYtPfQJASYQF7iZmLOUHCLAKqEvO/trOAjOEUaGCUWDDxGStIglfAXOLF
	7fdgu0QFLCWOb21ng4gLSpyc+YQFYmauxMzzbxhBmiUEtnNKbDt5ix1kgYSAi8SJZTYQNwtL
	vDq+hR3ClpE4PbmHBaK+nVGi6cpCVghnAqPE544mJogqa4k7535BfewoceXYSTaIoXwSN94K
	Qizmk5i0bTozRJhXoqNNCKJaRWJd/x4WCFtKovfVCkYI20Pi9rGt0NCdxCjx/+tm1gmMCrOQ
	/DMLyT+zgMYyC2hKrN+lDxHWlli28DUzhG0rsW7de5YFjKyrGMVTS4tz01OLDfNSy/WKE3OL
	S/PS9ZLzczcxAhPe6X/HP+1gnPvqo94hRiYOxkOMKkDNjzasvsAoxZKXn5eqJML7vKsoTYg3
	JbGyKrUoP76oNCe1+BCjNAeLkjivaop8qpBAemJJanZqakFqEUyWiYNTqoFpwiHt7yybk86E
	LXVcZlhrwTTRt3qpblrGIi6miIc6MVMFbuysP197/tqx/+cvml95a1S4UNjt2I/p8U2B/tHu
	3eo7PAL5ztgoGh/4EtLNl7bv69tlCXPn267eOd8hwGEHl6rxp/hJpg+Uf+5bXxzxSnT/GfeI
	Xf9CuDdviM3jf7nDRJPd3/hgy6UM3vW7p0m32b098FjGOjhnCveOEB6lh5Z9Xauk0k6cfTE/
	8dUOVsFtXL+vzVq8Pvn+PIsT6pMWbFdSK52rILzlo09abo7Xmn3nxPzYGqfMs99apZBYtma9
	9dM/XLunHZldbNjS6z931t2qstczHv5lNp9WumjCJ75OLS/D/DNblcwPZ7/ZpsRSnJFoqMVc
	VJwIAIwe7GPzAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t/xu7rX3xanGbxpZbF4MG8bm8WaveeY
	LOYfOcdq0f1KxuLlrHtsFpseX2O1uH/vJ5PF5V1z2CxmnN/HZLFu4y12i/tnehgt/u/ZwW7x
	vG8fkwOvx85Zd9k9th1Q9di0qpPN4861PWwem5fUe/RtWcXo0fdyA6PH501yARxRejZF+aUl
	qQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF+nYJehnPl71nL7inWdF8
	8x17A+N+pS5GTg4JAROJa0tuM3YxcnEICSxllJi4/C17FyMHUEJKYuXcdIgaYYk/17rYIGqe
	MUpsPzCJDaSGTUBPYu3aCJAaESBz3cxX7CA1zAIHmSUuPe5hAqkRFrCXmLmYE6RGSMBOYsXr
	9ewgNouAqsT8r+0sIPWcAg2MEgsmPmMFSfAKmEu8uP2eEcQWFbCUOL61nQ0iLihxcuYTFhCb
	WSBb4uvq58wTGAVmIUnNQpKaBbSaWUBTYv0ufYiwtsSyha+ZIWxbiXXr3rMsYGRdxSiSWlqc
	m55bbKhXnJhbXJqXrpecn7uJERit24793LyDcd6rj3qHGJk4GA8xqgB1Ptqw+gKjFEtefl6q
	kgjv866iNCHelMTKqtSi/Pii0pzU4kOMpkC/TWSWEk3OB6aRvJJ4QzMDU0MTM0sDU0szYyVx
	Xs+CjkQhgfTEktTs1NSC1CKYPiYOTqkGphkGD98dO+CkGLtb8UeAf3HdloxWbwblOTPvSUfO
	PBy77WnMQeU7/u/SXiW73w8LOTGpwDp7Tmg50waFD62XdJluuKWZuH+1tws91n3uZJNeGnOr
	7+ef2Ytni4pv03z1LUehZHuQffp+3vmHy6c5rOJKNuyysD2cnZTobG4vdn3pCkXVvZHTV3sF
	bXngKDE1NOFU0s4tCRlNT5WcVV7brWLxPrTfbGvLxAXBRzNTJdecP9Ru0SMbnJp6TCVFUl10
	b6yb57Vu7rqZh+dx/j6RmLN8g1O7t07G+f07ZjEs2lwqL+orU36MYUowS9bOiJBALb2HF8P/
	yU75vOvwC/Z9FixLZt+uEO13mZ+bNXGiEktxRqKhFnNRcSIAgY8NWWsDAAA=
X-CMS-MailID: 20240620085239eucas1p1d49a6bae77e1fc857e4459f87c619a83
X-Msg-Generator: CA
X-RootMTR: 20240620085239eucas1p1d49a6bae77e1fc857e4459f87c619a83
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240620085239eucas1p1d49a6bae77e1fc857e4459f87c619a83
References: <20240618204523.9563-3-semen.protsenko@linaro.org>
	<CGME20240620085239eucas1p1d49a6bae77e1fc857e4459f87c619a83@eucas1p1.samsung.com>

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2024-06-18 wto 15:45>, when Sam Protsenko wrote:
> Fix obvious style issues. Some of those were found with checkpatch, and
> some just contradict the kernel coding style guide.
>
> No functional change.
>
> Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
> Changes in v2:
>   - Added Krzysztof's R-b tag
>
>  drivers/char/hw_random/exynos-trng.c | 61 +++++++++++++---------------
>  1 file changed, 29 insertions(+), 32 deletions(-)
>

Acked-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>

> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_rando=
m/exynos-trng.c
> index 0ed5d22fe667..88a5088ed34d 100644
> --- a/drivers/char/hw_random/exynos-trng.c
> +++ b/drivers/char/hw_random/exynos-trng.c
> @@ -23,45 +23,41 @@
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>=20=20
> -#define EXYNOS_TRNG_CLKDIV         (0x0)
> -
> -#define EXYNOS_TRNG_CTRL           (0x20)
> -#define EXYNOS_TRNG_CTRL_RNGEN     BIT(31)
> -
> -#define EXYNOS_TRNG_POST_CTRL      (0x30)
> -#define EXYNOS_TRNG_ONLINE_CTRL    (0x40)
> -#define EXYNOS_TRNG_ONLINE_STAT    (0x44)
> -#define EXYNOS_TRNG_ONLINE_MAXCHI2 (0x48)
> -#define EXYNOS_TRNG_FIFO_CTRL      (0x50)
> -#define EXYNOS_TRNG_FIFO_0         (0x80)
> -#define EXYNOS_TRNG_FIFO_1         (0x84)
> -#define EXYNOS_TRNG_FIFO_2         (0x88)
> -#define EXYNOS_TRNG_FIFO_3         (0x8c)
> -#define EXYNOS_TRNG_FIFO_4         (0x90)
> -#define EXYNOS_TRNG_FIFO_5         (0x94)
> -#define EXYNOS_TRNG_FIFO_6         (0x98)
> -#define EXYNOS_TRNG_FIFO_7         (0x9c)
> -#define EXYNOS_TRNG_FIFO_LEN       (8)
> -#define EXYNOS_TRNG_CLOCK_RATE     (500000)
> -
> +#define EXYNOS_TRNG_CLKDIV		0x0
> +
> +#define EXYNOS_TRNG_CTRL		0x20
> +#define EXYNOS_TRNG_CTRL_RNGEN		BIT(31)
> +
> +#define EXYNOS_TRNG_POST_CTRL		0x30
> +#define EXYNOS_TRNG_ONLINE_CTRL		0x40
> +#define EXYNOS_TRNG_ONLINE_STAT		0x44
> +#define EXYNOS_TRNG_ONLINE_MAXCHI2	0x48
> +#define EXYNOS_TRNG_FIFO_CTRL		0x50
> +#define EXYNOS_TRNG_FIFO_0		0x80
> +#define EXYNOS_TRNG_FIFO_1		0x84
> +#define EXYNOS_TRNG_FIFO_2		0x88
> +#define EXYNOS_TRNG_FIFO_3		0x8c
> +#define EXYNOS_TRNG_FIFO_4		0x90
> +#define EXYNOS_TRNG_FIFO_5		0x94
> +#define EXYNOS_TRNG_FIFO_6		0x98
> +#define EXYNOS_TRNG_FIFO_7		0x9c
> +#define EXYNOS_TRNG_FIFO_LEN		8
> +#define EXYNOS_TRNG_CLOCK_RATE		500000
>=20=20
>  struct exynos_trng_dev {
> -	struct device    *dev;
> -	void __iomem     *mem;
> -	struct clk       *clk;
> -	struct hwrng rng;
> +	struct device	*dev;
> +	void __iomem	*mem;
> +	struct clk	*clk;
> +	struct hwrng	rng;
>  };
>=20=20
>  static int exynos_trng_do_read(struct hwrng *rng, void *data, size_t max,
>  			       bool wait)
>  {
> -	struct exynos_trng_dev *trng;
> +	struct exynos_trng_dev *trng =3D (struct exynos_trng_dev *)rng->priv;
>  	int val;
>=20=20
>  	max =3D min_t(size_t, max, (EXYNOS_TRNG_FIFO_LEN * 4));
> -
> -	trng =3D (struct exynos_trng_dev *)rng->priv;
> -
>  	writel_relaxed(max * 8, trng->mem + EXYNOS_TRNG_FIFO_CTRL);
>  	val =3D readl_poll_timeout(trng->mem + EXYNOS_TRNG_FIFO_CTRL, val,
>  				 val =3D=3D 0, 200, 1000000);
> @@ -122,7 +118,7 @@ static int exynos_trng_probe(struct platform_device *=
pdev)
>=20=20
>  	trng->rng.init =3D exynos_trng_init;
>  	trng->rng.read =3D exynos_trng_do_read;
> -	trng->rng.priv =3D (unsigned long) trng;
> +	trng->rng.priv =3D (unsigned long)trng;
>=20=20
>  	platform_set_drvdata(pdev, trng);
>  	trng->dev =3D &pdev->dev;
> @@ -175,7 +171,7 @@ static int exynos_trng_probe(struct platform_device *=
pdev)
>=20=20
>  static void exynos_trng_remove(struct platform_device *pdev)
>  {
> -	struct exynos_trng_dev *trng =3D  platform_get_drvdata(pdev);
> +	struct exynos_trng_dev *trng =3D platform_get_drvdata(pdev);
>=20=20
>  	clk_disable_unprepare(trng->clk);
>=20=20
> @@ -204,7 +200,7 @@ static int exynos_trng_resume(struct device *dev)
>  }
>=20=20
>  static DEFINE_SIMPLE_DEV_PM_OPS(exynos_trng_pm_ops, exynos_trng_suspend,
> -			 exynos_trng_resume);
> +				exynos_trng_resume);
>=20=20
>  static const struct of_device_id exynos_trng_dt_match[] =3D {
>  	{
> @@ -225,6 +221,7 @@ static struct platform_driver exynos_trng_driver =3D {
>  };
>=20=20
>  module_platform_driver(exynos_trng_driver);
> +
>  MODULE_AUTHOR("=C5=81ukasz Stelmach");
>  MODULE_DESCRIPTION("H/W TRNG driver for Exynos chips");
>  MODULE_LICENSE("GPL v2");

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmZz7dYACgkQsK4enJil
gBBw3QgAheqPc/spzIa3FzV4IkXxMMieQGeC8cFONbvNuC6beSyL2S4JakUCDh1U
YRB0oiKYdTLtD3PsipkWfqMIU5XDx8ElygxT9uWtH9smZk9UBSdpxQNNk9XWx0b6
sEsYFusIFA5WLJrn0hxHXWkUXMpVlqqJCyB1Jd15AM0Z/RphVd+M8v+UTB5Ghrmg
/GxzRUHBZ9xfTsaq6/VbBR+BoTyUPP9T18le59L6D83hJfxdmEdJtqJ0V4O1b6SO
YdrRJGGP5su4p1zedtEkywivHJukIdTZooZEngJnXHzKrKKQ7/BZeH7j9NpPqL6W
7mbAyYFk90AhnFqXr44I86FyeHPJ8Q==
=gpkX
-----END PGP SIGNATURE-----
--=-=-=--

Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1C51A3BD3;
	Thu, 20 Jun 2024 13:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718891176; cv=none; b=WEcb4eF3eoGz9r+MMnJ1kPQpcMjJG8wZbV2E/TR/hUlF27ZUzGuHBA7VZ6UqqJtqv4qYypeWayt9gSQYZKR199DEJGbUyLKDR6JRByr4L1xkk7RGq9mNI1QjPpj43FQB3F7VFAZ8ngm+WTtAZur/KxNOK1nTD2RkjUcU4g4awAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718891176; c=relaxed/simple;
	bh=dJnp2EW+2R3q8xyoX0QitfjOP8taMkV4+hsyCujZ1e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type:References; b=HNSGxjIcFjZZVlikoV47FJQgRduB0DrRBVl7ZfcBh8ZSzi7qJa/msfKDMiO/Z3mtz1K2LvFeNe/YgFeZbuJ57b2Vs3g5ZtV0p6FaqiONa8p0aLsC/ryYb2x8CNeJ54trAdAeu7lU0OxsWSG5jobWS79yX0fNnix91sJnKqlGX1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=pfFi5h+H; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pfFi5h+H"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240620134611euoutp02a96cd9ca107e37de619283a51f669cae~aumm3LN8t2421724217euoutp02B;
	Thu, 20 Jun 2024 13:46:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240620134611euoutp02a96cd9ca107e37de619283a51f669cae~aumm3LN8t2421724217euoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1718891171;
	bh=iFqp3Vmg2kXZw5nz0hjIfH1Vkk6Dw440kokEiE+YTgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfFi5h+H8lPp007wsRqpVpZNLS5nLEMCmpdUAME44CgSbKH9/QtZXkJlFLIPUqU27
	 fzMFL4P/MJyv9BkFP+rGX07Citxen2F4/63K3Zqq1dPcsd4/wXOsfofmnAJ2Ez5sxL
	 eXR5Kv9RbPSXgeXtkkuoF/hWYvXT+bzb5DJ2EDM0=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240620134610eucas1p26751fca5e1265a5eb54a3aad17522d62~aummjdKZ83240632406eucas1p2R;
	Thu, 20 Jun 2024 13:46:10 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id A8.E4.09620.2A234766; Thu, 20
	Jun 2024 14:46:10 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240620134610eucas1p2fbcd7218bc220bf568ea117acf2f4781~aummJRJA03240632406eucas1p2P;
	Thu, 20 Jun 2024 13:46:10 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240620134610eusmtrp10775d1c759a9d9dc121cf4e65390464b~aummIap1-0536305363eusmtrp1V;
	Thu, 20 Jun 2024 13:46:10 +0000 (GMT)
X-AuditID: cbfec7f5-d31ff70000002594-53-667432a2088e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 85.35.09010.2A234766; Thu, 20
	Jun 2024 14:46:10 +0100 (BST)
Received: from localhost (unknown [106.120.51.111]) by eusmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240620134609eusmtip229d220fbda7a358d93723c417de4002e~auml6JyNF2776327763eusmtip2Q;
	Thu, 20 Jun 2024 13:46:09 +0000 (GMT)
From: Lukasz Stelmach <l.stelmach@samsung.com>
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>,  Rob Herring
	<robh@kernel.org>,  Conor Dooley <conor+dt@kernel.org>,  Anand Moon
	<linux.amoon@gmail.com>,  Olivia Mackall <olivia@selenic.com>,  Herbert Xu
	<herbert@gondor.apana.org.au>,  Alim Akhtar <alim.akhtar@samsung.com>,
	linux-samsung-soc@vger.kernel.org,  linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/7] hwrng: exynos: Add SMC based TRNG operation
Date: Thu, 20 Jun 2024 15:46:02 +0200
In-Reply-To: <20240618204523.9563-6-semen.protsenko@linaro.org> (Sam
	Protsenko's message of "Tue, 18 Jun 2024 15:45:21 -0500")
Message-ID: <oypijdbk3vu3qd.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
	protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsWy7djPc7qLjErSDHa/V7R4MG8bm8WaveeY
	LOYfOcdq0f1KxuLlrHtsFpseX2O1uH/vJ5PF5V1z2CxmnN/HZLFu4y12i/tnehgt/u/ZwW7x
	vG8fkwOvx85Zd9k9th1Q9di0qpPN4861PWwem5fUe/RtWcXo0fdyA6PH501yARxRXDYpqTmZ
	ZalF+nYJXBmXp/xkLmgVq+i6s5K1gfGEUBcjJ4eEgInEpqdTmLoYuTiEBFYwSuy9cIURwvnC
	KPF65jY2COczo8TatVsZYVr2H7wC1bKcUaKzaT4rSEJI4AWjxILNsl2MHBxsAnpADREgYREg
	c93MV+wgNrPAPmaJTX8DQWxhAXeJiWdmMIPYLAKqEjufn2UGmckp0MAoceZ9GzPIHF4Bc4mJ
	DdkgNaIClhLHt7azgdi8AoISJ2c+YYGYmSsx8/wbsKslBDZzSpw79Ikd4lAXiReP1kIdLSzx
	6vgWqLiMxOnJPSwQDe2MEk1XFrJCOBMYJT53NDFBVFlL3Dn3iw3CdpR4+e4rE8hFEgJ8Ejfe
	CkJs5pOYtG06M0SYV6KjDRqmKhLr+vewQNhSEr2vVkDd4CGx7O5ZaPBOYpRYuesv8wRGhVlI
	HpqF5KFZQGOZBTQl1u/ShwhrSyxb+JoZwraVWLfuPcsCRtZVjOKppcW56anFxnmp5XrFibnF
	pXnpesn5uZsYgSnv9L/jX3cwrnj1Ue8QIxMH4yFGFaDmRxtWX2CUYsnLz0tVEuF93lWUJsSb
	klhZlVqUH19UmpNafIhRmoNFSZxXNUU+VUggPbEkNTs1tSC1CCbLxMEp1cC0rPql/MSjTPJr
	731ZznVu5XTB9f/PzFi1VGLuRaOwrzNm25xk7S4WncX2I41pf2/qDKtAqeOZq3blXz74geml
	+zTFJQvSpy7l1lJxru+Y42LTp/R4beEP9XWHVyl5Ltz0dl3Rdffj38TZ4rrtfL/GBysZBWnn
	C9nkzJZb2dS7WCnuccDbhGkKpkeDedUfn//Soj49pOrMqfLoT212AovUo73M2mNMTbWfnnf6
	5ZTxZcrHCM/0G6aOCcG/bAXWsL64N6Gk+I5m4x8ZnSkq2kcv/X9XafNk7vHlnVcn7blR3KYa
	cGpx4O2OlfMOdnssO/hpT6CxwpEEg3UK/PzLlBTnbbRYpr9dPXOqqeSkY3KhSizFGYmGWsxF
	xYkA6W9K/vQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t/xe7qLjErSDDZ2sFk8mLeNzWLN3nNM
	FvOPnGO16H4lY/Fy1j02i02Pr7Fa3L/3k8ni8q45bBYzzu9jsli38Ra7xf0zPYwW//fsYLd4
	3rePyYHXY+esu+we2w6oemxa1cnmcefaHjaPzUvqPfq2rGL06Hu5gdHj8ya5AI4oPZui/NKS
	VIWM/OISW6VoQwsjPUNLCz0jE0s9Q2PzWCsjUyV9O5uU1JzMstQifbsEvYzLU34yF7SKVXTd
	WcnawHhCqIuRk0NCwERi/8ErTCC2kMBSRonmFs8uRg6guJTEyrnpECXCEn+udbF1MXIBlTxj
	lDhyrpcZpIZNQE9i7doIkBoRIHPdzFfsIDXMAgeZJS497gGbKSzgLjHxzAxmiPl2Egc/LWYD
	sVkEVCV2Pj/LDNLAKdDAKHHmfRvYUF4Bc4mJDdkgNaIClhLHt7aD1fMKCEqcnPmEBcRmFsiW
	+Lr6OfMERoFZSFKzkKRmAU1iFtCUWL9LHyKsLbFs4WtmCNtWYt269ywLGFlXMYqklhbnpucW
	G+kVJ+YWl+al6yXn525iBMbqtmM/t+xgXPnqo94hRiYOxkOMKkCdjzasvsAoxZKXn5eqJML7
	vKsoTYg3JbGyKrUoP76oNCe1+BCjKdBrE5mlRJPzgUkkryTe0MzA1NDEzNLA1NLMWEmc17Og
	I1FIID2xJDU7NbUgtQimj4mDU6qByWjXoWv6/6yc2i32+Kvu7vqen5/Cxn/Mm7OI+4RP58Rn
	grsVqq8EnrtQM/NUmVrA2WdXX6/fd8up+azD/JnB/3qlH1+fuF0oP/xqoUuXX7XnHOvL0qlN
	NqVawcvsuYS3cT5y/xidmOddMeVNUEzV9fvtVzzm8QjOcfazv5+QP9GOed6D3Zkzqys8z6y8
	xySatbCxcNriB5a3kpYlaXxmzjkTv39Nv9r54ns7G0RU9iR+jl37zusj5wTGqsd2U82vqq1/
	dDj39ZTeCg0bpYLHL3qni/MFxS+TUHjLqxIm7OYl3yt+55Vh8LbDTxZcubyl/u9tI8m/Wtb/
	NjSxrZxtn6TVfoHToCpG9szWcxseKrEUZyQaajEXFScCAE/S1AZqAwAA
X-CMS-MailID: 20240620134610eucas1p2fbcd7218bc220bf568ea117acf2f4781
X-Msg-Generator: CA
X-RootMTR: 20240620134610eucas1p2fbcd7218bc220bf568ea117acf2f4781
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240620134610eucas1p2fbcd7218bc220bf568ea117acf2f4781
References: <20240618204523.9563-6-semen.protsenko@linaro.org>
	<CGME20240620134610eucas1p2fbcd7218bc220bf568ea117acf2f4781@eucas1p2.samsung.com>

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2024-06-18 wto 15:45>, when Sam Protsenko wrote:
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
> Changes in v2:
>   - Used the "reversed Christmas tree" style in the variable declaration
>     block in exynos_trng_do_read_smc()
>   - Renamed .quirks to .flags in the driver structure
>   - Added Krzysztof's R-b tag
>
>  drivers/char/hw_random/exynos-trng.c | 133 +++++++++++++++++++++++++--
>  1 file changed, 123 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_rando=
m/exynos-trng.c
> index 99a0b271ffb7..497d6018c6ba 100644
> --- a/drivers/char/hw_random/exynos-trng.c
> +++ b/drivers/char/hw_random/exynos-trng.c
> @@ -10,6 +10,7 @@
>   * Krzysztof Koz=C5=82owski <krzk@kernel.org>
>   */

[...]

> +static int exynos_trng_init_smc(struct hwrng *rng)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_smc(SMC_CMD_RANDOM, HWRNG_INIT, 0, 0, 0, 0, 0, 0, &res);
> +	if (res.a0 !=3D HWRNG_RET_OK)
> +		return -EIO;
> +
> +	return 0;
> +}
> +

Does this driver requiers some vendor-specifig bootloading code?
I am testing the code on a WinLink E850-96 board booted with the
upstream u-boot and it fails during init (res0.a is -1).

[    1.883413] exynos-trng 12081400.rng: Could not register hwrng device
[    1.893394] exynos-trng 12081400.rng: probe with driver exynos-trng fail=
ed with error -5

If an additional code outside the kernel is required for this to run,
then maybe the error message should reflect that.

Kind regards,
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmZ0MpoACgkQsK4enJil
gBBttwgAiuVydgU5PyyNzMPe0P1nzHAgaj19otvTg/m/h3TtY895/ILzYjSZ15x1
DO9Mb2tlW3z1F7f2y1xUcOWT/zcam6fga074wnx5llsPe6+burPhrt40r09Fy2hF
U1CpvLyEVuuFnifaSOLKfxUptC5d0daB/3dXgrPaieIk96JSi18rZZejmb+BRcQ+
6sVwrnm6MM+H0UsZ1o8QydCVAdO7l/v+cOa/ix9yEJtCDFPqQyqJR8LEA6TaXlxH
icXzjvhMqiwYo62HGl48W97hkuP/AATqBqil8CT5kuYDEN+gq5/2UHPsQPYDciki
FDuJ3bFCfH8VTAGb0EvBC+UAadOY5g==
=Dl6f
-----END PGP SIGNATURE-----
--=-=-=--

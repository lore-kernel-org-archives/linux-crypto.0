Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD9740858;
	Thu, 20 Jun 2024 08:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718873276; cv=none; b=s/B652ecpI8VndZsqb3KCPifVNXCXCGdbjmpbBN1XBLA9mR402FeS4zftmGX0jH3H710Yj8WMUA2txxPNN+065mWmoY+UJpXZKctnKD9uoXkAm5RNsPi8kcJmSIzb3G73bPvz046Q0o7B6ebX6tuII40HhXrd86Gd9kKZYMv0To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718873276; c=relaxed/simple;
	bh=TBVTI/0PYjZSNwLs8zOMBanM4w1UfbWtOpjIx22X/S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type:References; b=VQbRjLSm4Qb1roC7yuLhd5ASR39aynhOz/pRXMI0spw8N+Pv1Z76WeQOZcpUdkPLrdik/UciEfKPXSfSPxGCmmzsrhjNGak8Bc0lgAfYz3+G62lhCKhEmLYPKWhRs8hZHDBH3/sNyxad5aWO7R1YbVngb0ph9S6/tj45HwP6uEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=CnCwWcPG; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CnCwWcPG"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240620084750euoutp022a61bdb452905d0d93967b59e85b60ff~aqiHwNbLt1458414584euoutp02w;
	Thu, 20 Jun 2024 08:47:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240620084750euoutp022a61bdb452905d0d93967b59e85b60ff~aqiHwNbLt1458414584euoutp02w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1718873270;
	bh=2xH7UaeSHxwlKbfKFdgiBYrxzRVkCcqlRlIhfGGkv3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnCwWcPGEQLlrmu5GiGFmqg0ZxD5CVc+j6jPG5uuRr9gCAk7ZPCub9S5bgAmQfeoS
	 glnYI8j0c2Va+5WGibE3KKBIp7FN49iE7HuZaLtE3SR3AYhmtU7UPUuVXg9iBr3H4Y
	 BexdtWc8Ke8ws3TU2C6pXr/R9dncumT+S7Dkx+F0=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240620084750eucas1p1e7fb1bcad2283f58e3f6041152a56a46~aqiHegUUU0512305123eucas1p1O;
	Thu, 20 Jun 2024 08:47:50 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id CE.08.09624.6BCE3766; Thu, 20
	Jun 2024 09:47:50 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240620084749eucas1p18f46cc9aa0983afb75e1677b399d12f8~aqiG47y3k0326503265eucas1p1Z;
	Thu, 20 Jun 2024 08:47:49 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240620084749eusmtrp10b61c85089f15485d410823a8fd41c31~aqiG4BP6H2065920659eusmtrp1C;
	Thu, 20 Jun 2024 08:47:49 +0000 (GMT)
X-AuditID: cbfec7f2-c11ff70000002598-16-6673ecb6e85e
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 41.33.09010.5BCE3766; Thu, 20
	Jun 2024 09:47:49 +0100 (BST)
Received: from localhost (unknown [106.120.51.111]) by eusmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240620084749eusmtip121f8870fba034cffe60389c2be011cc0~aqiGnuu2i3165231652eusmtip1W;
	Thu, 20 Jun 2024 08:47:49 +0000 (GMT)
From: Lukasz Stelmach <l.stelmach@samsung.com>
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>,  Rob Herring
	<robh@kernel.org>,  Conor Dooley <conor+dt@kernel.org>,  Anand Moon
	<linux.amoon@gmail.com>,  Olivia Mackall <olivia@selenic.com>,  Herbert Xu
	<herbert@gondor.apana.org.au>,  Alim Akhtar <alim.akhtar@samsung.com>,
	linux-samsung-soc@vger.kernel.org,  linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] hwrng: exynos: Enable Exynos850 support
Date: Thu, 20 Jun 2024 10:47:44 +0200
In-Reply-To: <20240618204523.9563-7-semen.protsenko@linaro.org> (Sam
	Protsenko's message of "Tue, 18 Jun 2024 15:45:22 -0500")
Message-ID: <oypijdjzikt2z3.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
	protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsWy7djPc7rb3hSnGRx/yWnxYN42Nos1e88x
	Wcw/co7VovuVjMXLWffYLDY9vsZqcf/eTyaLy7vmsFnMOL+PyWLdxlvsFvfP9DBa/N+zg93i
	ed8+Jgdej52z7rJ7bDug6rFpVSebx51re9g8Ni+p9+jbsorRo+/lBkaPz5vkAjiiuGxSUnMy
	y1KL9O0SuDK+7N7GXvCfr2LTnnVMDYyfeboYOTkkBEwkuo7sZu9i5OIQEljBKLF753RGCOcL
	o0RP7x02COczo8TSM83sMC0ftr+DqlrOKHF+3TdWCOcFo8SDG5OYuxg5ONgE9CTWro0AaRAB
	MtfNfAXWzCywj1li099AEFtYwFmiec1jsDiLgKrE1+MNYHdwCjQwSnz6fAMswStgLnFh00pW
	EFtUwFLi+NZ2Noi4oMTJmU9YIIbmSsw8/wbsIgmB7ZwSNyZdYoU41UXi14LdUGcLS7w6vgXK
	lpE4PbmHBaKhnVGi6cpCVghnAqPE544mJogqa4k7536xQdiOEh+/HGIHeU1CgE/ixltBiM18
	EpO2TWeGCPNKdLQJQVSrSKzr38MCYUtJ9L5awQhhe0icW/EEGtqTGCXONfezT2BUmIXkoVlI
	HpoFNJZZQFNi/S59iLC2xLKFr5khbFuJdevesyxgZF3FKJ5aWpybnlpsmJdarlecmFtcmpeu
	l5yfu4kRmPZO/zv+aQfj3Fcf9Q4xMnEwHmJUAWp+tGH1BUYplrz8vFQlEd7nXUVpQrwpiZVV
	qUX58UWlOanFhxilOViUxHlVU+RThQTSE0tSs1NTC1KLYLJMHJxSDUyCti31/z0Xb/F02MZx
	8NWZaV/7tCN38U9ymrLlylPeJQEufzdkylrqzHTkerjh1X27NYpXznmxbPLY+ebBAnOvqw7b
	K4rXpTCfYVy0mCva+P/Vm4du5j4431a3PcDWf8uS694pe5155gQE2v9wd7sc77rDfoK/tP8i
	2xuvZ9x/66at91F54d7a/CBrnT91eyY93FD/eYWz9spkxz1Ox9wmNqTNFTZmz3z6Zf2zV+GX
	Chd0NrUE5DVn8F1/erm7ks/5xtT20y8t5lZIOWZuD3zoOMs5Ma7neXzCbs+8TeqZJbF6Rk9P
	J7UWcG9Uvp7inLaa/+re0i1vRKTnhVxZnHn0svOZNpUzRl9nH93tpnVbiaU4I9FQi7moOBEA
	xZ5FWfYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t/xu7pb3xSnGfTtkLZ4MG8bm8WaveeY
	LOYfOcdq0f1KxuLlrHtsFpseX2O1uH/vJ5PF5V1z2CxmnN/HZLFu4y12i/tnehgt/u/ZwW7x
	vG8fkwOvx85Zd9k9th1Q9di0qpPN4861PWwem5fUe/RtWcXo0fdyA6PH501yARxRejZF+aUl
	qQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF+nYJehlfdm9jL/jPV7Fp
	zzqmBsbPPF2MnBwSAiYSH7a/Y+xi5OIQEljKKPH56Qq2LkYOoISUxMq56RA1whJ/rnWxQdQ8
	Y5R4OOMHWA2bgJ7E2rURIDUiQOa6ma/YQWqYBQ4yS1x63MMEkhAWcJZoXvOYHcQWErCTaLt0
	gxnEZhFQlfh6vAGsgVOggVHi0+cbYEW8AuYSFzatZAWxRQUsJY5vbWeDiAtKnJz5hAXEZhbI
	lvi6+jnzBEaBWUhSs5CkZgHdxyygKbF+lz5EWFti2cLXzBC2rcS6de9ZFjCyrmIUSS0tzk3P
	LTbSK07MLS7NS9dLzs/dxAiM123Hfm7Zwbjy1Ue9Q4xMHIyHGFWAOh9tWH2BUYolLz8vVUmE
	93lXUZoQb0piZVVqUX58UWlOavEhRlOg3yYyS4km5wMTSV5JvKGZgamhiZmlgamlmbGSOK9n
	QUeikEB6YklqdmpqQWoRTB8TB6dUA9PSUxVKDxvvzPmmkVvOtzTGJuKhDe95vs/p6xmOfPmp
	uT/m0LWOfPXdYiZvD7YU3Er/bWzl6+oUceZRI/OpPdyHrZd0qcfI25Q8OZtRcN0vXXdHWEfd
	d2bfM2tbUqavS52kZHxlZ9mVyLmsi/Pa5t22rZ3izzC9O3HmrwWLc7IS2C++q7B9Yj/t14oq
	k12Pbb6p19p9/TwzWzj3ilW5in3soVc/t8Rc+5W/LXXqsev3eIL+yijm7nIU+DHlxL/O/zra
	lz69Otd851fS3hy53LItyRNeNc/Nm5nLWLfwzDx34f95BaJhq3+t2sK/4luNa3FXqa7ShpkJ
	MpqOF9/rPtirt2BFgc/F1BevlZdwyP5UYinOSDTUYi4qTgQA8UnVOmwDAAA=
X-CMS-MailID: 20240620084749eucas1p18f46cc9aa0983afb75e1677b399d12f8
X-Msg-Generator: CA
X-RootMTR: 20240620084749eucas1p18f46cc9aa0983afb75e1677b399d12f8
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240620084749eucas1p18f46cc9aa0983afb75e1677b399d12f8
References: <20240618204523.9563-7-semen.protsenko@linaro.org>
	<CGME20240620084749eucas1p18f46cc9aa0983afb75e1677b399d12f8@eucas1p1.samsung.com>

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2024-06-18 wto 15:45>, when Sam Protsenko wrote:
> Add Exynos850 compatible and its driver data. It's only possible to
> access TRNG block via SMC calls in Exynos850, so specify that fact using
> EXYNOS_SMC flag in the driver data.
>
> Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
> ---
> Changes in v2:
>   - Changed QUIRK_SMC to EXYNOS_SMC to reflect the name change in the
>     previous patch
>
>  drivers/char/hw_random/exynos-trng.c | 3 +++
>  1 file changed, 3 insertions(+)
>

Acked-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>

> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_rando=
m/exynos-trng.c
> index 497d6018c6ba..841598037cce 100644
> --- a/drivers/char/hw_random/exynos-trng.c
> +++ b/drivers/char/hw_random/exynos-trng.c
> @@ -313,6 +313,9 @@ static DEFINE_SIMPLE_DEV_PM_OPS(exynos_trng_pm_ops, e=
xynos_trng_suspend,
>  static const struct of_device_id exynos_trng_dt_match[] =3D {
>  	{
>  		.compatible =3D "samsung,exynos5250-trng",
> +	}, {
> +		.compatible =3D "samsung,exynos850-trng",
> +		.data =3D (void *)EXYNOS_SMC,
>  	},
>  	{ },
>  };

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmZz7LAACgkQsK4enJil
gBA4ZQf9H/yTan9r7idWXpguT1GA+QwtJfaZDQynWcWKu6JdXndL54/0k5A5WQsC
KAItmS8Wzp5CDEUY2uTO/o3O7vSuuAMWC8yY1Gz6OyA9A6RZ1wYlSdYSyPO7eu2Q
+lAaSn+hx6EgEWeAmsN8e67FhbRu7qvY/+EaYbobCGDfoBTVw4d1eX1ZmAEVY9+W
qqvMyOlFq8KVxA6I+kYdkm9/Yj6AsxcZMSfZMLf/GfFwgkySTwnxxTz7nFpihYUc
fEHU8L8IqEaU6EFxkg6tmkx2y0nYnBSkEuQ5/0LYndCqIH8ts+cBBExNNrpVNRz3
peJy+ClnFMVwNxSK64LK9iBItsDq/w==
=DvxN
-----END PGP SIGNATURE-----
--=-=-=--

Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E2D17994D;
	Fri, 21 Jun 2024 22:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719007880; cv=none; b=pzVbJFyc7GgmrGMvj2n4xk47V9Gs0wB7T7NiCRFZj7ORkuNIT3LM8tMQim3IgdLGKZF6oVVEl62XFFVd3ViOYXZJ/uNSgv69Vc1BWgA7xQ/efJCqdczNRo2h4e1GXvUvXAW56UGLiEyJ9bwQ0bpl31W+Wt6koljrBOWa5Jh+pN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719007880; c=relaxed/simple;
	bh=mV6veQvBSVZGiR3xo5cdefnw4qfrDQjKLK17U/ZrO8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type:References; b=QJbdCq+twfVungNR5AZ700tFX5wf+RB8bPeY6DTTK8/W6Y/DaslXpF/7LGFyCE9PhsopBfxRkUkyqG3vRIOi8qh4+XgOsPFtjJ4F2tveGQ/PSGfJBQF6u9Nrk56Jk5WbReqSOAPIDKxdc76AG/WP8aL9MXqFuzOk+o8pMHnBkGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ojYttjdp; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ojYttjdp"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240621221114euoutp02aecb4a22d2be77ced28e8adba6ccf953~bJI3r1vDv0587105871euoutp02F;
	Fri, 21 Jun 2024 22:11:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240621221114euoutp02aecb4a22d2be77ced28e8adba6ccf953~bJI3r1vDv0587105871euoutp02F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719007874;
	bh=rpw/+rqQyeBELIfc2VypYzoEKfduqjIshTrQXkgeMeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojYttjdpgiITv62rZQ4KZEHjmW5maj/BdMfWQqymsItG329RH3evyNyrIccg+0jC7
	 1Wkyy9ZORIlIHgTOIWFiGGUcSqR87J6h0ypvDhsyL9hYeR/17aP5NTDjbhL3WdMx0a
	 W6E7fKO5nM28pgrAlgtiRSsActhibhZ1KDpuhx5w=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240621221114eucas1p1332b18d860b299ca26338f984f60f305~bJI3dhQfd2302923029eucas1p1V;
	Fri, 21 Jun 2024 22:11:14 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 2B.4D.09875.28AF5766; Fri, 21
	Jun 2024 23:11:14 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240621221113eucas1p25c2fbadceef48913c4a7b164e6d14890~bJI2fff3q2956729567eucas1p2y;
	Fri, 21 Jun 2024 22:11:13 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240621221113eusmtrp235293c862385d342d098fbbc5da29c62~bJI2e2W0y2950329503eusmtrp2K;
	Fri, 21 Jun 2024 22:11:13 +0000 (GMT)
X-AuditID: cbfec7f4-11bff70000002693-5c-6675fa822165
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 83.07.08810.18AF5766; Fri, 21
	Jun 2024 23:11:13 +0100 (BST)
Received: from localhost (unknown [106.120.51.111]) by eusmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240621221113eusmtip146371b589bdadf3e854d3c5a593b57d0~bJI2MWLaq2567125671eusmtip1F;
	Fri, 21 Jun 2024 22:11:13 +0000 (GMT)
From: Lukasz Stelmach <l.stelmach@samsung.com>
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>,  Rob Herring
	<robh@kernel.org>,  Conor Dooley <conor+dt@kernel.org>,  Anand Moon
	<linux.amoon@gmail.com>,  Olivia Mackall <olivia@selenic.com>,  Herbert Xu
	<herbert@gondor.apana.org.au>,  Alim Akhtar <alim.akhtar@samsung.com>,
	linux-samsung-soc@vger.kernel.org,  linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,  Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v3 5/6] hwrng: exynos: Add SMC based TRNG operation
Date: Sat, 22 Jun 2024 00:10:57 +0200
In-Reply-To: <CAPLW+4njmKxXSMqNazX6t6LS=fHNh6Pi8_icF1=aPw27G0J3PQ@mail.gmail.com>
	(Sam Protsenko's message of "Fri, 21 Jun 2024 14:40:08 -0500")
Message-ID: <oypijdcyoarlou.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
	protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOKsWRmVeSWpSXmKPExsWy7djPc7pNv0rTDJb8FrN4MG8bm8WaveeY
	LOYfOcdq0f1KxuLlrHtsFpseX2O1uH/vJ5PF5V1z2CxmnN/HZLFu4y12i7VH7rJb3D/Tw2jx
	f88OdovnffuYHPg8ds66y+6x7YCqx6ZVnWwed67tYfPYvKTeo2/LKkaPvpcbGD0+b5IL4Iji
	sklJzcksSy3St0vgynh6rompYKNyxf65+9kaGHtkuhg5OSQETCQeLGpm72Lk4hASWMEocWnl
	f0YI5wujxK8n3VDOZ0aJ3xO7WGBaNp67xAKRWM4o0flqMZTzglFi066pQMM4ONgE9CTWro0A
	aRABMtfNfAW2g1ngDbPEvB3ngcaycwgLuEt8sgUpYRFQlZh2ZCMzSAmnwCRGiUXnVjKDJHgF
	zCWOtC5gBLFFBSwljm9tZ4OIC0qcnPkE7CBmgVyJmeffgF0qIbCbU+LJsiVMEJe6SPT3fWaE
	sIUlXh3fwg5hy0j83zmfCaKhnVGi6cpCVghnAqPE544mqG5riTvnfrFB2I4Slxe3MIN8JiHA
	J3HjrSDEZj6JSdumQ4V5JTrahCCqVSTW9e+BhpaURO+rFVA3eEic7nrNDAmsJcDwvXCJdQKj
	wiwkD81C8tAsoLHMApoS63fpQ4S1JZYtfM0MYdtKrFv3nmUBI+sqRvHU0uLc9NRio7zUcr3i
	xNzi0rx0veT83E2MwPR3+t/xLzsYl7/6qHeIkYmD8RCjClDzow2rLzBKseTl56UqifA+7ypK
	E+JNSaysSi3Kjy8qzUktPsQozcGiJM6rmiKfKiSQnliSmp2aWpBaBJNl4uCUamAKkj/g/jPL
	01541XTdrMUrbAJSNgmKvJlcKLZ28azgjVtPzO48XjmhMjb2IXuCvqsyd+jkrn0cVtuf5n9a
	Xtix8tamuit+7LxuRV8vOK2zNAnRPRDNef9S0JmjjxxnPz3ttbFgkdq+TQcN5yUFpi+97qGi
	YXRpy6NT9tqTzxo7XUv5sWO58pLJ6afWfjPQcX+1pSh615UDPC3xyVMFTkn4WYnHr54SKPqw
	78A682On9jxaInltie5UDxaJvXHa0o6GSZkPnVt2HX+9xCqmR8Koc6Vf7CY9NS5Rfz5thp2n
	Z929tMm998SmwrCwyx/Mzk9kY7JiuXrNsX23gXj+7VUZbwsPWk+c7jQzkm9j0qtdSizFGYmG
	WsxFxYkAl0EHFvoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t/xu7qNv0rTDP43C1o8mLeNzWLN3nNM
	FvOPnGO16H4lY/Fy1j02i02Pr7Fa3L/3k8ni8q45bBYzzu9jsli38Ra7xdojd9kt7p/pYbT4
	v2cHu8Xzvn1MDnweO2fdZffYdkDVY9OqTjaPO9f2sHlsXlLv0bdlFaNH38sNjB6fN8kFcETp
	2RTll5akKmTkF5fYKkUbWhjpGVpa6BmZWOoZGpvHWhmZKunb2aSk5mSWpRbp2yXoZTw918RU
	sFG5Yv/c/WwNjD0yXYycHBICJhIbz11i6WLk4hASWMoocf38LSCHAyghJbFybjpEjbDEn2td
	bBA1zxglvkxbwQRSwyagJ7F2bQRIjQiQuW7mK3aQGmaBj8wSP5+1ADWwcwgLuEt8sgUpERII
	kPi05Sw7iM0ioCox7chGZpByToFJjBKLzq1kBknwCphLHGldwAhiiwpYShzf2s4GEReUODnz
	CQuIzSyQLfF19XPmCYwCs5CkZiFJzQK6jllAU2L9Ln2IsLbEsoWvmSFsW4l1696zLGBkXcUo
	klpanJueW2yoV5yYW1yal66XnJ+7iREYtduO/dy8g3Heq496hxiZOBgPMaoAdT7asPoCoxRL
	Xn5eqpII7/OuojQh3pTEyqrUovz4otKc1OJDjKZAv01klhJNzgemk7ySeEMzA1NDEzNLA1NL
	M2MlcV7Pgo5EIYH0xJLU7NTUgtQimD4mDk6pBqZFZhKm/FbXit2Mi1coZQcHHPUSOHVZJ1rk
	qPSGg/VLb38TDQc610QlyH3CHIYnc1f7nP8zozJi7bcjb1KN989KsrTuyZrp+N0+XO/+yfPH
	PKpnpU7elPVf/1/l/ru5856tMVBzt/OYd7Htlcom+fUKRR5uZuJxzrVy9z/GFjD8kj8w5d6p
	tJr8uDTe/1qvHqwU5+uTqlhzJ/Hr4bf/vfJOxelYmmQU+mzfIdMX9iawoejKjcreZytlEs02
	5gkV82+ZqfSm/I36loPfl/bIcUZdm/S27U8MX++K+DCfgq1frkaKF6afnj5rXnLt20/NjB4a
	IW+NXqkttS4pYObfY6Yj/O74PW9GBkZBbtteJZbijERDLeai4kQAcrs1y28DAAA=
X-CMS-MailID: 20240621221113eucas1p25c2fbadceef48913c4a7b164e6d14890
X-Msg-Generator: CA
X-RootMTR: 20240621221113eucas1p25c2fbadceef48913c4a7b164e6d14890
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240621221113eucas1p25c2fbadceef48913c4a7b164e6d14890
References: <CAPLW+4njmKxXSMqNazX6t6LS=fHNh6Pi8_icF1=aPw27G0J3PQ@mail.gmail.com>
	<CGME20240621221113eucas1p25c2fbadceef48913c4a7b164e6d14890@eucas1p2.samsung.com>

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2024-06-21 pi=C4=85 14:40>, when Sam Protsenko wrote:
> On Fri, Jun 21, 2024 at 2:00=E2=80=AFPM Lukasz Stelmach <l.stelmach@samsu=
ng.com> wrote:
>>
>> It was <2024-06-20 czw 18:13>, when Sam Protsenko wrote:
>> > On some Exynos chips like Exynos850 the access to Security Sub System
>> > (SSS) registers is protected with TrustZone, and therefore only possib=
le
>> > from EL3 monitor software. The Linux kernel is running in EL1, so the
>> > only way for the driver to obtain TRNG data is via SMC calls to EL3
>> > monitor. Implement such SMC operation and use it when EXYNOS_SMC flag =
is
>> > set in the corresponding chip driver data.
>> >
>> > Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
>> > Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> > ---
>> > Changes in v3:
>> >   - Added appropriate error messages for the case when init SMC comman=
d fails
>> >
>> > Changes in v2:
>> >   - Used the "reversed Christmas tree" style in the variable declarati=
on
>> >     block in exynos_trng_do_read_smc()
>> >   - Renamed .quirks to .flags in the driver structure
>> >   - Added Krzysztof's R-b tag
>> >
>> >  drivers/char/hw_random/exynos-trng.c | 140 +++++++++++++++++++++++++--
>> >  1 file changed, 130 insertions(+), 10 deletions(-)
>> >
>> > diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_ra=
ndom/exynos-trng.c
>> > index 6ef2ee6c9804..9fa30583cc86 100644
>> > --- a/drivers/char/hw_random/exynos-trng.c
>> > +++ b/drivers/char/hw_random/exynos-trng.c
>>
>> [...]
>>
>>
>> > @@ -103,6 +163,24 @@ static int exynos_trng_init(struct hwrng *rng)
>> >       return 0;
>> >  }
>> >
>> > +static int exynos_trng_init_smc(struct hwrng *rng)
>> > +{
>> > +     struct exynos_trng_dev *trng =3D (struct exynos_trng_dev *)rng->=
priv;
>> > +     struct arm_smccc_res res;
>> > +     int ret =3D 0;
>> > +
>> > +     arm_smccc_smc(SMC_CMD_RANDOM, HWRNG_INIT, 0, 0, 0, 0, 0, 0, &res=
);
>> > +     if (res.a0 !=3D HWRNG_RET_OK) {
>> > +             dev_err(trng->dev, "SMC command for TRNG init failed (%d=
)\n",
>> > +                     (int)res.a0);
>> > +             ret =3D -EIO;
>> > +     }
>> > +     if ((int)res.a0 =3D=3D -1)
>> > +             dev_info(trng->dev, "Make sure LDFW is loaded by your BL=
\n");
>>
>> This is good, thank you for adding it. It can be even better though, if
>> you don't skimp on message length (-; I mean, I know what BL is, I can
>> fingure what LDFW is because you have explained to me and I can see the
>> source code, but somewone who sees it for the first time will be only
>> slightly less surprised than with v2 error message only. Come on, you
>> can make this message twice as long and it will still fit in 80 characte=
rs (-;
>>
>
> Guess my OCD got in the way and I just didn't want to break the line
> :) But yeah, LDFW =3D Loadable Firmware, and BL =3D bootloader. There is
> an "ldfw" partition on eMMC, and I noticed Samsung usually uses LDFW
> term, so I figured it was not a big deal to throw that abbreviation at
> the user. But I totally agree on BL part, it might be confusing. I
> don't have any strong opinion on this one. If you are going to apply
> v3, can I kindly ask you to change that message the way you want it to
> be?

I guess Olivia or Herbert will be applying it. Let me try=E2=80=A6 How abou=
t:

"Check if your bootloader loads the firmware (SMC) part of the driver."

>> Don't change it if v3 is the last. If not, please, make it more verbose.
>>
>> > +
>> > +     return ret;
>> > +}
>> > +
>>
>>
>> [...]
>>
>>
>> Kind regards,
>> --
>> =C5=81ukasz Stelmach
>> Samsung R&D Institute Poland
>> Samsung Electronics
>

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmZ1+nIACgkQsK4enJil
gBAgMAgAlCf2UQmITTDm/pqNlPAKlBNGepXgRwsDhTGvuk1OQo8nkOQhQx+pseyo
NgQjuCrYN/4CfXWpD+e/H5gc9T3pAApyRCwPzP5dAiAQkN39B5kIT00Vm7saBPVx
00Ce8eNJQi3vpFrwT95ty6nTH23ox/lWfidcRXVRWvLot/Qu3vJuchPS0h8ol27H
9pE/UxA/5pWY7BcYvMxZ6urrA0RKhbWMmscXLucJpAY1LrlO9LgU+W125BHrsN2K
p2kpk2SHc7q7owXoqlFYkwO+CJw1bXeLZBQj6ugHh+kDuzE3a0MQbc6d0bcCfwOx
jaHqjMXka7n9pd6cI1tOIjwAtT6GZA==
=4siM
-----END PGP SIGNATURE-----
--=-=-=--

From: =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Subject: Re: [PATCH 2/3] crypto: exynos - Improve performance of PRNG
Date: Tue, 05 Dec 2017 17:43:10 +0100
Message-ID: <87zi6x9lcx.fsf%l.stelmach@samsung.com>
References: <5101426.uadkujNqxF@tauon.chronox.de>
        <CGME20171205164319eucas1p1e79b9798d655851762cc83a6737b73b4@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
Cc: Krzysztof Kozlowski <krzk@kernel.org>, robh+dt@kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, b.zolnierkie@samsung.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <5101426.uadkujNqxF@tauon.chronox.de>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2017-12-05 wto 14:54>, when Stephan Mueller wrote:
> Am Dienstag, 5. Dezember 2017, 13:35:57 CET schrieb =C5=81ukasz Stelmach:
>
> Hi =C5=81ukasz,
>
>> Use memcpy_fromio() instead of custom exynos_rng_copy_random() function
>> to retrieve generated numbers from the registers of PRNG.
>>=20
>> Remove unnecessary invocation of cpu_relax().
>>=20
>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> ---
>>  drivers/crypto/exynos-rng.c | 36 +++++-------------------------------
>>  1 file changed, 5 insertions(+), 31 deletions(-)
>>=20
>> diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
>> index 894ef93ef5ec..002e9d2a83cc 100644
>> --- a/drivers/crypto/exynos-rng.c
>> +++ b/drivers/crypto/exynos-rng.c

[...]

>> @@ -171,6 +143,8 @@ static int exynos_rng_get_random(struct exynos_rng_d=
ev
>> *rng, {
>>  	int retry =3D EXYNOS_RNG_WAIT_RETRIES;
>>=20
>> +	*read =3D min_t(size_t, dlen, EXYNOS_RNG_SEED_SIZE);
>> +
>>  	if (rng->type =3D=3D EXYNOS_PRNG_TYPE4) {
>>  		exynos_rng_writel(rng, EXYNOS_RNG_CONTROL_START,
>>  				  EXYNOS_RNG_CONTROL);
>> @@ -180,8 +154,8 @@ static int exynos_rng_get_random(struct exynos_rng_d=
ev
>> *rng, }
>>=20
>>  	while (!(exynos_rng_readl(rng,
>> -			EXYNOS_RNG_STATUS) & EXYNOS_RNG_STATUS_RNG_DONE) && --retry)
>> -		cpu_relax();
>> +			EXYNOS_RNG_STATUS) & EXYNOS_RNG_STATUS_RNG_DONE) &&
>> +	       --retry);
SM>
SM> Is this related to the patch?

KK> It looks like unrelated change so split it into separate commit with
KK> explanation why you are changing the common busy-loop pattern.
KK> exynos_rng_readl() uses relaxed versions of readl() so I would expect
KK> here cpu_relax().

Yes. As far as I can tell this gives the major part of the performance
improvement brought by this patch.

The busy loop is not very busy. Every time I checked the loop (w/o
cpu_relax()) was executed twice (retry was 98) and the operation was
reliable. I don't see why do we need a memory barrier here. On the other
hand, I am not sure the whole exynos_rng_get_random() shouldn't be ran
under a mutex or a spinlock (I don't see anything like this in the upper
layers of the crypto framework).

The *_relaxed() I/O operations do not enforce memory=20

Thank you for asking the questions. I will put the above explanations in
the commit message.

>>=20
>>  	if (!retry)
>>  		return -ETIMEDOUT;
>> @@ -189,7 +163,7 @@ static int exynos_rng_get_random(struct exynos_rng_d=
ev
>> *rng, /* Clear status bit */
>>  	exynos_rng_writel(rng, EXYNOS_RNG_STATUS_RNG_DONE,
>>  			  EXYNOS_RNG_STATUS);
>> -	*read =3D exynos_rng_copy_random(rng, dst, dlen);
>> +	memcpy_fromio(dst, rng->mem + EXYNOS_RNG_OUT_BASE, *read);
>>=20
>>  	return 0;
>>  }

Kind regards,
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCAAGBQJaJsyfAAoJELCuHpyYpYAQtPMH/iypyyW1dc7UnLs8QEe90lbP
j8BuW91wV58JAM+vwTzVZ6egInbuxS39FEBBt5hqYnfuM+cP3tlPUKS/lm+uxi+B
xqLVzhO+BAJ9cr+Xr9NLDphQg7EPdhOHvABJtF1Ichplc2S6d3EIwbtYfrbyYy4z
sPl24euM4i2gvM2DREyGdHijRaAvD7NiCj3DQDBu8H180xdsieAWDDlh2QuuCmTu
asPTMZASsXpqYhWGUJ7TyhiNVVVarlB5D3qRU1y1FSBbdz6xG9AtD+enjA4VlY1B
vdJ6K2KReT72Wgfd6NN4UKseDULhemfZbxTGFjVsqZa+Q463Y2fHND0KWWII3SU=
=Bl04
-----END PGP SIGNATURE-----
--=-=-=--

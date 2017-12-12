From: =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Subject: Re: [PATCH v2 4/4] crypto: exynos - Introduce mutex to prevent
 concurrent access to hardware
Date: Tue, 12 Dec 2017 11:30:14 +0100
Message-ID: <87o9n46xxl.fsf%l.stelmach@samsung.com>
References: <CAJKOXPeXHuOVScgBE0WS5Wh79zbAPJ-9P+QvG+Y+NYkxGzNXxA@mail.gmail.com>
        <CGME20171212103021eucas1p19a2a24930cadde55eac2f822a6a9f80c@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
Cc: robh+dt@kernel.org, Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40883 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751281AbdLLKaZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Dec 2017 05:30:25 -0500
In-reply-to: <CAJKOXPeXHuOVScgBE0WS5Wh79zbAPJ-9P+QvG+Y+NYkxGzNXxA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2017-12-11 pon 16:03>, when Krzysztof Kozlowski wrote:
> On Mon, Dec 11, 2017 at 3:06 PM, =C5=81ukasz Stelmach <l.stelmach@samsung=
.com> wrote:
>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewi=
cz <b.zolnierkie@samsung.com>
>>
>> Hardware operations like reading random numbers and setting a seed need
>> to be conducted in a single thread. Therefore a mutex is required to
>> prevent multiple threads (processes) from accessing the hardware at the
>> same time.
>>
>> The sequence of mutex_lock() and mutex_unlock() in the exynos_rng_reseed=
()
>> function enables switching between different threads waiting for the
>> driver to generate random numbers for them.
>>
>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> ---
>>  drivers/crypto/exynos-rng.c | 21 +++++++++++++++++++++
>>  1 file changed, 21 insertions(+)
>>
>> diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
>> index c72a838f1932..6209035ca659 100644
>> --- a/drivers/crypto/exynos-rng.c
>> +++ b/drivers/crypto/exynos-rng.c
>> @@ -22,6 +22,7 @@
>>  #include <linux/err.h>
>>  #include <linux/io.h>
>>  #include <linux/module.h>
>> +#include <linux/mutex.h>
>>  #include <linux/of_device.h>
>>  #include <linux/platform_device.h>
>>
>> @@ -79,6 +80,7 @@ struct exynos_rng_dev {
>>         enum exynos_prng_type           type;
>>         void __iomem                    *mem;
>>         struct clk                      *clk;
>> +       struct mutex                    lock;
>>         /* Generated numbers stored for seeding during resume */
>>         u8                              seed_save[EXYNOS_RNG_SEED_SIZE];
>>         unsigned int                    seed_save_len;
>> @@ -192,6 +194,10 @@ static void exynos_rng_reseed(struct exynos_rng_dev=
 *rng)
>>                 return;
>>
>>         exynos_rng_set_seed(rng, seed, read);
>> +
>> +       /* Let others do some of their job. */
>> +       mutex_unlock(&rng->lock);
>> +       mutex_lock(&rng->lock);
>>  }
>>
>>  static int exynos_rng_generate(struct crypto_rng *tfm,
>> @@ -207,6 +213,7 @@ static int exynos_rng_generate(struct crypto_rng *tf=
m,
>>         if (ret)
>>                 return ret;
>>
>> +       mutex_lock(&rng->lock);
>>         do {
>>                 ret =3D exynos_rng_get_random(rng, dst, dlen, &read);
>>                 if (ret)
>> @@ -217,6 +224,7 @@ static int exynos_rng_generate(struct crypto_rng *tf=
m,
>>
>>                 exynos_rng_reseed(rng);
>>         } while (dlen > 0);
>> +       mutex_unlock(&rng->lock);
>>
>>         clk_disable_unprepare(rng->clk);
>>
>> @@ -234,7 +242,9 @@ static int exynos_rng_seed(struct crypto_rng *tfm, c=
onst u8 *seed,
>>         if (ret)
>>                 return ret;
>>
>> +       mutex_lock(&rng->lock);
>>         ret =3D exynos_rng_set_seed(ctx->rng, seed, slen);
>> +       mutex_unlock(&rng->lock);
>
> I think the number of mutex locks/unlock statements can be reduced
> (including the mutex unlock+lock pattern) after moving the mutex to
> exynos_rng_set_seed() and exynos_rng_get_random() because actually you
> want to protect them. This would remove the new code from suspend and
> resume path and gave you the fairness.
>
> On the other hand the mutex would be unlocked+locked many times for
> large generate() calls...

Moving locks/unlocks to exynos_rng_get_random() means taking a lock to
retrieve 20 bytes. It doesn't scale at all. I really wanted to avoid it,
because the performance loss is quite noticable in such case. That is
why I put the lock around the loop in exynos_rng_generatr(). As a
consequence I had to move locks out of exynos_rng_set_seed() too.

>>         clk_disable_unprepare(rng->clk);
>>
>> @@ -284,6 +294,8 @@ static int exynos_rng_probe(struct platform_device *=
pdev)
>>                 return -ENOTSUPP;
>>         }
>>
>> +       mutex_init(&rng->lock);
>> +
>>         rng->dev =3D &pdev->dev;
>>         rng->clk =3D devm_clk_get(&pdev->dev, "secss");
>>         if (IS_ERR(rng->clk)) {
>> @@ -334,9 +346,14 @@ static int __maybe_unused exynos_rng_suspend(struct=
 device *dev)
>>         if (ret)
>>                 return ret;
>>
>> +       mutex_lock(&rng->lock);
>> +
>>         /* Get new random numbers and store them for seeding on resume. =
*/
>>         exynos_rng_get_random(rng, rng->seed_save, sizeof(rng->seed_save=
),
>>                               &(rng->seed_save_len));
>> +
>> +       mutex_unlock(&rng->lock);
>> +
>>         dev_dbg(rng->dev, "Stored %u bytes for seeding on system resume\=
n",
>>                 rng->seed_save_len);
>>
>> @@ -359,8 +376,12 @@ static int __maybe_unused exynos_rng_resume(struct =
device *dev)
>>         if (ret)
>>                 return ret;
>>
>> +       mutex_lock(&rng->lock);
>> +
>>         ret =3D exynos_rng_set_seed(rng, rng->seed_save, rng->seed_save_=
len);
>>
>> +       mutex_unlock(&rng->lock);
>> +
>>         clk_disable_unprepare(rng->clk);
>>
>>         return ret;
>> --
>> 2.11.0


=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCAAGBQJaL6+2AAoJELCuHpyYpYAQ3k4IAKxh/mvnjv8QK4GZMjaoVhVU
gYKsBltiIOgvWGencXSVN0BMBWtMJZ8gOirz1xKvprRMlHSx2+j0fJJe0XtirTS9
aBGgzwKkHgamsMNx1wR5yotjHPS7oL2OX0VQJ8Fy2VDbrWKYGnqmS9shdAhKj7uR
60xKkVI6ybB5f7rKFmFLVVK+idbpU94ceqWxdzIuyo4MxF8IEmWgzSk63aK/BpZA
C3LJT4Df18jCz/LIVUoMsGEEdCLN2U9EVelov9QZ6cA7qCmhy4GSES9t2S2wwVKu
64zCCBnLr0XMDepRuZls7ejV03n8ZC517cx5BSVNY4+cGlQ35H9MQlE62fcX8cg=
=50IR
-----END PGP SIGNATURE-----
--=-=-=--

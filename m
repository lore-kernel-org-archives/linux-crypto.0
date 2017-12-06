From: =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Subject: Re: [PATCH 2/3] crypto: exynos - Improve performance of PRNG
Date: Wed, 06 Dec 2017 14:06:50 +0100
Message-ID: <87h8t49f9x.fsf%l.stelmach@samsung.com>
References: <CAJKOXPf29yTTXRg=X3h-OCyGTyO2O3tSE99qK2UXNwtj9cK8FA@mail.gmail.com>
        <CGME20171206130651eucas1p22b5d0799f2a128d3d9efcc799fc3cfdc@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
Cc: Stephan Mueller <smueller@chronox.de>, robh+dt@kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBo?= =?utf-8?Q?=C5=82nierkiewicz?=
        <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <CAJKOXPf29yTTXRg=X3h-OCyGTyO2O3tSE99qK2UXNwtj9cK8FA@mail.gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2017-12-06 =C5=9Bro 12:37>, when Krzysztof Kozlowski wrote:
> On Wed, Dec 6, 2017 at 12:32 PM, =C5=81ukasz Stelmach <l.stelmach@samsung=
.com> wrote:
>> It was <2017-12-05 wto 19:06>, when Krzysztof Kozlowski wrote:
>>> On Tue, Dec 5, 2017 at 6:53 PM, Krzysztof Kozlowski <krzk@kernel.org> w=
rote:
>>>> On Tue, Dec 05, 2017 at 05:43:10PM +0100, =C5=81ukasz Stelmach wrote:
>>>>> It was <2017-12-05 wto 14:54>, when Stephan Mueller wrote:
>>>>>> Am Dienstag, 5. Dezember 2017, 13:35:57 CET schrieb =C5=81ukasz Stel=
mach:
>>>>>>> Use memcpy_fromio() instead of custom exynos_rng_copy_random() func=
tion
>>>>>>> to retrieve generated numbers from the registers of PRNG.
>>>>>>>
>>>>>>> Remove unnecessary invocation of cpu_relax().
>>>>>>>
>>>>>>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>>>>>>> ---
>>>>>>>  drivers/crypto/exynos-rng.c | 36 +++++----------------------------=
---
>>>>>>>  1 file changed, 5 insertions(+), 31 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rn=
g.c
>>>>>>> index 894ef93ef5ec..002e9d2a83cc 100644
>>>>>>> --- a/drivers/crypto/exynos-rng.c
>>>>>>> +++ b/drivers/crypto/exynos-rng.c
>>>>>
>>>>> [...]
>>>>>
>>>>>>> @@ -171,6 +143,8 @@ static int exynos_rng_get_random(struct exynos_=
rng_dev
>>>>>>> *rng, {
>>>>>>>    int retry =3D EXYNOS_RNG_WAIT_RETRIES;
>>>>>>>
>>>>>>> +  *read =3D min_t(size_t, dlen, EXYNOS_RNG_SEED_SIZE);
>>>>>>> +
>>>>>>>    if (rng->type =3D=3D EXYNOS_PRNG_TYPE4) {
>>>>>>>            exynos_rng_writel(rng, EXYNOS_RNG_CONTROL_START,
>>>>>>>                              EXYNOS_RNG_CONTROL);
>>>>>>> @@ -180,8 +154,8 @@ static int exynos_rng_get_random(struct exynos_=
rng_dev
>>>>>>> *rng, }
>>>>>>>
>>>>>>>    while (!(exynos_rng_readl(rng,
>>>>>>> -                  EXYNOS_RNG_STATUS) & EXYNOS_RNG_STATUS_RNG_DONE)=
 && --retry)
>>>>>>> -          cpu_relax();
>>>>>>> +                  EXYNOS_RNG_STATUS) & EXYNOS_RNG_STATUS_RNG_DONE)=
 &&
>>>>>>> +         --retry);
>>
>> [...]
>>
>>>>> The busy loop is not very busy. Every time I checked the loop (w/o
>>>>> cpu_relax()) was executed twice (retry was 98) and the operation was
>>>>> reliable. I don't see why do we need a memory barrier here. On the ot=
her
>>>>> hand, I am not sure the whole exynos_rng_get_random() shouldn't be ran
>>>>> under a mutex or a spinlock (I don't see anything like this in the up=
per
>>>>> layers of the crypto framework).
>>>>>
>>>>> The *_relaxed() I/O operations do not enforce memory
>>>>
>>>> The cpu_relax() is a common pattern for busy-loop. If you want to break
>>>> this pattern - please explain why only this part of kernel should not
>>>> follow it (and rest of kernel should).
>>>>
>>>> The other part - this code is already using relaxed versions which mig=
ht
>>>> get you into difficult to debug issues. You mentioned that loop works
>>>> reliable after removing the cpu_relax... yeah, it might for 99.999% but
>>>> that's not the argument. I remember few emails from Arnd Bergmann
>>>> mentioning explicitly to avoid using relaxed versions "just because",
>>>> unless it is necessary or really understood.
>>>>
>>>> The code first writes to control register, then checks for status so y=
ou
>>>> should have these operations strictly ordered. Therefore I think
>>>> cpu_relax() should not be removed.
>>>
>>> ... or just convert it to readl_poll_timeout() because it makes code
>>> more readable, takes care of timeout and you do not have care about
>>> specific implementation (whether there should or should not be
>>> cpu_relax).
>>
>> OK. This appears to perform reasonably.
>>
>>         do {
>>                 cpu_relax();
>>         } while (!(exynos_rng_readl(rng, EXYNOS_RNG_STATUS) &
>>                    EXYNOS_RNG_STATUS_RNG_DONE) && --retry);
>
> You mean that:
>   while (readl_relaxed()) cpu_relax();
> is slower than
>   do cpu_relax() while (readl_relaxed())
> ?
>
> Hmm... Interesting. I would be happy to learn more about it why it
> behaves so differently. Maybe the execution of cpu_relax() before
> readl_relaxed() reduces the amount of loops to actually one read?
>
> Indeed some parts of kernel code for ARM prefers this approach,
> although still the most popular pattern is existing one (while()
> cpu_relax).

Without cpu_relax() retry is decremented twice. So there are three
reads. It appears that a single call cpu_relax() gives the hardware
enough time to be ready when the first read occurs (retry is 99 after
the loop).

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCAAGBQJaJ+tqAAoJELCuHpyYpYAQBeAH/34JmrtzI7k9+hgt5WK5pEo5
/mPUuXmiujDopjHiWp1C33fYrcGIaourU7+vJJFnOgmtew4S3SN/of6IiY+tTHs9
wveY6lg+u94YlzXdXxISdI1+Ac2796xeLKvQ0OzgXpJTQevBBsgBOltfWqjZngGq
mjTQcpOWeWmMJ3MefxXcCwbuYTB/PEqVq9R9gLmUdbPpIKCUwVgHSHQim6gEM665
0i8g411FBrsnWdYo/fDawDe8KZ7jUgmalImxc+L+6YE+I18zNBduiJ77Z+LJBwdS
f3BY1NRmqDtvQnGGiBJaNbO+uNnYyUZVzqksUghmvyn0pk4h293XhJ9VBnBSco0=
=/tBU
-----END PGP SIGNATURE-----
--=-=-=--

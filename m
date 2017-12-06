From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 2/3] crypto: exynos - Improve performance of PRNG
Date: Wed, 6 Dec 2017 12:37:47 +0100
Message-ID: <CAJKOXPf29yTTXRg=X3h-OCyGTyO2O3tSE99qK2UXNwtj9cK8FA@mail.gmail.com>
References: <CGME20171206113301eucas1p23da9decc34cc646b0bf4eb88953ef94a@eucas1p2.samsung.com>
 <CAJKOXPfRu-CseVCJUabXcaJP+uBVfkcHV63O0pVegYz6mKxBqg@mail.gmail.com> <87vahk9jml.fsf%l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Stephan Mueller <smueller@chronox.de>, robh+dt@kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvxYJuaWVya2lld2ljeg==?=
        <b.zolnierkie@samsung.com>
To: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752129AbdLFLhu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Dec 2017 06:37:50 -0500
In-Reply-To: <87vahk9jml.fsf%l.stelmach@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 6, 2017 at 12:32 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> It was <2017-12-05 wto 19:06>, when Krzysztof Kozlowski wrote:
>> On Tue, Dec 5, 2017 at 6:53 PM, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>>> On Tue, Dec 05, 2017 at 05:43:10PM +0100, Łukasz Stelmach wrote:
>>>> It was <2017-12-05 wto 14:54>, when Stephan Mueller wrote:
>>>>> Am Dienstag, 5. Dezember 2017, 13:35:57 CET schrieb Łukasz Stelmach:
>>>>>> Use memcpy_fromio() instead of custom exynos_rng_copy_random() function
>>>>>> to retrieve generated numbers from the registers of PRNG.
>>>>>>
>>>>>> Remove unnecessary invocation of cpu_relax().
>>>>>>
>>>>>> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
>>>>>> ---
>>>>>>  drivers/crypto/exynos-rng.c | 36 +++++-------------------------------
>>>>>>  1 file changed, 5 insertions(+), 31 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
>>>>>> index 894ef93ef5ec..002e9d2a83cc 100644
>>>>>> --- a/drivers/crypto/exynos-rng.c
>>>>>> +++ b/drivers/crypto/exynos-rng.c
>>>>
>>>> [...]
>>>>
>>>>>> @@ -171,6 +143,8 @@ static int exynos_rng_get_random(struct exynos_rng_dev
>>>>>> *rng, {
>>>>>>    int retry = EXYNOS_RNG_WAIT_RETRIES;
>>>>>>
>>>>>> +  *read = min_t(size_t, dlen, EXYNOS_RNG_SEED_SIZE);
>>>>>> +
>>>>>>    if (rng->type == EXYNOS_PRNG_TYPE4) {
>>>>>>            exynos_rng_writel(rng, EXYNOS_RNG_CONTROL_START,
>>>>>>                              EXYNOS_RNG_CONTROL);
>>>>>> @@ -180,8 +154,8 @@ static int exynos_rng_get_random(struct exynos_rng_dev
>>>>>> *rng, }
>>>>>>
>>>>>>    while (!(exynos_rng_readl(rng,
>>>>>> -                  EXYNOS_RNG_STATUS) & EXYNOS_RNG_STATUS_RNG_DONE) && --retry)
>>>>>> -          cpu_relax();
>>>>>> +                  EXYNOS_RNG_STATUS) & EXYNOS_RNG_STATUS_RNG_DONE) &&
>>>>>> +         --retry);
>
> [...]
>
>>>> The busy loop is not very busy. Every time I checked the loop (w/o
>>>> cpu_relax()) was executed twice (retry was 98) and the operation was
>>>> reliable. I don't see why do we need a memory barrier here. On the other
>>>> hand, I am not sure the whole exynos_rng_get_random() shouldn't be ran
>>>> under a mutex or a spinlock (I don't see anything like this in the upper
>>>> layers of the crypto framework).
>>>>
>>>> The *_relaxed() I/O operations do not enforce memory
>>>
>>> The cpu_relax() is a common pattern for busy-loop. If you want to break
>>> this pattern - please explain why only this part of kernel should not
>>> follow it (and rest of kernel should).
>>>
>>> The other part - this code is already using relaxed versions which might
>>> get you into difficult to debug issues. You mentioned that loop works
>>> reliable after removing the cpu_relax... yeah, it might for 99.999% but
>>> that's not the argument. I remember few emails from Arnd Bergmann
>>> mentioning explicitly to avoid using relaxed versions "just because",
>>> unless it is necessary or really understood.
>>>
>>> The code first writes to control register, then checks for status so you
>>> should have these operations strictly ordered. Therefore I think
>>> cpu_relax() should not be removed.
>>
>> ... or just convert it to readl_poll_timeout() because it makes code
>> more readable, takes care of timeout and you do not have care about
>> specific implementation (whether there should or should not be
>> cpu_relax).
>
> OK. This appears to perform reasonably.
>
>         do {
>                 cpu_relax();
>         } while (!(exynos_rng_readl(rng, EXYNOS_RNG_STATUS) &
>                    EXYNOS_RNG_STATUS_RNG_DONE) && --retry);

You mean that:
  while (readl_relaxed()) cpu_relax();
is slower than
  do cpu_relax() while (readl_relaxed())
?

Hmm... Interesting. I would be happy to learn more about it why it
behaves so differently. Maybe the execution of cpu_relax() before
readl_relaxed() reduces the amount of loops to actually one read?

Indeed some parts of kernel code for ARM prefers this approach,
although still the most popular pattern is existing one (while()
cpu_relax).

Best regards,
Krzysztof

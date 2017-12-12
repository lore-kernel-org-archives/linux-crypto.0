From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v2 4/4] crypto: exynos - Introduce mutex to prevent
 concurrent access to hardware
Date: Tue, 12 Dec 2017 12:09:48 +0100
Message-ID: <CAJKOXPc_QyahFZKGNfwxaNfeCdL2P8PYUYX0oxxpPDR057_nXQ@mail.gmail.com>
References: <CGME20171212103021eucas1p19a2a24930cadde55eac2f822a6a9f80c@eucas1p1.samsung.com>
 <CAJKOXPeXHuOVScgBE0WS5Wh79zbAPJ-9P+QvG+Y+NYkxGzNXxA@mail.gmail.com> <87o9n46xxl.fsf%l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: robh+dt@kernel.org, Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <87o9n46xxl.fsf%l.stelmach@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Dec 12, 2017 at 11:30 AM, Łukasz Stelmach
<l.stelmach@samsung.com> wrote:
> It was <2017-12-11 pon 16:03>, when Krzysztof Kozlowski wrote:
>> On Mon, Dec 11, 2017 at 3:06 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
>>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>>>
>>> Hardware operations like reading random numbers and setting a seed need
>>> to be conducted in a single thread. Therefore a mutex is required to
>>> prevent multiple threads (processes) from accessing the hardware at the
>>> same time.
>>>
>>> The sequence of mutex_lock() and mutex_unlock() in the exynos_rng_reseed()
>>> function enables switching between different threads waiting for the
>>> driver to generate random numbers for them.
>>>
>>> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
>>> ---
>>>  drivers/crypto/exynos-rng.c | 21 +++++++++++++++++++++
>>>  1 file changed, 21 insertions(+)
>>>
>>> diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
>>> index c72a838f1932..6209035ca659 100644
>>> --- a/drivers/crypto/exynos-rng.c
>>> +++ b/drivers/crypto/exynos-rng.c
>>> @@ -22,6 +22,7 @@
>>>  #include <linux/err.h>
>>>  #include <linux/io.h>
>>>  #include <linux/module.h>
>>> +#include <linux/mutex.h>
>>>  #include <linux/of_device.h>
>>>  #include <linux/platform_device.h>
>>>
>>> @@ -79,6 +80,7 @@ struct exynos_rng_dev {
>>>         enum exynos_prng_type           type;
>>>         void __iomem                    *mem;
>>>         struct clk                      *clk;
>>> +       struct mutex                    lock;
>>>         /* Generated numbers stored for seeding during resume */
>>>         u8                              seed_save[EXYNOS_RNG_SEED_SIZE];
>>>         unsigned int                    seed_save_len;
>>> @@ -192,6 +194,10 @@ static void exynos_rng_reseed(struct exynos_rng_dev *rng)
>>>                 return;
>>>
>>>         exynos_rng_set_seed(rng, seed, read);
>>> +
>>> +       /* Let others do some of their job. */
>>> +       mutex_unlock(&rng->lock);
>>> +       mutex_lock(&rng->lock);
>>>  }
>>>
>>>  static int exynos_rng_generate(struct crypto_rng *tfm,
>>> @@ -207,6 +213,7 @@ static int exynos_rng_generate(struct crypto_rng *tfm,
>>>         if (ret)
>>>                 return ret;
>>>
>>> +       mutex_lock(&rng->lock);
>>>         do {
>>>                 ret = exynos_rng_get_random(rng, dst, dlen, &read);
>>>                 if (ret)
>>> @@ -217,6 +224,7 @@ static int exynos_rng_generate(struct crypto_rng *tfm,
>>>
>>>                 exynos_rng_reseed(rng);
>>>         } while (dlen > 0);
>>> +       mutex_unlock(&rng->lock);
>>>
>>>         clk_disable_unprepare(rng->clk);
>>>
>>> @@ -234,7 +242,9 @@ static int exynos_rng_seed(struct crypto_rng *tfm, const u8 *seed,
>>>         if (ret)
>>>                 return ret;
>>>
>>> +       mutex_lock(&rng->lock);
>>>         ret = exynos_rng_set_seed(ctx->rng, seed, slen);
>>> +       mutex_unlock(&rng->lock);
>>
>> I think the number of mutex locks/unlock statements can be reduced
>> (including the mutex unlock+lock pattern) after moving the mutex to
>> exynos_rng_set_seed() and exynos_rng_get_random() because actually you
>> want to protect them. This would remove the new code from suspend and
>> resume path and gave you the fairness.
>>
>> On the other hand the mutex would be unlocked+locked many times for
>> large generate() calls...
>
> Moving locks/unlocks to exynos_rng_get_random() means taking a lock to
> retrieve 20 bytes. It doesn't scale at all. I really wanted to avoid it,
> because the performance loss is quite noticable in such case. That is
> why I put the lock around the loop in exynos_rng_generatr(). As a
> consequence I had to move locks out of exynos_rng_set_seed() too.

I understand. With the fix for first line (cc):
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof

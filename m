From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 2/3] crypto: exynos - Improve performance of PRNG
Date: Tue, 5 Dec 2017 19:06:28 +0100
Message-ID: <CAJKOXPfRu-CseVCJUabXcaJP+uBVfkcHV63O0pVegYz6mKxBqg@mail.gmail.com>
References: <5101426.uadkujNqxF@tauon.chronox.de> <CGME20171205164319eucas1p1e79b9798d655851762cc83a6737b73b4@eucas1p1.samsung.com>
 <87zi6x9lcx.fsf%l.stelmach@samsung.com> <20171205175331.psayjpxolxv5vg3t@kozik-lap>
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
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <20171205175331.psayjpxolxv5vg3t@kozik-lap>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Dec 5, 2017 at 6:53 PM, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> On Tue, Dec 05, 2017 at 05:43:10PM +0100, Łukasz Stelmach wrote:
>> It was <2017-12-05 wto 14:54>, when Stephan Mueller wrote:
>> > Am Dienstag, 5. Dezember 2017, 13:35:57 CET schrieb Łukasz Stelmach:
>> >
>> > Hi Łukasz,
>> >
>> >> Use memcpy_fromio() instead of custom exynos_rng_copy_random() function
>> >> to retrieve generated numbers from the registers of PRNG.
>> >>
>> >> Remove unnecessary invocation of cpu_relax().
>> >>
>> >> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
>> >> ---
>> >>  drivers/crypto/exynos-rng.c | 36 +++++-------------------------------
>> >>  1 file changed, 5 insertions(+), 31 deletions(-)
>> >>
>> >> diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
>> >> index 894ef93ef5ec..002e9d2a83cc 100644
>> >> --- a/drivers/crypto/exynos-rng.c
>> >> +++ b/drivers/crypto/exynos-rng.c
>>
>> [...]
>>
>> >> @@ -171,6 +143,8 @@ static int exynos_rng_get_random(struct exynos_rng_dev
>> >> *rng, {
>> >>    int retry = EXYNOS_RNG_WAIT_RETRIES;
>> >>
>> >> +  *read = min_t(size_t, dlen, EXYNOS_RNG_SEED_SIZE);
>> >> +
>> >>    if (rng->type == EXYNOS_PRNG_TYPE4) {
>> >>            exynos_rng_writel(rng, EXYNOS_RNG_CONTROL_START,
>> >>                              EXYNOS_RNG_CONTROL);
>> >> @@ -180,8 +154,8 @@ static int exynos_rng_get_random(struct exynos_rng_dev
>> >> *rng, }
>> >>
>> >>    while (!(exynos_rng_readl(rng,
>> >> -                  EXYNOS_RNG_STATUS) & EXYNOS_RNG_STATUS_RNG_DONE) && --retry)
>> >> -          cpu_relax();
>> >> +                  EXYNOS_RNG_STATUS) & EXYNOS_RNG_STATUS_RNG_DONE) &&
>> >> +         --retry);
>> SM>
>> SM> Is this related to the patch?
>>
>> KK> It looks like unrelated change so split it into separate commit with
>> KK> explanation why you are changing the common busy-loop pattern.
>> KK> exynos_rng_readl() uses relaxed versions of readl() so I would expect
>> KK> here cpu_relax().
>>
>> Yes. As far as I can tell this gives the major part of the performance
>> improvement brought by this patch.
>
> In that case definitely split and explain... what and why you want to
> achieve here.
>
>>
>> The busy loop is not very busy. Every time I checked the loop (w/o
>> cpu_relax()) was executed twice (retry was 98) and the operation was
>> reliable. I don't see why do we need a memory barrier here. On the other
>> hand, I am not sure the whole exynos_rng_get_random() shouldn't be ran
>> under a mutex or a spinlock (I don't see anything like this in the upper
>> layers of the crypto framework).
>>
>> The *_relaxed() I/O operations do not enforce memory
>
> The cpu_relax() is a common pattern for busy-loop. If you want to break
> this pattern - please explain why only this part of kernel should not
> follow it (and rest of kernel should).
>
> The other part - this code is already using relaxed versions which might
> get you into difficult to debug issues. You mentioned that loop works
> reliable after removing the cpu_relax... yeah, it might for 99.999% but
> that's not the argument. I remember few emails from Arnd Bergmann
> mentioning explicitly to avoid using relaxed versions "just because",
> unless it is necessary or really understood.
>
> The code first writes to control register, then checks for status so you
> should have these operations strictly ordered. Therefore I think
> cpu_relax() should not be removed.

... or just convert it to readl_poll_timeout() because it makes code
more readable, takes care of timeout and you do not have care about
specific implementation (whether there should or should not be
cpu_relax).

Best regards,
Krzysztof

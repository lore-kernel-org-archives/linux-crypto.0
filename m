From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 2/3] hwrng: exynos - add Samsung Exynos True RNG driver
Date: Fri, 24 Nov 2017 13:09:06 +0100
Message-ID: <CAJKOXPc2MGf_b3xA=R=p2_fQ0+SQvwLL8vfZLGhGAAEssD=hJA@mail.gmail.com>
References: <CGME20171123184736eucas1p15d4e73d5a6596a6cba1f940dcc473c9a@eucas1p1.samsung.com>
 <CAJKOXPfaofwB7Sp5Lg0JuZzFwC2RahdWDG5KfsJyNcKDt3b_mA@mail.gmail.com> <87o9nsde9r.fsf%l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Rob Herring <robh+dt@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
To: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87o9nsde9r.fsf%l.stelmach@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 23, 2017 at 7:46 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> It was <2017-11-23 czw 17:31>, when Krzysztof Kozlowski wrote:
>> On Thu, Nov 23, 2017 at 4:09 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
>>> Add support for True Random Number Generator found in Samsung Exynos
>>> 5250+ SoCs.
>>>
>>> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
>>> ---
>>>  MAINTAINERS                          |   7 +
>>>  drivers/char/hw_random/Kconfig       |  12 ++
>>>  drivers/char/hw_random/Makefile      |   1 +
>>>  drivers/char/hw_random/exynos-trng.c | 256 +++++++++++++++++++++++++++++++++++
>>>  4 files changed, 276 insertions(+)
>>>  create mode 100644 drivers/char/hw_random/exynos-trng.c
>>>
>

+Cc Stephan Müller, who reviewed intensively exynos-rng.c.

> [...]
>
>>>  endif # HW_RANDOM
>>
>> Thanks for working on TRNG.
>>
>> 1. I was rather thinking about extending existing exynos-rng.c [1] so
>> it would be using TRNG as seed for PRNG as this gives you much more
>> random data. Instead you developed totally separate driver which has
>> its own benefits - one can choose which interface he wants. Although
>> it is a little bit duplication.
>
> As far as I can tell, these are two different devices. However, PRNG
> shares hardware with the hash engine. Indeed there is a hardware to
> connect TRNG and PRNG, but, IMHO, it might be hard to model that
> dependency in kernel.

It should be as simple as setting few more registers in SSS module
(actually maybe just enabling TRNG_SEED_START in PRNG). You do not
have to model it in a kernel like connecting some hw_rng entity to
cryptoai's rng_alg. See the jitterentropy-kcapi.c. I understand that
in that case existing exynos-rng.c could expose two different RNG
devices - one PRNG based on user's seed and second TRNG (actually
TRNG+PRNG).

It does not seem difficult to model but the question is whether that
makes sense.


> To me it seems easier to read TRNG (or
> /dev/random) and and write the result to PRNG manually (in software).

Indeed this gives more flexibility to the user (choice of engine) but
first, it is slower, and second it reduces the quality of random
numbers (PRNG reseeds itself... but in this model cannot reseed from
TRNG).

Best regards,
Krzysztof

From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 2/3] hwrng: exynos - add Samsung Exynos True RNG driver
Date: Fri, 24 Nov 2017 14:05:11 +0100
Message-ID: <1733513.JRsPYiahIZ@positron.chronox.de>
References: <CGME20171123184736eucas1p15d4e73d5a6596a6cba1f940dcc473c9a@eucas1p1.samsung.com> <87o9nsde9r.fsf%l.stelmach@samsung.com> <CAJKOXPc2MGf_b3xA=R=p2_fQ0+SQvwLL8vfZLGhGAAEssD=hJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: =?utf-8?B?xYF1a2Fzeg==?= Stelmach <l.stelmach@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <CAJKOXPc2MGf_b3xA=R=p2_fQ0+SQvwLL8vfZLGhGAAEssD=hJA@mail.gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 24. November 2017, 13:09:06 CET schrieb Krzysztof Kozlowski:

Hi Krzysztof,
> >> 
> >> 1. I was rather thinking about extending existing exynos-rng.c [1] so
> >> it would be using TRNG as seed for PRNG as this gives you much more
> >> random data. Instead you developed totally separate driver which has
> >> its own benefits - one can choose which interface he wants. Although
> >> it is a little bit duplication.
> > 
> > As far as I can tell, these are two different devices. However, PRNG
> > shares hardware with the hash engine. Indeed there is a hardware to
> > connect TRNG and PRNG, but, IMHO, it might be hard to model that
> > dependency in kernel.
> 
> It should be as simple as setting few more registers in SSS module
> (actually maybe just enabling TRNG_SEED_START in PRNG). You do not
> have to model it in a kernel like connecting some hw_rng entity to
> cryptoai's rng_alg. See the jitterentropy-kcapi.c. I understand that
> in that case existing exynos-rng.c could expose two different RNG
> devices - one PRNG based on user's seed and second TRNG (actually
> TRNG+PRNG).
> 
> It does not seem difficult to model but the question is whether that
> makes sense.

The usage strategy for the PRNGs registered at the kernel crypto API is as 
follows:

1. crypto_rng_alloc

2. crypto_rng_reset

3. crypto_rng_generate

If in step 2 you provide NULL as input, the kernel takes get_random_bytes as 
seed source. Step 2 is the mandatory.

The Linux-RNG can be fed internally from the hw_random framework by the 
function hwrng_fillfn. This function is only used if the current_quality or 
default_quality values in the hw_random framework is set.

For the TRNG, it seems to be not set per default, but could be set as either a 
boot argument or at runtime via /sys.

If that variable is set and the TRNG is registered, it feeds random data into 
the Linux-RNG which in turn is used per default to seed a PRNG. In this case, 
no detour via user space is needed to push data from TRNG to the PRNG. Using 
that mechanism allows you to benefit from additional entropy the Linux-RNG 
collects elsewhere.
> 
> > To me it seems easier to read TRNG (or
> > /dev/random) and and write the result to PRNG manually (in software).
> 
> Indeed this gives more flexibility to the user (choice of engine) but
> first, it is slower, and second it reduces the quality of random
> numbers (PRNG reseeds itself... but in this model cannot reseed from
> TRNG).

Given the reasons above, I would think that keeping the PRMG and TRNG separate 
as offered by the current patch seems reasonable. If configured correctly, the 
TRNG can seed the PRNG at any time (including boot time) without the need of 
user space.
> 
> Best regards,
> Krzysztof


Ciao
Stephan

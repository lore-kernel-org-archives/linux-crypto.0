From: Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] hwrng: exynos - add Samsung Exynos True RNG driver
Date: Fri, 24 Nov 2017 15:13:53 +0100
Message-ID: <CAJKOXPfMVSJSQLh987rwYiwmFkbncadt_uY-dqBVsOaFBjRqeQ@mail.gmail.com>
References: <CGME20171123184736eucas1p15d4e73d5a6596a6cba1f940dcc473c9a@eucas1p1.samsung.com>
 <87o9nsde9r.fsf%l.stelmach@samsung.com> <CAJKOXPc2MGf_b3xA=R=p2_fQ0+SQvwLL8vfZLGhGAAEssD=hJA@mail.gmail.com>
 <1733513.JRsPYiahIZ@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1733513.JRsPYiahIZ-jJGQKZiSfeo1haGO/jJMPxvVK+yQ3ZXh@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 24, 2017 at 2:05 PM, Stephan Müller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org> wrote:
> Am Freitag, 24. November 2017, 13:09:06 CET schrieb Krzysztof Kozlowski:
>
> Hi Krzysztof,
>> >>
>> >> 1. I was rather thinking about extending existing exynos-rng.c [1] so
>> >> it would be using TRNG as seed for PRNG as this gives you much more
>> >> random data. Instead you developed totally separate driver which has
>> >> its own benefits - one can choose which interface he wants. Although
>> >> it is a little bit duplication.
>> >
>> > As far as I can tell, these are two different devices. However, PRNG
>> > shares hardware with the hash engine. Indeed there is a hardware to
>> > connect TRNG and PRNG, but, IMHO, it might be hard to model that
>> > dependency in kernel.
>>
>> It should be as simple as setting few more registers in SSS module
>> (actually maybe just enabling TRNG_SEED_START in PRNG). You do not
>> have to model it in a kernel like connecting some hw_rng entity to
>> cryptoai's rng_alg. See the jitterentropy-kcapi.c. I understand that
>> in that case existing exynos-rng.c could expose two different RNG
>> devices - one PRNG based on user's seed and second TRNG (actually
>> TRNG+PRNG).
>>
>> It does not seem difficult to model but the question is whether that
>> makes sense.
>
> The usage strategy for the PRNGs registered at the kernel crypto API is as
> follows:
>
> 1. crypto_rng_alloc
>
> 2. crypto_rng_reset
>
> 3. crypto_rng_generate
>
> If in step 2 you provide NULL as input, the kernel takes get_random_bytes as
> seed source. Step 2 is the mandatory.
>
> The Linux-RNG can be fed internally from the hw_random framework by the
> function hwrng_fillfn. This function is only used if the current_quality or
> default_quality values in the hw_random framework is set.
>
> For the TRNG, it seems to be not set per default, but could be set as either a
> boot argument or at runtime via /sys.
>
> If that variable is set and the TRNG is registered, it feeds random data into
> the Linux-RNG which in turn is used per default to seed a PRNG. In this case,
> no detour via user space is needed to push data from TRNG to the PRNG. Using
> that mechanism allows you to benefit from additional entropy the Linux-RNG
> collects elsewhere.
>>
>> > To me it seems easier to read TRNG (or
>> > /dev/random) and and write the result to PRNG manually (in software).
>>
>> Indeed this gives more flexibility to the user (choice of engine) but
>> first, it is slower, and second it reduces the quality of random
>> numbers (PRNG reseeds itself... but in this model cannot reseed from
>> TRNG).
>
> Given the reasons above, I would think that keeping the PRMG and TRNG separate
> as offered by the current patch seems reasonable. If configured correctly, the
> TRNG can seed the PRNG at any time (including boot time) without the need of
> user space.

Hi Stephan,

Thanks for explaining the details. This convinces me so I do not have
any objections against current approach of this second RNG driver for
Exynos.

Best regards,
Krzysztof
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

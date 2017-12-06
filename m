From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 1/3] crypto: exynos - Support Exynos5250+ SoCs
Date: Wed, 6 Dec 2017 15:05:41 +0100
Message-ID: <CAJKOXPfep5BeJMz=qHqF4m05c2=5DgnFjPeA21n2EMJnyXvoQA@mail.gmail.com>
References: <CGME20171206134305eucas1p218c38b977c14cae58763586458c3e78d@eucas1p2.samsung.com>
 <CAJKOXPf9JpBkR_z4frT-knxSUv53K=94wHoJkqD2fzVz2K6mGA@mail.gmail.com> <87bmjc9dlr.fsf%l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: robh+dt@kernel.org, Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvxYJuaWVya2lld2ljeg==?=
        <b.zolnierkie@samsung.com>
To: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <87bmjc9dlr.fsf%l.stelmach@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Dec 6, 2017 at 2:42 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> It was <2017-12-05 wto 14:34>, when Krzysztof Kozlowski wrote:
>> On Tue, Dec 5, 2017 at 1:35 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
>>> Add support for PRNG in Exynos5250+ SoCs.
>>>
>>> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
>>> ---
>>>  .../bindings/crypto/samsung,exynos-rng4.txt        |  4 ++-
>>>  drivers/crypto/exynos-rng.c                        | 36 ++++++++++++++++++++--
>>>  2 files changed, 36 insertions(+), 4 deletions(-)
>>>
>>> diff --git
>>> a/Documentation/devicetree/bindings/crypto/samsung,exynos-rng4.txt
>>> b/Documentation/devicetree/bindings/crypto/samsung,exynos-rng4.txt
>>> index 4ca8dd4d7e66..a13fbdb4bd88 100644
>>> --- a/Documentation/devicetree/bindings/crypto/samsung,exynos-rng4.txt
>>> +++ b/Documentation/devicetree/bindings/crypto/samsung,exynos-rng4.txt
>>> @@ -2,7 +2,9 @@ Exynos Pseudo Random Number Generator
>>>
>>>  Required properties:
>>>
>>> -- compatible  : Should be "samsung,exynos4-rng".
>>> +- compatible  : One of:
>>> +                - "samsung,exynos4-rng" for Exynos4210 and Exynos4412
>>> +                - "samsung,exynos5250-prng" for Exynos5250+
>>>  - reg         : Specifies base physical address and size of the registers map.
>>>  - clocks      : Phandle to clock-controller plus clock-specifier pair.
>>>  - clock-names : "secss" as a clock name.
>>> diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
>>> index 451620b475a0..894ef93ef5ec 100644
>>> --- a/drivers/crypto/exynos-rng.c
>>> +++ b/drivers/crypto/exynos-rng.c
>>> @@ -22,12 +22,17 @@
>>>  #include <linux/err.h>
>>>  #include <linux/io.h>
>>>  #include <linux/module.h>
>>> +#include <linux/of_device.h>
>>>  #include <linux/platform_device.h>
>>>
>>>  #include <crypto/internal/rng.h>
>>>
>>>  #define EXYNOS_RNG_CONTROL             0x0
>>>  #define EXYNOS_RNG_STATUS              0x10
>>> +
>>> +#define EXYNOS_RNG_SEED_CONF           0x14
>>> +#define EXYNOS_RNG_GEN_PRNG            0x02
>>
>> Use BIT(1) instead.
>>
>>> +
>>>  #define EXYNOS_RNG_SEED_BASE           0x140
>>>  #define EXYNOS_RNG_SEED(n)             (EXYNOS_RNG_SEED_BASE + (n * 0x4))
>>>  #define EXYNOS_RNG_OUT_BASE            0x160
>>> @@ -43,6 +48,11 @@
>>>  #define EXYNOS_RNG_SEED_REGS           5
>>>  #define EXYNOS_RNG_SEED_SIZE           (EXYNOS_RNG_SEED_REGS * 4)
>>>
>>> +enum exynos_prng_type {
>>> +       EXYNOS_PRNG_TYPE4 = 4,
>>> +       EXYNOS_PRNG_TYPE5 = 5,
>>
>> That's unusual numbering and naming, so just:
>> enum exynos_prng_type {
>>       EXYNOS_PRNG_EXYNOS4,
>>       EXYNOS_PRNG_EXYNOS5,
>> };
>>
>> Especially that TYPE4 and TYPE5 suggest so kind of sub-type (like
>> versions of some IP blocks, e.g. MFC) but it is just the family of
>> Exynos.
>
> Half done. I've changed TYPE to EXYNOS.
>
> I used explicit numbering in the enum because I want both values to act
> same true-false-wise. If one is 0 this condition is not met.

First of all - that condition cannot happen. It is not possible from
the device-matching code. But if you want to indicate it explicitly
(for code reviewing?) then how about:
enum exynos_prng_type {
       EXYNOS_PRNG_UNKNOWN = 0,
       EXYNOS_PRNG_EXYNOS4,
       EXYNOS_PRNG_EXYNOS5,
};

In such case you have the same effect but your intentions are clear
(you expect possibility of =0... which is not possible :) ).

>>> +};
>>> +
>>>  /*
>>>   * Driver re-seeds itself with generated random numbers to increase
>>>   * the randomness.
>>> @@ -63,6 +73,7 @@ struct exynos_rng_ctx {
>>>  /* Device associated memory */
>>>  struct exynos_rng_dev {
>>>         struct device                   *dev;
>>> +       enum exynos_prng_type           type;
>>>         void __iomem                    *mem;
>>>         struct clk                      *clk;
>>>         /* Generated numbers stored for seeding during resume */
>>> @@ -160,8 +171,13 @@ static int exynos_rng_get_random(struct exynos_rng_dev *rng,
>>>  {
>>>         int retry = EXYNOS_RNG_WAIT_RETRIES;
>>>
>>> -       exynos_rng_writel(rng, EXYNOS_RNG_CONTROL_START,
>>> -                         EXYNOS_RNG_CONTROL);
>>> +       if (rng->type == EXYNOS_PRNG_TYPE4) {
>>> +               exynos_rng_writel(rng, EXYNOS_RNG_CONTROL_START,
>>> +                                 EXYNOS_RNG_CONTROL);
>>> +       } else if (rng->type == EXYNOS_PRNG_TYPE5) {
>>> +               exynos_rng_writel(rng, EXYNOS_RNG_GEN_PRNG,
>>> +                                 EXYNOS_RNG_SEED_CONF);
>>> +       }
>>>
>>>         while (!(exynos_rng_readl(rng,
>>>                         EXYNOS_RNG_STATUS) & EXYNOS_RNG_STATUS_RNG_DONE) && --retry)
>>> @@ -279,6 +295,13 @@ static int exynos_rng_probe(struct platform_device *pdev)
>>>         if (!rng)
>>>                 return -ENOMEM;
>>>
>>> +       rng->type = (enum exynos_prng_type)of_device_get_match_data(&pdev->dev);
>>> +       if (rng->type != EXYNOS_PRNG_TYPE4 &&
>>> +           rng->type != EXYNOS_PRNG_TYPE5) {
>>> +               dev_err(&pdev->dev, "Unsupported PRNG type: %d", rng->type);
>>> +               return -ENOTSUPP;
>>> +       }
>>> +
>>>         rng->dev = &pdev->dev;
>>>         rng->clk = devm_clk_get(&pdev->dev, "secss");
>>>         if (IS_ERR(rng->clk)) {
>>> @@ -300,7 +323,10 @@ static int exynos_rng_probe(struct platform_device *pdev)
>>>                 dev_err(&pdev->dev,
>>>                         "Couldn't register rng crypto alg: %d\n", ret);
>>>                 exynos_rng_dev = NULL;
>>> -       }
>>> +       } else
>>
>> Missing {} around else clause. Probably checkpatch should point it.
>
> It doesn't. Fixed.
>
>>> +               dev_info(&pdev->dev,
>>> +                        "Exynos Pseudo Random Number Generator (type:%d)\n",
>>
>> dev_dbg, this is not that important information to affect the boot time.
>
> Quite many devices report their presence during boot with such
> messages. For example:
>
> [    3.390247] exynos-ehci 12110000.usb: EHCI Host Controller
> [    3.395493] exynos-ehci 12110000.usb: new USB bus registered, assigned bus number 1
> [    3.403702] exynos-ehci 12110000.usb: irq 80, io mem 0x12110000
> [    3.431793] exynos-ehci 12110000.usb: USB 2.0 started, EHCI 1.00
>
> From my experience it isn't printk() itself that slows down boot but the
> serial console.

True, the console is bottleneck (not necessarily serial) [1] but that
does not change the fact there is no need to print the type of RNG.
Before the device was not printing its presence and by adding support
for different flavor, you are adding the printk (not changing existing
printk). This driver is not that special to inform about flavor being
used especially that it is obvious from Exynos type (which comes from
board compatible). The example above prints resources so it brings
some information (not that useful but that is other point)... Really,
if every our driver started to inform how important he is, then the
info-level log would be polluted with a lot of useless printks. With
exynos-bus and exynos-nocp/event you can already find ridiculous
amount of useless messages.

[1] https://lwn.net/Articles/737822/

Best regards,
Krzysztof

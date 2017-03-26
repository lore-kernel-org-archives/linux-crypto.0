From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v3 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Sun, 26 Mar 2017 22:16:02 +0530
Message-ID: <CANc+2y4xkDs2kQGXKP=8i_v9oYw4dPKTjWs0xFnvOcwDbar47g@mail.gmail.com>
References: <20170325162654.3827-1-krzk@kernel.org> <20170325162654.3827-2-krzk@kernel.org>
 <CANc+2y4+1-oH50Y1tmTtOJ11snvi=FwNkjUbOE5ANPyNuzXOqg@mail.gmail.com> <20170326160126.nwboar7mwztwxtgp@kozik-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <20170326160126.nwboar7mwztwxtgp@kozik-lap>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 26 March 2017 at 21:31, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> On Sun, Mar 26, 2017 at 08:50:42PM +0530, PrasannaKumar Muralidharan wrote:
>> .Have some minor comments. Please feel free to correct if I am wrong.
>>
>> On 25 March 2017 at 21:56, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>> > diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
>> > new file mode 100644
>> > index 000000000000..d657b6243d0a
>> > --- /dev/null
>> > +++ b/drivers/crypto/exynos-rng.c
>> > @@ -0,0 +1,390 @@
>> > +/*
>> > + * exynos-rng.c - Random Number Generator driver for the Exynos
>> > + *
>> > + * Copyright (c) 2017 Krzysztof Kozlowski <krzk@kernel.org>
>> > + *
>> > + * Loosely based on old driver from drivers/char/hw_random/exynos-rng.c:
>> > + * Copyright (C) 2012 Samsung Electronics
>> > + * Jonghwa Lee <jonghwa3.lee@samsung.com>
>> > + *
>> > + * This program is free software; you can redistribute it and/or modify
>> > + * it under the terms of the GNU General Public License as published by
>> > + * the Free Software Foundation;
>> > + *
>> > + * This program is distributed in the hope that it will be useful,
>> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> > + * GNU General Public License for more details.
>> > + */
>> > +
>> > +#include <linux/clk.h>
>> > +#include <linux/crypto.h>
>> > +#include <linux/err.h>
>> > +#include <linux/io.h>
>> > +#include <linux/module.h>
>> > +#include <linux/platform_device.h>
>> > +
>> > +#include <crypto/internal/rng.h>
>> > +
>> > +#define EXYNOS_RNG_CONTROL             0x0
>> > +#define EXYNOS_RNG_STATUS              0x10
>> > +#define EXYNOS_RNG_SEED_BASE           0x140
>> > +#define EXYNOS_RNG_SEED(n)             (EXYNOS_RNG_SEED_BASE + (n * 0x4))
>> > +#define EXYNOS_RNG_OUT_BASE            0x160
>> > +#define EXYNOS_RNG_OUT(n)              (EXYNOS_RNG_OUT_BASE + (n * 0x4))
>> > +
>> > +/* EXYNOS_RNG_CONTROL bit fields */
>> > +#define EXYNOS_RNG_CONTROL_START       0x18
>> > +/* EXYNOS_RNG_STATUS bit fields */
>> > +#define EXYNOS_RNG_STATUS_SEED_SETTING_DONE    BIT(1)
>> > +#define EXYNOS_RNG_STATUS_RNG_DONE             BIT(5)
>> > +
>> > +/* Five seed and output registers, each 4 bytes */
>> > +#define EXYNOS_RNG_SEED_REGS           5
>> > +#define EXYNOS_RNG_SEED_SIZE           (EXYNOS_RNG_SEED_REGS * 4)
>> > +
>> > +/*
>> > + * Driver re-seeds itself with generated random numbers to increase
>> > + * the randomness.
>> > + *
>> > + * Time for next re-seed in ms.
>> > + */
>> > +#define EXYNOS_RNG_RESEED_TIME         100
>> > +/*
>> > + * In polling mode, do not wait infinitely for the engine to finish the work.
>> > + */
>> > +#define EXYNOS_RNG_WAIT_RETRIES                100
>> > +
>> > +/* Context for crypto */
>> > +struct exynos_rng_ctx {
>> > +       struct exynos_rng_dev           *rng;
>> > +};
>>
>> Is exynos_rng_ctx really necessary? Can't exynos_rng_dev be used directly?
>>
>
> I couldn't find a way to pass an instance of exynos_rng_dev to
> generate() and seed() calls.

While registering rng, sizeof exynos_rng_ctx is provided. Assumed that
the space allocated can be used instead of storing a reference to it.
Looking at crypto/rng.c I understand it could not be used.

>> > +/* Device associated memory */
>> > +struct exynos_rng_dev {
>> > +       struct device                   *dev;
>> > +       struct exynos_rng_ctx           *ctx;
>> > +       void __iomem                    *mem;
>> > +       struct clk                      *clk;
>> > +       /* Generated numbers stored for seeding during resume */
>> > +       u8                              seed_save[EXYNOS_RNG_SEED_SIZE];
>> > +       unsigned int                    seed_save_len;
>> > +       /* Time of last seeding in jiffies */
>> > +       unsigned long                   last_seeding;
>> > +};
>>
>> Wondering if storing 'ctx' is really necessary. Can that be eliminated?
>
> Yes, it can.
>
>> > +static struct exynos_rng_dev *exynos_rng_dev;
>>
>> Having an instance of exynos_rng_dev makes this driver to work with
>> only 1 rng hardware block. Is this desired?
>
> First of all, there is only one hardware block. ioremap_resource also
> ensures that. Second of all, how would you like to pass the
> platform device specific data to crypto calls?

Understood. See above.

>> Also having an instance of exynos_rng_dev seems unnecessary. Can it be removed?
>
> Why do you think it is unnecessary?

See above.

>>
>> > +static u32 exynos_rng_readl(struct exynos_rng_dev *rng, u32 offset)
>> > +{
>> > +       return readl_relaxed(rng->mem + offset);
>> > +}
>> > +
>> > +static void exynos_rng_writel(struct exynos_rng_dev *rng, u32 val, u32 offset)
>> > +{
>> > +       writel_relaxed(val, rng->mem + offset);
>> > +}
>> > +
>> > +static int exynos_rng_set_seed(struct exynos_rng_dev *rng,
>> > +                              const u8 *seed, unsigned int slen)
>> > +{
>> > +       u32 val;
>> > +       int i;
>> > +
>> > +       dev_dbg(rng->dev, "Seeding with %u bytes\n", slen);
>>
>> This log can be put after the 'slen < EXYNOS_RNG_SEED_SIZE' condition check.
>
> It can be put there but what is the benefit? The purpose of this log was
> to show the start of seeding so the beginning of function seems very
> natural to me.
>
>>
>> > +       if (slen < EXYNOS_RNG_SEED_SIZE) {
>> > +               dev_warn(rng->dev, "Seed too short (only %u bytes)\n", slen);
>> > +               return -EINVAL;
>> > +       }
>>
>> Will it be helpful to print the required seed size?
>
> It is in /proc/crypto... It is not a problem to print it but isn't that
> redundant?

Not necessary if it is already available.

>>
>> Also wondering if the seed size check is required as it is given as a
>> parameter while registering with crypto framework.
>
> Still the framework might pass something smaller but the size is a
> strict requirement by the code below and by the HW engine.

Okay. Got it.

>>
>> > +       for (i = 0 ; i < EXYNOS_RNG_SEED_REGS ; i++) {
>> > +               val = seed[i * 4] << 24;
>> > +               val |= seed[i * 4 + 1] << 16;
>> > +               val |= seed[i * 4 + 2] << 8;
>> > +               val |= seed[i * 4 + 3] << 0;
>> > +
>> > +               exynos_rng_writel(rng, val, EXYNOS_RNG_SEED(i));
>> > +       }
>> > +
>> > +       val = exynos_rng_readl(rng, EXYNOS_RNG_STATUS);
>> > +       if (!(val & EXYNOS_RNG_STATUS_SEED_SETTING_DONE)) {
>> > +               dev_warn(rng->dev, "Seed setting not finished\n");
>> > +               return -EIO;
>> > +       }
>> > +
>> > +       rng->last_seeding = jiffies;
>> > +
>> > +       return 0;
>> > +}
>> > +
>> > +/*
>> > + * Read from output registers and put the data under 'dst' array,
>> > + * up to dlen bytes.
>> > + *
>> > + * Returns number of bytes actually stored in 'dst' (dlen
>> > + * or EXYNOS_RNG_SEED_SIZE).
>> > + */
>> > +static unsigned int exynos_rng_copy_random(struct exynos_rng_dev *rng,
>> > +                                          u8 *dst, unsigned int dlen)
>> > +{
>> > +       unsigned int cnt = 0;
>> > +       int i, j;
>> > +       u32 val;
>> > +
>> > +       for (j = 0; j < EXYNOS_RNG_SEED_REGS; j++) {
>> > +               val = exynos_rng_readl(rng, EXYNOS_RNG_OUT(j));
>> > +
>> > +               for (i = 0; i < 4; i++) {
>> > +                       dst[cnt] = val & 0xff;
>> > +                       val >>= 8;
>> > +                       if (++cnt >= dlen)
>> > +                               return cnt;
>> > +               }
>> > +       }
>> > +
>> > +       return cnt;
>> > +}
>> > +
>> > +/*
>> > + * Start the engine and poll for finish.  Then read from output registers
>> > + * filling the 'dst' buffer up to 'dlen' bytes or up to size of generated
>> > + * random data (EXYNOS_RNG_SEED_SIZE).
>> > + *
>> > + * On success: return 0 and store number of read bytes under 'read' address.
>> > + * On error: return -ERRNO.
>> > + */
>> > +static int exynos_rng_get_random(struct exynos_rng_dev *rng,
>> > +                                u8 *dst, unsigned int dlen,
>> > +                                unsigned int *read)
>> > +{
>> > +       int retry = EXYNOS_RNG_WAIT_RETRIES;
>> > +
>> > +       exynos_rng_writel(rng, EXYNOS_RNG_CONTROL_START,
>> > +                         EXYNOS_RNG_CONTROL);
>> > +
>> > +       while (!(exynos_rng_readl(rng,
>> > +                       EXYNOS_RNG_STATUS) & EXYNOS_RNG_STATUS_RNG_DONE) && --retry)
>> > +               cpu_relax();
>> > +
>> > +       if (!retry)
>> > +               return -ETIMEDOUT;
>>
>> What would happen if the RNG block could not calculate data within the
>> timeout but did calculate random data after the timeout? In that case
>> the status bit would not have not been cleared. Will that cause an
>> issue?
>
> In such case we do not have control over it anyway. If HW does not work,
> then driver cannot fix it. I am not sure how would you want to handle
> such case?

If this case happens when HW does not work logging it will be helpful.
I do not have clear idea of how to handle this case but someone with
better exynos knowledge can provide more insight.

>>
>> > +       /* Clear status bit */
>> > +       exynos_rng_writel(rng, EXYNOS_RNG_STATUS_RNG_DONE,
>> > +                         EXYNOS_RNG_STATUS);
>> > +
>> > +       *read = exynos_rng_copy_random(rng, dst, dlen);
>> > +
>> > +       return 0;
>> > +}
>> > +
>> > +/* Re-seed itself from time to time */
>> > +static void exynos_rng_reseed(struct exynos_rng_dev *rng)
>> > +{
>> > +       unsigned long next_seeding = rng->last_seeding + \
>> > +                                    msecs_to_jiffies(EXYNOS_RNG_RESEED_TIME);
>> > +       unsigned long now = jiffies;
>> > +       u8 seed[EXYNOS_RNG_SEED_SIZE];
>> > +       unsigned int read;
>> > +
>> > +       if (time_before(now, next_seeding))
>> > +               return;
>> > +
>> > +       if (exynos_rng_get_random(rng, seed, sizeof(seed), &read))
>> > +               return;
>> > +
>> > +       exynos_rng_set_seed(rng, seed, read);
>> > +}
>> > +
>> > +static int exynos_rng_generate(struct crypto_rng *tfm,
>> > +                              const u8 *src, unsigned int slen,
>> > +                              u8 *dst, unsigned int dlen)
>> > +{
>> > +       struct exynos_rng_ctx *ctx = crypto_rng_ctx(tfm);
>> > +       struct exynos_rng_dev *rng = ctx->rng;
>> > +       unsigned int read = 0;
>> > +       int ret;
>> > +
>> > +       ret = clk_prepare_enable(rng->clk);
>> > +       if (ret)
>> > +               return ret;
>> > +
>> > +       do {
>> > +               ret = exynos_rng_get_random(rng, dst, dlen, &read);
>> > +               if (ret)
>> > +                       break;
>> > +
>> > +               dlen -= read;
>> > +               dst += read;
>> > +
>> > +               exynos_rng_reseed(rng);
>> > +       } while (dlen > 0);
>> > +
>> > +       clk_disable_unprepare(rng->clk);
>> > +
>> > +       return ret;
>> > +}
>> > +
>> > +static int exynos_rng_seed(struct crypto_rng *tfm, const u8 *seed,
>> > +                          unsigned int slen)
>> > +{
>> > +       struct exynos_rng_ctx *ctx = crypto_rng_ctx(tfm);
>> > +       struct exynos_rng_dev *rng = ctx->rng;
>> > +       int ret;
>> > +
>> > +       ret = clk_prepare_enable(rng->clk);
>> > +       if (ret)
>> > +               return ret;
>> > +
>> > +       ret = exynos_rng_set_seed(ctx->rng, seed, slen);
>> > +
>> > +       clk_disable_unprepare(rng->clk);
>> > +
>> > +       return ret;
>> > +}
>> > +
>> > +static int exynos_rng_kcapi_init(struct crypto_tfm *tfm)
>> > +{
>> > +       struct exynos_rng_ctx *ctx = crypto_tfm_ctx(tfm);
>> > +
>> > +       ctx->rng = exynos_rng_dev;
>> > +
>> > +       return 0;
>> > +}
>> > +
>> > +static struct rng_alg exynos_rng_alg = {
>> > +       .generate               = exynos_rng_generate,
>> > +       .seed                   = exynos_rng_seed,
>> > +       .seedsize               = EXYNOS_RNG_SEED_SIZE,
>> > +       .base                   = {
>> > +               .cra_name               = "exynos_rng",
>> > +               .cra_driver_name        = "exynos_rng",
>> > +               .cra_priority           = 100,
>> > +               .cra_ctxsize            = sizeof(struct exynos_rng_ctx),
>> > +               .cra_module             = THIS_MODULE,
>> > +               .cra_init               = exynos_rng_kcapi_init,
>> > +       }
>> > +};
>> > +
>> > +static int exynos_rng_probe(struct platform_device *pdev)
>> > +{
>> > +       struct exynos_rng_dev *rng;
>> > +       struct resource *res;
>> > +       int ret;
>> > +
>> > +       if (exynos_rng_dev)
>> > +               return -EEXIST;
>> > +
>> > +       rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
>> > +       if (!rng)
>> > +               return -ENOMEM;
>> > +
>> > +       rng->dev = &pdev->dev;
>> > +       rng->clk = devm_clk_get(&pdev->dev, "secss");
>> > +       if (IS_ERR(rng->clk)) {
>> > +               dev_err(&pdev->dev, "Couldn't get clock.\n");
>> > +               return PTR_ERR(rng->clk);
>> > +       }
>> > +
>> > +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> > +       rng->mem = devm_ioremap_resource(&pdev->dev, res);
>> > +       if (IS_ERR(rng->mem))
>> > +               return PTR_ERR(rng->mem);
>> > +
>> > +       platform_set_drvdata(pdev, rng);
>> > +
>> > +       exynos_rng_dev = rng;
>> > +
>> > +       ret = crypto_register_rng(&exynos_rng_alg);
>>
>> Do you mind adding devm_crypto_register_rng? If added the .remove
>> method will become unnecessary and error handling code can be removed.
>
> There is no devm_crypto_register_rng(). First it would have to be added.
> That is out of scope of this patch.

Yeah true, it is out of scope.

>>
>> > +       if (ret) {
>> > +               dev_err(&pdev->dev,
>> > +                       "Couldn't register rng crypto alg: %d\n", ret);
>> > +               exynos_rng_dev = NULL;
>> > +       }
>> > +
>> > +       return ret;
>> > +}
>> > +
>> > +static int exynos_rng_remove(struct platform_device *pdev)
>> > +{
>> > +       crypto_unregister_rng(&exynos_rng_alg);
>> > +
>> > +       exynos_rng_dev = NULL;
>>
>> This looks unnecessary as the module is unloading.
>
> I think it is necessary, because remove is called on unbind. Re-binding
> a device will not cause static memory to be initialized.

Makes sense.

FWIW, you can add:
Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>

Regards,
PrasannaKumar

FWIW, can add Reviewed-by: PrasannaKumar Muralidharan
<prasannatsmkumar@gmail.com>.

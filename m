From: Joshua Henderson <joshua.henderson@microchip.com>
Subject: Re: [PATCH 2/2] rng: pic32-rng: Add PIC32 RNG hardware driver
Date: Thu, 4 Feb 2016 09:23:50 -0700
Message-ID: <56B37B16.60605@microchip.com>
References: <1454366511-10640-1-git-send-email-joshua.henderson@microchip.com>
 <1454366511-10640-2-git-send-email-joshua.henderson@microchip.com>
 <56B1E30D.8090509@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-mips@linux-mips.org>,
	Purna Chandra Mandal <purna.mandal@microchip.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kieran Bingham <kieranbingham@gmail.com>,
	Lee Jones <lee.jones@linaro.org>,
	Pankaj Dev <pankaj.dev@st.com>,
	Scott Branden <sbranden@broadcom.com>,
	Ray Jui <rjui@broadcom.com>, <linux-crypto@vger.kernel.org>
To: Daniel Thompson <daniel.thompson@linaro.org>,
	<linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from exsmtp03.microchip.com ([198.175.253.49]:42368 "EHLO
	email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932330AbcBDQT5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Feb 2016 11:19:57 -0500
In-Reply-To: <56B1E30D.8090509@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Daniel,

On 02/03/2016 04:22 AM, Daniel Thompson wrote:
> On 01/02/16 22:41, Joshua Henderson wrote:
>> Add support for the hardware pseudo and true random number generator
>> peripheral found on PIC32.
>>
>> Signed-off-by: Joshua Henderson <joshua.henderson@microchip.com>
>> Signed-off-by: Purna Chandra Mandal <purna.mandal@microchip.com>
>> ---
>>   drivers/char/hw_random/Kconfig     |   13 +++
>>   drivers/char/hw_random/Makefile    |    1 +
>>   drivers/char/hw_random/pic32-rng.c |  152 ++++++++++++++++++++++++++++++++++++
>>   3 files changed, 166 insertions(+)
>>   create mode 100644 drivers/char/hw_random/pic32-rng.c
>>
>> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
>> index dbf2271..3ab0c46 100644
>> --- a/drivers/char/hw_random/Kconfig
>> +++ b/drivers/char/hw_random/Kconfig
>> @@ -381,6 +381,19 @@ config HW_RANDOM_STM32
>>
>>         If unsure, say N.
>>
>> +config HW_RANDOM_PIC32
>> +    tristate "Microchip PIC32 Random Number Generator support"
>> +    depends on HW_RANDOM && MACH_PIC32
>> +    default y
>> +    ---help---
>> +      This driver provides kernel-side support for the Random Number
>> +      Generator hardware found on a PIC32.
>> +
>> +      To compile this driver as a module, choose M here. the
>> +      module will be called pic32-rng.
>> +
>> +      If unsure, say Y.
>> +
>>   endif # HW_RANDOM
>>
>>   config UML_RANDOM
>> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
>> index 5ad3976..f5a6fa7 100644
>> --- a/drivers/char/hw_random/Makefile
>> +++ b/drivers/char/hw_random/Makefile
>> @@ -33,3 +33,4 @@ obj-$(CONFIG_HW_RANDOM_MSM) += msm-rng.o
>>   obj-$(CONFIG_HW_RANDOM_ST) += st-rng.o
>>   obj-$(CONFIG_HW_RANDOM_XGENE) += xgene-rng.o
>>   obj-$(CONFIG_HW_RANDOM_STM32) += stm32-rng.o
>> +obj-$(CONFIG_HW_RANDOM_PIC32) += pic32-rng.o
>> diff --git a/drivers/char/hw_random/pic32-rng.c b/drivers/char/hw_random/pic32-rng.c
>> new file mode 100644
>> index 0000000..d2f32c4
>> --- /dev/null
>> +++ b/drivers/char/hw_random/pic32-rng.c
>> @@ -0,0 +1,152 @@
>> +/*
>> + * PIC32 RNG driver
>> + *
>> + * Joshua Henderson <joshua.henderson@microchip.com>
>> + * Copyright (C) 2016 Microchip Technology Inc.  All rights reserved.
>> + *
>> + * This program is free software; you can distribute it and/or modify it
>> + * under the terms of the GNU General Public License (Version 2) as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
>> + * for more details.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/delay.h>
>> +#include <linux/slab.h>
>> +#include <linux/err.h>
>> +#include <linux/io.h>
>> +#include <linux/hw_random.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>> +#include <linux/clk.h>
>> +#include <linux/clkdev.h>
>> +
>> +#define RNGCON        0x04
>> +#define  TRNGEN        BIT(8)
>> +#define  PRNGEN        BIT(9)
>> +#define  PRNGCONT    BIT(10)
>> +#define  TRNGMOD    BIT(11)
>> +#define  SEEDLOAD    BIT(12)
>> +#define RNGPOLY1    0x08
>> +#define RNGPOLY2    0x0C
>> +#define RNGNUMGEN1    0x10
>> +#define RNGNUMGEN2    0x14
>> +#define RNGSEED1    0x18
>> +#define RNGSEED2    0x1C
>> +#define RNGRCNT        0x20
>> +#define  RCNT_MASK    0x7F
>> +
>> +struct pic32_rng {
>> +    void __iomem    *base;
>> +    struct hwrng    rng;
>> +    struct clk    *clk;
>> +};
>> +
>> +static int pic32_rng_read(struct hwrng *rng, void *buf, size_t max,
>> +              bool wait)
>> +{
>> +    struct pic32_rng *prng = container_of(rng, struct pic32_rng, rng);
>> +    u64 *data = buf;
>> +
>> +    *data = ((u64)readl(prng->base + RNGNUMGEN2) << 32) +
>> +        readl(prng->base + RNGNUMGEN1);
>> +    return 4;
>> +}
> 
> I have a number of questions at this point (although #3 is by far the most important).
> 
> 1. If the random number of 42-bit shouldn't this be return 5; ?

You are right. However, this will essentially be changed to 8 in response to moving to just the TRNG in comments below.

> 
> 2. If you really do mean return 4; then why mess about with all the
>    shifting. You can just read and discard the upper 32-bits.
> 
> 3. Why are you using the PRNG at all? The PRNG is a simple LSFR and
>    I don't think it ever gets reseeded at any point (meaning we get
>    almost no useful entropy from it at all).
> 
>    Far better to read directly from the TRNG.

Makes sense.  Typically we just use the TRNG to seed the LSFR, but I suppose there is no real reason to do this if max speed is not a concern (above 24Mbps which is max TRNG speed).  I'll convert the driver to just drop usage of the PRNG and only use the TRNG.

> 
> 
>> +
>> +static int pic32_rng_probe(struct platform_device *pdev)
>> +{
>> +    struct pic32_rng *prng;
>> +    struct resource *res;
>> +    u32 v, t;
>> +    int ret;
>> +
>> +    prng = devm_kzalloc(&pdev->dev, sizeof(*prng), GFP_KERNEL);
>> +    if (!prng)
>> +        return -ENOMEM;
>> +
>> +    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +    prng->base = devm_ioremap_resource(&pdev->dev, res);
>> +    if (IS_ERR(prng->base))
>> +        return PTR_ERR(prng->base);
>> +
>> +    prng->clk = devm_clk_get(&pdev->dev, NULL);
>> +    if (IS_ERR(prng->clk))
>> +        return PTR_ERR(prng->clk);
>> +
>> +    clk_prepare_enable(prng->clk);
>> +
>> +    /* enable TRNG in enhanced mode */
>> +    v = readl(prng->base + RNGCON);
>> +    v &= ~(TRNGEN | PRNGEN | 0xff);
>> +    v |= TRNGMOD;
>> +    writel(v | TRNGEN, prng->base + RNGCON);
>> +
>> +    /* wait for valid seed */
>> +    usleep_range(100, 200);
>> +    t = readl(prng->base + RNGRCNT) & RCNT_MASK;
>> +    if (t < 0x2A)
>> +        dev_warn(&pdev->dev, "seed not generated.\n");
>> +
>> +    /* load initial seed */
>> +    writel(v | SEEDLOAD, prng->base + RNGCON);
>> +
>> +    /* load initial polynomial: 42bit poly */
>> +    writel(0x00c00003, prng->base + RNGPOLY1);
>> +    writel(0x00000000, prng->base + RNGPOLY2);
>> +
>> +    /* start PRNG to generate 42bit random */
>> +    v |= 0x2A | PRNGCONT | PRNGEN;
>> +    writel(v, prng->base + RNGCON);
>> +
>> +    prng->rng.name = pdev->name;
>> +    prng->rng.read = pic32_rng_read;
>> +
>> +    ret = hwrng_register(&prng->rng);
>> +    if (ret)
>> +        goto err_register;
>> +
>> +    platform_set_drvdata(pdev, prng);
>> +
>> +    return 0;
>> +
>> +err_register:
>> +    return ret;
> 
> Looks like we leak clock references on this error path.

Good catch.  Will fix.

> 
> 
>> +
>> +static int pic32_rng_remove(struct platform_device *pdev)
>> +{
>> +    struct pic32_rng *rng = platform_get_drvdata(pdev);
>> +
>> +    hwrng_unregister(&rng->rng);
>> +    writel(0, rng->base + RNGCON);
>> +    clk_disable_unprepare(rng->clk);
>> +    return 0;
>> +}
>> +
>> +static const struct of_device_id pic32_rng_of_match[] = {
>> +    { .compatible    = "microchip,pic32mzda-rng", },
>> +    { /* sentinel */ }
>> +};
>> +MODULE_DEVICE_TABLE(of, pic32_rng_of_match);
>> +
>> +static struct platform_driver pic32_rng_driver = {
>> +    .probe        = pic32_rng_probe,
>> +    .remove        = pic32_rng_remove,
>> +    .driver        = {
>> +        .name    = "pic32-rng",
>> +        .owner    = THIS_MODULE,
>> +        .of_match_table = of_match_ptr(pic32_rng_of_match),
>> +    },
>> +};
>> +
>> +module_platform_driver(pic32_rng_driver);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Joshua Henderson <joshua.henderson@microchip.com>");
>> +MODULE_DESCRIPTION("Microchip PIC32 RNG Driver");
>>
> 

After a bit of testing, converting the driver to be pure TRNG does give good results with rngtest. Good call.  Will submit an update.

Thanks,
Josh

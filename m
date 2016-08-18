From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] Add Ingenic JZ4780 hardware RNG driver
Date: Thu, 18 Aug 2016 10:44:18 +0530
Message-ID: <CANc+2y55ZCkauwKNtuuCxLx-WOtm8z+A_EBKsYSjEUdc+ZbZTQ@mail.gmail.com>
References: <1471448151-20850-1-git-send-email-prasannatsmkumar@gmail.com> <92a00062-9a87-0053-2c99-17bd1a304a4a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: mpm@selenic.com, Herbert Xu <herbert@gondor.apana.org.au>,
	robh+dt@kernel.org, mark.rutland@arm.com,
	Ralf Baechle <ralf@linux-mips.org>, davem@davemloft.net,
	geert@linux-m68k.org, Andrew Morton <akpm@linux-foundation.org>,
	Greg KH <gregkh@linuxfoundation.org>, mchehab@kernel.org,
	Guenter Roeck <linux@roeck-us.net>,
	boris.brezillon@free-electrons.com, harvey.hunt@imgtec.com,
	alex.smith@imgtec.com,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Florian Fainelli <f.fainelli@gmail.com>,
	kieran@ksquared.org.uk, Krzysztof Kozlowski <krzk@kernel.org>,
	joshua.henderson@microchip.com, yendapally.reddy@broadcom.com,
	narmstrong@baylibre.com, wangkefeng.wang@huawei.com,
	Christian Lamparter <chunkeey@googlemail.com>,
	=?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>, pankaj.dev@st.com,
	Mathi
To: Corentin LABBE <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <92a00062-9a87-0053-2c99-17bd1a304a4a@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> I have just some minor comments below

Appreciate your review.

>> diff --git a/drivers/char/hw_random/jz4780-rng.c b/drivers/char/hw_random/jz4780-rng.c
>> new file mode 100644
>> index 0000000..c9d2cde
>> --- /dev/null
>> +++ b/drivers/char/hw_random/jz4780-rng.c
>> @@ -0,0 +1,105 @@
>> +/*
>> + * jz4780-rng.c - Random Number Generator driver for J4780
>> + *
>> + * Copyright 2016 (C) PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
>> + *
>> + * This file is licensed under  the terms of the GNU General Public
>> + * License version 2. This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +#include <linux/hw_random.h>
>> +#include <linux/device.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/io.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/err.h>
>
> You could sort them by alphabetical order

Sure, will do.

>> +
>> +#define REG_RNG_CTRL 0x0
>> +#define REG_RNG_DATA 0x4
>> +
>> +struct jz4780_rng {
>> +     struct device *dev;
>> +     struct hwrng rng;
>> +     void __iomem *mem;
>> +};
>> +
>> +static u32 jz4780_rng_readl(struct jz4780_rng *rng, u32 offset)
>> +{
>> +     return readl(rng->mem + offset);
>> +}
>> +
>> +static void jz4780_rng_writel(struct jz4780_rng *rng, u32 val, u32 offset)
>> +{
>> +     writel(val, rng->mem + offset);
>> +}
>> +
>> +static int jz4780_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
>> +{
>> +     struct jz4780_rng *jz4780_rng = container_of(rng, struct jz4780_rng,
>> +                                                     rng);
>> +     u32 *data = buf;
>> +     *data = jz4780_rng_readl(jz4780_rng, REG_RNG_DATA);
>> +     return 4;
>> +}
>
> If max is less than 4, its bad

Data will be 4 bytes.

>> +
>> +static int jz4780_rng_probe(struct platform_device *pdev)
>> +{
>> +     struct jz4780_rng *jz4780_rng;
>> +     struct resource *res;
>> +     resource_size_t size;
>> +     int ret;
>> +
>> +     jz4780_rng = devm_kzalloc(&pdev->dev, sizeof(struct jz4780_rng),
>> +                                     GFP_KERNEL);
>
> You could write sizeof(*js480_rng)

Will do.

>> +     if (!jz4780_rng)
>> +             return -ENOMEM;
>> +
>> +     jz4780_rng->dev = &pdev->dev;
>> +     jz4780_rng->rng.name = "jz4780";
>> +     jz4780_rng->rng.read = jz4780_rng_read;
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     size = resource_size(res);
>> +
>> +     jz4780_rng->mem = devm_ioremap(&pdev->dev, res->start, size);
> You could save code by using devm_ioremap_resource (don't need size)

Will do.

>> +     if (IS_ERR(jz4780_rng->mem))
>> +             return PTR_ERR(jz4780_rng->mem);
>> +
>> +     platform_set_drvdata(pdev, jz4780_rng);
>> +     jz4780_rng_writel(jz4780_rng, 1, REG_RNG_CTRL);
>> +     ret = hwrng_register(&jz4780_rng->rng);
>> +
>> +     return ret;
>> +}
> You could write directly return hwrng_register(..)

Will do.

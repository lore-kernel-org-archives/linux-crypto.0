From: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH] Add Ingenic JZ4780 hardware RNG driver
Date: Wed, 17 Aug 2016 21:06:55 +0200
Message-ID: <92a00062-9a87-0053-2c99-17bd1a304a4a@gmail.com>
References: <1471448151-20850-1-git-send-email-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
	mpm@selenic.com, herbert@gondor.apana.org.au, robh+dt@kernel.org,
	mark.rutland@arm.com, ralf@linux-mips.org, davem@davemloft.net,
	geert@linux-m68k.org, akpm@linux-foundation.org,
	gregkh@linuxfoundation.org, mchehab@kernel.org, linux@roeck-us.net,
	boris.brezillon@free-electrons.com, harvey.hunt@imgtec.com,
	alex.smith@imgtec.com, daniel.thompson@linaro.org,
	lee.jones@linaro.org, f.fainelli@gmail.com, kieran@ksquared.org.uk,
	krzk@kernel.org, joshua.henderson@microchip.com,
	yendapally.reddy@broadcom.com, narmstrong@baylibre.com,
	wangkefeng.wang@huawei.com, chunkeey@googlemail.com,
	noltari@gmail.com, linus.walleij@linaro.org, pankaj.dev@st.com,
	mathieu.poirier@linaro.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mips@linux-mips.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36700 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbcHQTHA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Aug 2016 15:07:00 -0400
In-Reply-To: <1471448151-20850-1-git-send-email-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

I have just some minor comments below

> diff --git a/drivers/char/hw_random/jz4780-rng.c b/drivers/char/hw_random/jz4780-rng.c
> new file mode 100644
> index 0000000..c9d2cde
> --- /dev/null
> +++ b/drivers/char/hw_random/jz4780-rng.c
> @@ -0,0 +1,105 @@
> +/*
> + * jz4780-rng.c - Random Number Generator driver for J4780
> + *
> + * Copyright 2016 (C) PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
> + *
> + * This file is licensed under  the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/hw_random.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include <linux/err.h>

You could sort them by alphabetical order

> +
> +#define REG_RNG_CTRL	0x0
> +#define REG_RNG_DATA	0x4
> +
> +struct jz4780_rng {
> +	struct device *dev;
> +	struct hwrng rng;
> +	void __iomem *mem;
> +};
> +
> +static u32 jz4780_rng_readl(struct jz4780_rng *rng, u32 offset)
> +{
> +	return readl(rng->mem + offset);
> +}
> +
> +static void jz4780_rng_writel(struct jz4780_rng *rng, u32 val, u32 offset)
> +{
> +	writel(val, rng->mem + offset);
> +}
> +
> +static int jz4780_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> +{
> +	struct jz4780_rng *jz4780_rng = container_of(rng, struct jz4780_rng,
> +							rng);
> +	u32 *data = buf;
> +	*data = jz4780_rng_readl(jz4780_rng, REG_RNG_DATA);
> +	return 4;
> +}

If max is less than 4, its bad

> +
> +static int jz4780_rng_probe(struct platform_device *pdev)
> +{
> +	struct jz4780_rng *jz4780_rng;
> +	struct resource *res;
> +	resource_size_t size;
> +	int ret;
> +
> +	jz4780_rng = devm_kzalloc(&pdev->dev, sizeof(struct jz4780_rng),
> +					GFP_KERNEL);

You could write sizeof(*js480_rng)

> +	if (!jz4780_rng)
> +		return -ENOMEM;
> +
> +	jz4780_rng->dev = &pdev->dev;
> +	jz4780_rng->rng.name = "jz4780";
> +	jz4780_rng->rng.read = jz4780_rng_read;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	size = resource_size(res);
> +
> +	jz4780_rng->mem = devm_ioremap(&pdev->dev, res->start, size);
You could save code by using devm_ioremap_resource (don't need size)

> +	if (IS_ERR(jz4780_rng->mem))
> +		return PTR_ERR(jz4780_rng->mem);
> +
> +	platform_set_drvdata(pdev, jz4780_rng);
> +	jz4780_rng_writel(jz4780_rng, 1, REG_RNG_CTRL);
> +	ret = hwrng_register(&jz4780_rng->rng);
> +
> +	return ret;
> +}
You could write directly return hwrng_register(..)

Regards

LABBE Corentin

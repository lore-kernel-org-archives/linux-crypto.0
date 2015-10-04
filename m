From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH 2/3] hwrng: stm32 - add support for STM32 HW RNG
Date: Sun, 4 Oct 2015 10:52:52 +0200
Message-ID: <5610E8E4.3040507@gmail.com>
References: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org>
 <1443904519-24012-3-git-send-email-daniel.thompson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@linaro.org, linaro-kernel@lists.linaro.org,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>
To: Daniel Thompson <daniel.thompson@linaro.org>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38639 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbbJDIw4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 Oct 2015 04:52:56 -0400
In-Reply-To: <1443904519-24012-3-git-send-email-daniel.thompson@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Daniel,

On 10/03/2015 10:35 PM, Daniel Thompson wrote:
> Add support for STMicroelectronics STM32 random number generator.
>
> The config value defaults to N, reflecting the fact that STM32 is a
> very low resource microcontroller platform and unlikely to be targeted
> by any "grown up" defconfigs.
>
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> ---
>   drivers/char/hw_random/Kconfig     |  12 +++
>   drivers/char/hw_random/Makefile    |   1 +
>   drivers/char/hw_random/stm32-rng.c | 192 +++++++++++++++++++++++++++++++++++++
>   3 files changed, 205 insertions(+)
>   create mode 100644 drivers/char/hw_random/stm32-rng.c
<snip>
> diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
> new file mode 100644
> index 000000000000..37dfa5fca105
> --- /dev/null
> +++ b/drivers/char/hw_random/stm32-rng.c
> @@ -0,0 +1,192 @@
<snip>
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/hw_random.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_address.h>
> +#include <linux/of_platform.h>
> +#include <linux/slab.h>
> +
> +#define RNG_CR 0x00
> +#define RNG_CR_RNGEN BIT(2)
> +
> +#define RNG_SR 0x04
> +#define RNG_SR_SEIS BIT(6)
> +#define RNG_SR_CEIS BIT(5)
> +#define RNG_SR_DRDY BIT(0)
> +
> +#define RNG_DR 0x08
> +
> +/*
> + * It takes 40 cycles @ 48MHz to generate each random number (e.g. <1us).
> + * At the time of writing STM32 parts max out at ~200MHz meaning a timeout
> + * of 500 leaves us a very comfortable margin for error. The loop to which
> + * the timeout applies takes at least 4 instructions per cycle so the
> + * timeout is enough to take us up to multi-GHz parts!
> + */
> +#define RNG_TIMEOUT 500
> +
> +struct stm32_rng_private {
> +	struct hwrng rng;
> +	void __iomem *base;
> +	struct clk *clk;
> +};
> +
> +static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
> +{
> +	struct stm32_rng_private *priv =
> +	    container_of(rng, struct stm32_rng_private, rng);
> +	u32 cr, sr;
> +	int retval = 0;
> +
> +	/* enable random number generation */
> +	clk_enable(priv->clk);
> +	cr = readl(priv->base + RNG_CR);
> +	writel(cr | RNG_CR_RNGEN, priv->base + RNG_CR);
> +
> +	while (max > sizeof(u32)) {
> +		sr = readl(priv->base + RNG_SR);
> +		if (!sr && wait) {
> +			unsigned int timeout = RNG_TIMEOUT;
> +
> +			do {
> +				cpu_relax();
> +				sr = readl(priv->base + RNG_SR);
> +			} while (!sr && --timeout);
> +		}
> +
> +		/* Has h/ware error dection been triggered? */
> +		if (WARN_ON(sr & (RNG_SR_SEIS | RNG_SR_CEIS)))
Maybe you should instead use WARN_ONCE?
Because from what I understand in the datasheet, CEIS bit indicates and 
error with clock configuration.
If that happens, it is likely the same error will occur each time this 
function will be called.

> +			break;
> +
> +		/* No data ready... */
> +		if (!sr)
> +			break;
Maybe you could perform this check before the error detection, as if 
!sr, the HW error condition will be always false.
> +
> +		*(u32 *)data = readl(priv->base + RNG_DR);
> +
> +		retval += sizeof(u32);
> +		data += sizeof(u32);
> +		max -= sizeof(u32);
> +	}
> +
> +	/* disable the generator */
> +	writel(cr, priv->base + RNG_CR);
> +	clk_disable(priv->clk);
> +
> +	return retval || !wait ? retval : -EIO;
> +}

Couldn't we use "_relaxed" versions of readl/writel?
I might save some not needed barriers.

> +static int stm32_rng_probe(struct platform_device *ofdev)
> +{
> +	struct device *dev = &ofdev->dev;
> +	struct device_node *np = ofdev->dev.of_node;
> +	struct stm32_rng_private *priv;
> +	struct resource res;
> +	int err;
> +
> +	priv = devm_kzalloc(dev, sizeof(struct stm32_rng_private), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	err = of_address_to_resource(np, 0, &res);
> +	if (err)
> +		return err;
> +
> +	priv->base = devm_ioremap_resource(dev, &res);
> +	if (IS_ERR(priv->base))
> +		return PTR_ERR(priv->base);
> +
> +	priv->clk = devm_clk_get(&ofdev->dev, NULL);
> +	if (IS_ERR(priv->clk))
> +		return PTR_ERR(priv->clk);
> +
> +	dev_set_drvdata(dev, priv);
> +
> +	priv->rng.name = dev_driver_string(dev),
> +	priv->rng.init = stm32_rng_init,
> +	priv->rng.cleanup = stm32_rng_cleanup,
> +	priv->rng.read = stm32_rng_read,
> +	priv->rng.priv = (unsigned long) dev;
> +
> +	err = hwrng_register(&priv->rng);
> +	if (err)
> +		return err;
> +
> +	return 0;
As detected with Coccinelle by Fengguang build system, you could simplify:
return hwrng_register(&priv->rng);

Regards,
Maxime

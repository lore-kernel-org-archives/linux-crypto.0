Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E890C18E773;
	Fri, 18 Oct 2024 08:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.53.16.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729241707; cv=none; b=ccnLGXRlEVDd1awKIKHqT/wAMMgTgGiSLybjXo4AdddsaKKX9vgqHNn7TaVGOzqVLES3QkJNVpx+uIOG0+EBvwluU2v6S/2gvUI7YJdt88uiNBUMfP2kHa7fNRYynV6B4+LTVfjgx8romxNLaf+9Jrm/2LDUfk7Y4WduUilQ1TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729241707; c=relaxed/simple;
	bh=yTQaO+pZKg8NCO4FTSbrrB1+s5S4hYRqIImR5bavexE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovMqxPsluYO2jFTqLS7hR/XOMeBLzcGNvhDViptsD8jyhmlk7R2WbSCTQ2HUno9azegZs9YLVx59mteiJ64Pz3zNsnPTLwRKnXvGCCi10gSLHWedwRyIYK/LC8Yl0o4u5GI/xafVaRYmbWCqTlmTrq7gzo4YZjpaqB89e/dbRSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaiser.cx; spf=pass smtp.mailfrom=kaiser.cx; arc=none smtp.client-ip=152.53.16.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from martin by akranes.kaiser.cx with local (Exim 4.96)
	(envelope-from <martin@akranes.kaiser.cx>)
	id 1t1iTl-000Nos-2u;
	Fri, 18 Oct 2024 10:37:01 +0200
Date: Fri, 18 Oct 2024 10:37:01 +0200
From: Martin Kaiser <martin@kaiser.cx>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Daniel Golle <daniel@makrotopia.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lorenzo Bianconi <lorenzo@kernel.org>, upstream@airoha.com
Subject: Re: [PATCH v2 2/2] hwrng: add support for Airoha EN7581 TRNG
Message-ID: <ZxIeLdWSV0IR-qUt@akranes.kaiser.cx>
References: <20241017124456.32584-1-ansuelsmth@gmail.com>
 <20241017124456.32584-2-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017124456.32584-2-ansuelsmth@gmail.com>
Sender: "Martin Kaiser,,," <martin@akranes.kaiser.cx>

Hi,

Thus wrote Christian Marangi (ansuelsmth@gmail.com):

> Add support for Airoha TRNG. The Airoha SoC provide a True RNG module
> that can output 4 bytes of raw data at times.

> The module makes use of various noise source to provide True Random
> Number Generation.

> On probe the module is reset to operate Health Test and verify correct
> execution of it.

> The module can also provide DRBG function but the execution mode is
> mutually exclusive, running as TRNG doesn't permit to also run it as
> DRBG.

> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
> Changes v2:
> - Sort include header
> - Add missing bitfield.h

>  drivers/char/hw_random/Kconfig       |  13 ++
>  drivers/char/hw_random/Makefile      |   1 +
>  drivers/char/hw_random/airoha-trng.c | 243 +++++++++++++++++++++++++++
>  3 files changed, 257 insertions(+)
>  create mode 100644 drivers/char/hw_random/airoha-trng.c

> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 5912c2dd6398..bda283f290bc 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -62,6 +62,19 @@ config HW_RANDOM_AMD

>  	  If unsure, say Y.

> +config HW_RANDOM_AIROHA
> +	tristate "Airoha True HW Random Number Generator support"
> +	depends on ARCH_AIROHA || COMPILE_TEST
> +	default HW_RANDOM
> +	help
> +	  This driver provides kernel-side support for the True Random Number
> +	  Generator hardware found on Airoha SoC.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called airoha-rng.
> +
> +	  If unsure, say Y.
> +
>  config HW_RANDOM_ATMEL
>  	tristate "Atmel Random Number Generator support"
>  	depends on (ARCH_AT91 || COMPILE_TEST)
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> index 01f012eab440..dfb717b12f0b 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -8,6 +8,7 @@ rng-core-y := core.o
>  obj-$(CONFIG_HW_RANDOM_TIMERIOMEM) += timeriomem-rng.o
>  obj-$(CONFIG_HW_RANDOM_INTEL) += intel-rng.o
>  obj-$(CONFIG_HW_RANDOM_AMD) += amd-rng.o
> +obj-$(CONFIG_HW_RANDOM_AIROHA) += airoha-trng.o
>  obj-$(CONFIG_HW_RANDOM_ATMEL) += atmel-rng.o
>  obj-$(CONFIG_HW_RANDOM_BA431) += ba431-rng.o
>  obj-$(CONFIG_HW_RANDOM_GEODE) += geode-rng.o
> diff --git a/drivers/char/hw_random/airoha-trng.c b/drivers/char/hw_random/airoha-trng.c
> new file mode 100644
> index 000000000000..1dbfa9505c21
> --- /dev/null
> +++ b/drivers/char/hw_random/airoha-trng.c
> @@ -0,0 +1,243 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2024 Christian Marangi */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/bitfield.h>
> +#include <linux/delay.h>
> +#include <linux/hw_random.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/iopoll.h>
> +#include <linux/platform_device.h>
> +
> +#define TRNG_IP_RDY			0x800
> +#define   CNT_TRANS			GENMASK(15, 8)
> +#define   SAMPLE_RDY			BIT(0)
> +#define TRNG_NS_SEK_AND_DAT_EN		0x804
> +#define	  RNG_EN			BIT(31) /* referenced as ring_en */
> +#define	  RAW_DATA_EN			BIT(16)
> +#define TRNG_HEALTH_TEST_SW_RST		0x808
> +#define   SW_RST			BIT(0) /* Active High */
> +#define TRNG_INTR_EN			0x818
> +#define   INTR_MASK			BIT(16)
> +#define   CONTINUOUS_HEALTH_INITR_EN	BIT(2)
> +#define   SW_STARTUP_INITR_EN		BIT(1)
> +#define   RST_STARTUP_INITR_EN		BIT(0)
> +/* Notice that Health Test are done only out of Reset and with RNG_EN */
> +#define TRNG_HEALTH_TEST_STATUS		0x824
> +#define   CONTINUOUS_HEALTH_AP_TEST_FAIL BIT(23)
> +#define   CONTINUOUS_HEALTH_RC_TEST_FAIL BIT(22)
> +#define   SW_STARTUP_TEST_DONE		BIT(21)
> +#define   SW_STARTUP_AP_TEST_FAIL	BIT(20)
> +#define   SW_STARTUP_RC_TEST_FAIL	BIT(19)
> +#define   RST_STARTUP_TEST_DONE		BIT(18)
> +#define   RST_STARTUP_AP_TEST_FAIL	BIT(17)
> +#define   RST_STARTUP_RC_TEST_FAIL	BIT(16)
> +#define   RAW_DATA_VALID		BIT(7)
> +
> +#define TRNG_RAW_DATA_OUT		0x828
> +
> +#define TRNG_CNT_TRANS_VALID		0x80
> +#define BUSY_LOOP_SLEEP			10
> +#define BUSY_LOOP_TIMEOUT		(BUSY_LOOP_SLEEP * 10000)
> +
> +struct airoha_trng {
> +	void __iomem *base;
> +	struct hwrng rng;
> +	struct device *dev;
> +
> +	struct completion rng_op_done;
> +};
> +
> +static int airoha_trng_irq_mask(struct airoha_trng *trng)
> +{
> +	u32 val;
> +
> +	val = readl(trng->base + TRNG_INTR_EN);
> +	val |= INTR_MASK;
> +	writel(val, trng->base + TRNG_INTR_EN);
> +
> +	return 0;
> +}
> +
> +static int airoha_trng_irq_unmask(struct airoha_trng *trng)
> +{
> +	u32 val;
> +
> +	val = readl(trng->base + TRNG_INTR_EN);
> +	val &= ~INTR_MASK;
> +	writel(val, trng->base + TRNG_INTR_EN);
> +
> +	return 0;
> +}
> +
> +static int airoha_trng_init(struct hwrng *rng)
> +{
> +	struct airoha_trng *trng = container_of(rng, struct airoha_trng, rng);
> +	int ret;
> +	u32 val;
> +
> +	val = readl(trng->base + TRNG_NS_SEK_AND_DAT_EN);
> +	val |= RNG_EN;
> +	writel(val, trng->base + TRNG_NS_SEK_AND_DAT_EN);
> +
> +	/* Set out of SW Reset */
> +	airoha_trng_irq_unmask(trng);
> +	writel(0, trng->base + TRNG_HEALTH_TEST_SW_RST);
> +
> +	ret = wait_for_completion_timeout(&trng->rng_op_done, BUSY_LOOP_TIMEOUT);
> +	if (ret <= 0) {
> +		dev_err(trng->dev, "Timeout waiting for Health Check\n");
> +		airoha_trng_irq_mask(trng);
> +		return -ENODEV;
> +	}
> +
> +	/* Check if Health Test Failed */
> +	val = readl(trng->base + TRNG_HEALTH_TEST_STATUS);
> +	if (val & (RST_STARTUP_AP_TEST_FAIL | RST_STARTUP_RC_TEST_FAIL)) {
> +		dev_err(trng->dev, "Health Check fail: %s test fail\n",
> +			val & RST_STARTUP_AP_TEST_FAIL ? "AP" : "RC");
> +		return -ENODEV;
> +	}
> +
> +	/* Check if IP is ready */
> +	ret = readl_poll_timeout(trng->base + TRNG_IP_RDY, val,
> +				 val & SAMPLE_RDY, 10, 1000);
> +	if (ret < 0) {
> +		dev_err(trng->dev, "Timeout waiting for IP ready");
> +		return -ENODEV;
> +	}

You could use dev_err_probe instead of dev_err + return here and in other
similar places.

Apart from this small remark, the driver looks good to me.

Reviewed-by: Martin Kaiser <martin@kaiser.cx>

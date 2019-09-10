Return-Path: <SRS0=06DT=XF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8142C3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 11:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B766207FC
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 11:08:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="suOPdwHe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731006AbfIJLIc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Sep 2019 07:08:32 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45879 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729627AbfIJLIc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Sep 2019 07:08:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id l16so19251008wrv.12
        for <linux-crypto@vger.kernel.org>; Tue, 10 Sep 2019 04:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TT9ay8VA/8Z26oNC52f3pHvdCw0V8jucRX2Flg2bxfA=;
        b=suOPdwHemZbw91YBHd6NgAYwEaiuhaU4N1IL9n4q/cs6V6s2EJ0Xi0uH6h/ZnrSmvE
         vc3mXrdl/6DVGgdJqXe4B/2SPd10uxBoAmh2qksC5ULvARTdN2Yn29auD/vqrI0gLUXd
         gCz95awVJQ6cnEpTKEVkrg6BON54w/jy5CKMk32vDWTPEOUY5ubhbW9KMlFpOwx/yvJo
         rvIbMPE8sbbqOaGg3ZXO/ajjqHYz9NRsI4r9KH2FFeuz9fVS2TvMlcOlXHfCcMgPtD4q
         SHe9U6sDVXSCdO1zpc2xxh72DnZBNfWFK12VNdrWz+LDtLsq30wDMQnuOSlHtXb1vgsX
         YhuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TT9ay8VA/8Z26oNC52f3pHvdCw0V8jucRX2Flg2bxfA=;
        b=tr2vBxsCu1thg3HEzl/jccZrzkwQz3FCSDX5nzxDVspJW4+/QZEnXbEJGOkEnN3jm7
         w9cuTmfnCPUKdcouV5BPRU3C4wHFCOHxlARZTA87/9dzZ9TkkZ5KVztpQGsXuHGKIg+r
         jtz2uV5YEhj4LZxLwp70XjRfXHqXYVgJT6ScJzqDcifmIMJFYN6jPruorX+n8SXaAZ5v
         745/1U24QXmUTvktHGbVAD75g7kuxXxPqSV0J7iWHSoaYj78gWWXoAMRIfjEWIxlF1fp
         l1QgcA2vFbH6ucmNQGpyCVfIjBlxfn5ZJPQK2jI1/ExxPRxKQODxaoEcquGZ3zB1G/3m
         BXRg==
X-Gm-Message-State: APjAAAUNErBKnmppgummuNFUH8FKxmDD0SqTMXvxgI9HfonhfNq9HQMT
        nBoxbx8R4mCK8/O3eEa4xbbEQA==
X-Google-Smtp-Source: APXvYqyk6ORRXsQpRmCNe6PgxH8UUG6Rfdmp02mlKecQ1aQ/7GYSboKyjZbGI2KO5XDpBsGJqSBu4g==
X-Received: by 2002:adf:e342:: with SMTP id n2mr8223960wrj.341.1568113708740;
        Tue, 10 Sep 2019 04:08:28 -0700 (PDT)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id q15sm21922247wrg.65.2019.09.10.04.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 04:08:28 -0700 (PDT)
Date:   Tue, 10 Sep 2019 12:08:26 +0100
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Tomer Maimon <tmaimon77@gmail.com>
Cc:     mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, robh+dt@kernel.org,
        mark.rutland@arm.com, avifishman70@gmail.com,
        tali.perry1@gmail.com, venture@google.com, yuenn@google.com,
        benjaminfair@google.com, sumit.garg@linaro.org,
        jens.wiklander@linaro.org, vkoul@kernel.org, tglx@linutronix.de,
        joel@jms.id.au, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        openbmc@lists.ozlabs.org
Subject: Re: [PATCH v2 2/2] hwrng: npcm: add NPCM RNG driver
Message-ID: <20190910110826.qoqyrsi5fkshgax5@holly.lan>
References: <20190909123840.154745-1-tmaimon77@gmail.com>
 <20190909123840.154745-3-tmaimon77@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909123840.154745-3-tmaimon77@gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 09, 2019 at 03:38:40PM +0300, Tomer Maimon wrote:
> Add Nuvoton NPCM BMC Random Number Generator(RNG) driver.
> 
> Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
> ---
>  drivers/char/hw_random/Kconfig    |  13 ++
>  drivers/char/hw_random/Makefile   |   1 +
>  drivers/char/hw_random/npcm-rng.c | 203 ++++++++++++++++++++++++++++++
>  3 files changed, 217 insertions(+)
>  create mode 100644 drivers/char/hw_random/npcm-rng.c
> 
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 59f25286befe..87a1c30e7958 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -440,6 +440,19 @@ config HW_RANDOM_OPTEE
>  
>  	  If unsure, say Y.
>  
> +config HW_RANDOM_NPCM
> +	tristate "NPCM Random Number Generator support"
> +	depends on ARCH_NPCM || COMPILE_TEST
> +	default HW_RANDOM
> +	help
> + 	  This driver provides support for the Random Number
> +	  Generator hardware available in Nuvoton NPCM SoCs.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called npcm-rng.
> +
> + 	  If unsure, say Y.
> +
>  endif # HW_RANDOM
>  
>  config UML_RANDOM
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> index 7c9ef4a7667f..17b6d4e6d591 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -39,3 +39,4 @@ obj-$(CONFIG_HW_RANDOM_MTK)	+= mtk-rng.o
>  obj-$(CONFIG_HW_RANDOM_S390) += s390-trng.o
>  obj-$(CONFIG_HW_RANDOM_KEYSTONE) += ks-sa-rng.o
>  obj-$(CONFIG_HW_RANDOM_OPTEE) += optee-rng.o
> +obj-$(CONFIG_HW_RANDOM_NPCM) += npcm-rng.o
> diff --git a/drivers/char/hw_random/npcm-rng.c b/drivers/char/hw_random/npcm-rng.c
> new file mode 100644
> index 000000000000..3ed396474563
> --- /dev/null
> +++ b/drivers/char/hw_random/npcm-rng.c
> @@ -0,0 +1,203 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Nuvoton Technology corporation.
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/iopoll.h>
> +#include <linux/init.h>
> +#include <linux/random.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/hw_random.h>
> +#include <linux/delay.h>
> +#include <linux/of_irq.h>
> +#include <linux/pm_runtime.h>
> +
> +#define NPCM_RNGCS_REG		0x00	/* Control and status register */
> +#define NPCM_RNGD_REG		0x04	/* Data register */
> +#define NPCM_RNGMODE_REG	0x08	/* Mode register */
> +
> +#define NPCM_RNG_CLK_SET_25MHZ	GENMASK(4, 3) /* 20-25 MHz */
> +#define NPCM_RNG_DATA_VALID	BIT(1)
> +#define NPCM_RNG_ENABLE		BIT(0)
> +#define NPCM_RNG_M1ROSEL	BIT(1)
> +
> +#define NPCM_RNG_TIMEOUT_USEC	20000
> +#define NPCM_RNG_POLL_USEC	1000
> +
> +#define to_npcm_rng(p)	container_of(p, struct npcm_rng, rng)
> +
> +struct npcm_rng {
> +	void __iomem *base;
> +	struct hwrng rng;
> +};
> +
> +static int npcm_rng_init(struct hwrng *rng)
> +{
> +	struct npcm_rng *priv = to_npcm_rng(rng);
> +	u32 val;
> +
> +	val = readl(priv->base + NPCM_RNGCS_REG);
> +	val |= NPCM_RNG_ENABLE;
> +	writel(val, priv->base + NPCM_RNGCS_REG);
> +
> +	return 0;
> +}
> +
> +static void npcm_rng_cleanup(struct hwrng *rng)
> +{
> +	struct npcm_rng *priv = to_npcm_rng(rng);
> +	u32 val;
> +
> +	val = readl(priv->base + NPCM_RNGCS_REG);
> +	val &= ~NPCM_RNG_ENABLE;
> +	writel(val, priv->base + NPCM_RNGCS_REG);
> +}
> +
> +static int npcm_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> +{
> +	struct npcm_rng *priv = to_npcm_rng(rng);
> +	int retval = 0;
> +	int ready;
> +
> +	pm_runtime_get_sync((struct device *)priv->rng.priv);
> +
> +	while (max >= sizeof(u32)) {
> +		ready = readl(priv->base + NPCM_RNGCS_REG) &
> +			NPCM_RNG_DATA_VALID;
> +		if (!ready) {
> +			if (wait) {
> +				if (readl_poll_timeout(priv->base + NPCM_RNGCS_REG,
> +						       ready,
> +						       ready & NPCM_RNG_DATA_VALID,
> +						       NPCM_RNG_POLL_USEC,
> +						       NPCM_RNG_TIMEOUT_USEC))
> +					break;
> +			} else {
> +				break;
> +			}

This would read easier without breaking on the else clause:

			if (!wait)
				break;

			if (readl_poll_timeout(...))
				break;

> +		}
> +
> +		*(u32 *)buf = readl(priv->base + NPCM_RNGD_REG);
> +		retval += sizeof(u32);
> +		buf += sizeof(u32);
> +		max -= sizeof(u32);
> +	}
> +
> +	pm_runtime_mark_last_busy((struct device *)priv->rng.priv);
> +	pm_runtime_put_sync_autosuspend((struct device *)priv->rng.priv);
> +
> +	return retval || !wait ? retval : -EIO;
> +}
> +
> +static int npcm_rng_probe(struct platform_device *pdev)
> +{
> +	struct npcm_rng *priv;
> +	struct resource *res;
> +	bool pm_dis = false;
> +	u32 quality;
> +	int ret;
> +
> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	priv->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->base))
> +		return PTR_ERR(priv->base);
> +
> +	priv->rng.name = pdev->name;
> +#ifndef CONFIG_PM
> +	pm_dis = true;
> +	priv->rng.init = npcm_rng_init;
> +	priv->rng.cleanup = npcm_rng_cleanup;
> +#endif
> +	priv->rng.read = npcm_rng_read;
> +	priv->rng.priv = (unsigned long)&pdev->dev;
> +	if (of_property_read_u32(pdev->dev.of_node, "quality", &quality))
> +		priv->rng.quality = 1000;
> +	else
> +		priv->rng.quality = quality;
> +
> +	writel(NPCM_RNG_M1ROSEL, priv->base + NPCM_RNGMODE_REG);
> +	if (pm_dis)
> +		writel(NPCM_RNG_CLK_SET_25MHZ, priv->base + NPCM_RNGCS_REG);
> +	else
> +		writel(NPCM_RNG_CLK_SET_25MHZ | NPCM_RNG_ENABLE,
> +		       priv->base + NPCM_RNGCS_REG);

This still doesn't seem right and its not simply because pm_dis is an
obfuscated way to write IS_ENABLED(CONFIG_PM).

I'd like to understand why the call to pm_runtime_get_sync() isn't
resulting in the device resume callback running... it is simply
because the hwrng_register() happens before the pm_runtime_enable() ?


Daniel.

> +
> +	ret = devm_hwrng_register(&pdev->dev, &priv->rng);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to register rng device: %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	dev_set_drvdata(&pdev->dev, priv);
> +	pm_runtime_set_autosuspend_delay(&pdev->dev, 100);
> +	pm_runtime_use_autosuspend(&pdev->dev);
> +	pm_runtime_enable(&pdev->dev);
> +
> +	return 0;
> +}
> +
> +static int npcm_rng_remove(struct platform_device *pdev)
> +{
> +	struct npcm_rng *priv = platform_get_drvdata(pdev);
> +
> +	hwrng_unregister(&priv->rng);
> +	pm_runtime_disable(&pdev->dev);
> +	pm_runtime_set_suspended(&pdev->dev);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int npcm_rng_runtime_suspend(struct device *dev)
> +{
> +	struct npcm_rng *priv = dev_get_drvdata(dev);
> +
> +	npcm_rng_cleanup(&priv->rng);
> +
> +	return 0;
> +}
> +
> +static int npcm_rng_runtime_resume(struct device *dev)
> +{
> +	struct npcm_rng *priv = dev_get_drvdata(dev);
> +
> +	return npcm_rng_init(&priv->rng);
> +}
> +#endif
> +
> +static const struct dev_pm_ops npcm_rng_pm_ops = {
> +	SET_RUNTIME_PM_OPS(npcm_rng_runtime_suspend,
> +			   npcm_rng_runtime_resume, NULL)
> +	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
> +				pm_runtime_force_resume)
> +};
> +
> +static const struct of_device_id rng_dt_id[] = {
> +	{ .compatible = "nuvoton,npcm750-rng",  },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, rng_dt_id);
> +
> +static struct platform_driver npcm_rng_driver = {
> +	.driver = {
> +		.name		= "npcm-rng",
> +		.pm		= &npcm_rng_pm_ops,
> +		.owner		= THIS_MODULE,
> +		.of_match_table = of_match_ptr(rng_dt_id),
> +	},
> +	.probe		= npcm_rng_probe,
> +	.remove		= npcm_rng_remove,
> +};
> +
> +module_platform_driver(npcm_rng_driver);
> +
> +MODULE_DESCRIPTION("Nuvoton NPCM Random Number Generator Driver");
> +MODULE_AUTHOR("Tomer Maimon <tomer.maimon@nuvoton.com>");
> +MODULE_LICENSE("GPL v2");
> -- 
> 2.18.0
> 

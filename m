Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97ADFC433DB
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 08:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66B0F64FEA
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Mar 2021 08:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhCEIIL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Mar 2021 03:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhCEIIG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Mar 2021 03:08:06 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9517C061574
        for <linux-crypto@vger.kernel.org>; Fri,  5 Mar 2021 00:08:06 -0800 (PST)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1lI5Ux-0004nt-Hu; Fri, 05 Mar 2021 09:07:47 +0100
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1lI5Uj-0003Ld-FI; Fri, 05 Mar 2021 09:07:33 +0100
Message-ID: <22817e0d7f266ebf2d8e6b28495736cdb9c6d6f3.camel@pengutronix.de>
Subject: Re: [PATCH v6 3/3] hwrng: bcm2835: add reset support
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     =?ISO-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Lee Jones <lee.jones@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 05 Mar 2021 09:07:33 +0100
In-Reply-To: <20210305070132.2986-4-noltari@gmail.com>
References: <20210305070132.2986-1-noltari@gmail.com>
         <20210305070132.2986-4-noltari@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 2021-03-05 at 08:01 +0100, Álvaro Fernández Rojas wrote:
> BCM6368 devices need to reset the IPSEC controller in order to generate true
> random numbers.
> 
> This is what BCM6368 produces without a reset:
> root@OpenWrt:/# cat /dev/hwrng | rngtest -c 1000
> rngtest 6.10
> Copyright (c) 2004 by Henrique de Moraes Holschuh
> This is free software; see the source for copying conditions.  There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 0
> rngtest: FIPS 140-2 failures: 1000
> rngtest: FIPS 140-2(2001-10-10) Monobit: 2
> rngtest: FIPS 140-2(2001-10-10) Poker: 1000
> rngtest: FIPS 140-2(2001-10-10) Runs: 1000
> rngtest: FIPS 140-2(2001-10-10) Long run: 30
> rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> rngtest: input channel speed: (min=37.253; avg=320.827; max=635.783)Mibits/s
> rngtest: FIPS tests speed: (min=12.141; avg=15.034; max=16.428)Mibits/s
> rngtest: Program run time: 1336176 microseconds
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

> ---
>  v6: fix commit description.
>  v5: remove reset_control_rearm().
>  v4: add reset_control_rearm().
>  v3: no changes.
>  v2: no changes.
> 
>  drivers/char/hw_random/bcm2835-rng.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
> index be5be395b341..e7dd457e9b22 100644
> --- a/drivers/char/hw_random/bcm2835-rng.c
> +++ b/drivers/char/hw_random/bcm2835-rng.c
> @@ -13,6 +13,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/printk.h>
>  #include <linux/clk.h>
> +#include <linux/reset.h>
>  
>  #define RNG_CTRL	0x0
>  #define RNG_STATUS	0x4
> @@ -32,6 +33,7 @@ struct bcm2835_rng_priv {
>  	void __iomem *base;
>  	bool mask_interrupts;
>  	struct clk *clk;
> +	struct reset_control *reset;
>  };
>  
>  static inline struct bcm2835_rng_priv *to_rng_priv(struct hwrng *rng)
> @@ -92,6 +94,10 @@ static int bcm2835_rng_init(struct hwrng *rng)
>  	if (ret)
>  		return ret;
>  
> +	ret = reset_control_reset(priv->reset);
> +	if (ret)
> +		return ret;
> +
>  	if (priv->mask_interrupts) {
>  		/* mask the interrupt */
>  		val = rng_readl(priv, RNG_INT_MASK);
> @@ -156,6 +162,10 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
>  	if (IS_ERR(priv->clk))
>  		return PTR_ERR(priv->clk);
>  
> +	priv->reset = devm_reset_control_get_optional_exclusive(dev, NULL);
> +	if (IS_ERR(priv->reset))
> +		return PTR_ERR(priv->reset);
> +
>  	priv->rng.name = pdev->name;
>  	priv->rng.init = bcm2835_rng_init;
>  	priv->rng.read = bcm2835_rng_read;

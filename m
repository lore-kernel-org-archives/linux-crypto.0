Return-Path: <SRS0=iOo2=ZK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5EA3C432C0
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 15:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C790820885
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 15:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfKRPuv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Nov 2019 10:50:51 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54691 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbfKRPuv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Nov 2019 10:50:51 -0500
Received: from kresse.hi.pengutronix.de ([2001:67c:670:100:1d::2a])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <l.stach@pengutronix.de>)
        id 1iWjIg-0003J5-Ix; Mon, 18 Nov 2019 16:50:50 +0100
Message-ID: <19429ab6840292cc9b3003face918a2bff4f8b55.camel@pengutronix.de>
Subject: Re: [PATCH v2 5/6] crypto: caam - replace DRNG with TRNG for use
 with hw_random
From:   Lucas Stach <l.stach@pengutronix.de>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        linux-crypto@vger.kernel.org
Cc:     Chris Healy <cphealy@gmail.com>,
        Horia =?UTF-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Date:   Mon, 18 Nov 2019 16:50:49 +0100
In-Reply-To: <20191118153843.28136-6-andrew.smirnov@gmail.com>
References: <20191118153843.28136-1-andrew.smirnov@gmail.com>
         <20191118153843.28136-6-andrew.smirnov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::2a
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mo, 2019-11-18 at 07:38 -0800, Andrey Smirnov wrote:
> In order to give CAAM-generated random data highest quarlity
> raiting (999), replace current code that uses DRNG with code that
> fetches data straight out of TRNG used to seed aforementioned DRNG.
> 
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Cc: Chris Healy <cphealy@gmail.com>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Cc: Horia Geantă <horia.geanta@nxp.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
> Cc: linux-imx@nxp.com
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
[...]
> diff --git a/drivers/crypto/caam/trng.c b/drivers/crypto/caam/trng.c
> new file mode 100644
> index 000000000000..ab2af786543e
> --- /dev/null
> +++ b/drivers/crypto/caam/trng.c
> @@ -0,0 +1,85 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * hw_random interface for TRNG generator in CAAM RNG block
> + *
> + * Copyright 2019 Zoidac Inflight Innovations
                     ^ Zodiac

> + *
> + */
> +
> +#include <linux/hw_random.h>
> +
> +#include "compat.h"
> +#include "regs.h"
> +#include "intern.h"
> +
> +struct caam_trng_ctx {
> +	struct rng4tst __iomem *r4tst;
> +	struct hwrng rng;
> +};
> +
> +static bool caam_trng_busy(struct caam_trng_ctx *ctx)
> +{
> +	return !(rd_reg32(&ctx->r4tst->rtmctl) & RTMCTL_ENT_VAL);
> +}
> +
> +static int caam_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
> +{
> +	struct caam_trng_ctx *ctx = (void *)rng->priv;
> +	u32 rtent[ARRAY_SIZE(ctx->r4tst->rtent)];
> +	size_t residue = max;
> +
> +	clrsetbits_32(&ctx->r4tst->rtmctl, 0, RTMCTL_ACC);
> +
> +	do {
> +		const size_t chunk = min(residue, sizeof(rtent));
> +		unsigned int i;
> +
> +		while (caam_trng_busy(ctx)) {

The CAAM needs quite a bit of time to gather the 384bits of raw
entropy, in my testing it was almost 60ms. A busy loop (even with a
cpu_relax) for such an extended amount of time is probably not
appropriate, better sleep for some time here.

Also in the !wait case we are almost guaranteed to leave this function
without any entropy gathered. Maybe we should just bail out on !wait
without even trying to enable the TRNG access?

Regards,
Lucas

> +			if (wait)
> +				cpu_relax();
> +			else
> +				goto out;
> +		}
> +
> +		for (i = 0; i < DIV_ROUND_UP(chunk, sizeof(u32)); i++)
> +			rtent[i] = rd_reg32(&ctx->r4tst->rtent[i]);
> +
> +		memcpy(data, rtent, chunk);
> +
> +		residue -= chunk;
> +		data    += chunk;
> +	} while (residue);
> +
> +out:
> +	clrsetbits_32(&ctx->r4tst->rtmctl, RTMCTL_ACC, 0);
> +	return max - residue;
> +}
> +
> +int caam_trng_register(struct device *ctrldev)
> +{
> +	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
> +
> +	if (caam_has_rng(priv)) {
> +		struct caam_trng_ctx *ctx;
> +		int err;
> +
> +		ctx = devm_kzalloc(ctrldev, sizeof(*ctx), GFP_KERNEL);
> +		if (!ctx)
> +			return -ENOMEM;
> +
> +		ctx->r4tst = &priv->ctrl->r4tst[0];
> +
> +		ctx->rng.name = "trng-caam";
> +		ctx->rng.read = caam_trng_read;
> +		ctx->rng.priv = (unsigned long)ctx;
> +		ctx->rng.quality = 999;
> +
> +		dev_info(ctrldev, "registering %s\n", ctx->rng.name);
> +
> +		err = devm_hwrng_register(ctrldev, &ctx->rng);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}


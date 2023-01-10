Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC54C46467
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 07:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjAJHlT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Jan 2023 02:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjAJHlS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2023 02:41:18 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E3D17595;
        Mon,  9 Jan 2023 23:41:16 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pF9FZ-00FwmE-1Y; Tue, 10 Jan 2023 15:40:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Jan 2023 15:40:49 +0800
Date:   Tue, 10 Jan 2023 15:40:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v3 2/3] hwrng: starfive - Add TRNG driver for StarFive SoC
Message-ID: <Y70WgbySlio6cjew@gondor.apana.org.au>
References: <20230109165249.110279-1-jiajie.ho@starfivetech.com>
 <20230109165249.110279-3-jiajie.ho@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109165249.110279-3-jiajie.ho@starfivetech.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 10, 2023 at 12:52:48AM +0800, Jia Jie Ho wrote:
>
> +static irqreturn_t starfive_trng_irq(int irq, void *priv)
> +{
> +	u32 status;
> +	struct starfive_trng *trng = (struct starfive_trng *)priv;
> +
> +	status = readl(trng->base + STARFIVE_ISTAT);
> +	if (status & STARFIVE_ISTAT_RAND_RDY) {
> +		writel(STARFIVE_ISTAT_RAND_RDY, trng->base + STARFIVE_ISTAT);
> +		complete(&trng->random_done);
> +	}
> +
> +	if (status & STARFIVE_ISTAT_SEED_DONE) {
> +		writel(STARFIVE_ISTAT_SEED_DONE, trng->base + STARFIVE_ISTAT);
> +		complete(&trng->reseed_done);
> +	}
> +
> +	if (status & STARFIVE_ISTAT_LFSR_LOCKUP) {
> +		writel(STARFIVE_ISTAT_LFSR_LOCKUP, trng->base + STARFIVE_ISTAT);
> +		/* SEU occurred, reseeding required*/
> +		writel(STARFIVE_CTRL_EXEC_RANDRESEED, trng->base + STARFIVE_CTRL);

This could occur at the same time as a GENE_RANDNUM write so perhaps
you should add some locking?

> +	ret = devm_request_irq(&pdev->dev, irq, starfive_trng_irq, 0, pdev->name,
> +			       (void *)trng);
> +	if (ret)
> +		return dev_err_probe(&pdev->dev, irq,
> +				     "Failed to register interrupt handler\n");

...

> +	init_completion(&trng->random_done);
> +	init_completion(&trng->reseed_done);

These completion initialisations should be moved above the IRQ
registration because you should always be prepared to get spurious
interrupts.

Otherwise the patch looks good.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

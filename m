Return-Path: <SRS0=JhmS=XC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A425CC43331
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 08:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 249C3218AE
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 08:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567844401;
	bh=A6moeyz6Y4nkJpu3Bhn6KCPmNBZrCR62uuuIUrz+jLg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=d9v2yqxCS4h1e4VYyDewlriMA8NsFwD39RoASD/RlicxwcnSFwchWTEStrXHi4WZ5
	 3f9KZ5V3A8FhmfKKcEoF+LqDoom6+deiSenXrMIOKaN0H0om5bt9beN9rEqsGnEfsv
	 E9btqdyhkI9U82gskEHpZJJFXz6FNhu0ln8B6cGU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404968AbfIGIT7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Sep 2019 04:19:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404960AbfIGIT7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Sep 2019 04:19:59 -0400
Received: from localhost (unknown [212.213.198.112])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EB13208C3;
        Sat,  7 Sep 2019 08:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567844398;
        bh=A6moeyz6Y4nkJpu3Bhn6KCPmNBZrCR62uuuIUrz+jLg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qi5gpsRrvbn2wiknxgAHnFZw6rUl2H1OQoeYVnWpyE0m7//MzOduOX24OFFIpiGsC
         sURuN9CstuNbxqF53zt2BcS1HckiJ/DBl1t1shuZSPkKTW+ZJxVUl+xpclgVCb3SWC
         qADKNfPmHtINPkeZmf4DmB2R6aN9svHwGGDPeFw8=
Date:   Sat, 7 Sep 2019 11:19:51 +0300
From:   Maxime Ripard <mripard@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux@armlinux.org.uk, mark.rutland@arm.com, robh+dt@kernel.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 2/9] crypto: Add Allwinner sun8i-ce Crypto Engine
Message-ID: <20190907081951.v2huvhm44jfprfop@flea>
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
 <20190906184551.17858-3-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906184551.17858-3-clabbe.montjoie@gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I can't really comment on the crypto side, so my review is going to be
pretty boring.

On Fri, Sep 06, 2019 at 08:45:44PM +0200, Corentin Labbe wrote:
> +static const struct ce_variant ce_h3_variant = {
> +	.alg_cipher = { CE_ID_NOTSUPP, CE_ALG_AES, CE_ALG_DES, CE_ALG_3DES,
> +		CE_ID_NOTSUPP,
> +	},

As far as I can see, it's always the same value, so I'm not sure why
it's a parameter.

> +	.op_mode = { CE_ID_NOTSUPP, CE_OP_ECB, CE_OP_CBC
> +	},

Ditto

> +	.intreg = CE_ISR,

Ditto

> +	.maxflow = 4,

Ditto

> +	.ce_clks = {
> +		{ "ahb", 200000000 },

This is the default IIRC, and the clock driver will ignore any clock
rate change on it anyway, so the clock rate is pretty much useless
there.

> +		{ "mod", 48000000 },

48MHz seems pretty slow, especially compared to the other rates you
have listed there. Is that on purpose?

Also, I'm not sure what is the point of having the clocks names be
parameters there as well. It's constant across all the compatibles,
the only thing that isn't is the number of clocks and the module clock
rate. It's what you should have in there.

> +		}
> +};
> +
> +static const struct ce_variant ce_h5_variant = {
> +	.alg_cipher = { CE_ID_NOTSUPP, CE_ALG_AES, CE_ALG_DES, CE_ALG_3DES,
> +		CE_ID_NOTSUPP,
> +	},
> +	.op_mode = { CE_ID_NOTSUPP, CE_OP_ECB, CE_OP_CBC
> +	},
> +	.intreg = CE_ISR,
> +	.maxflow = 4,
> +	.ce_clks = {
> +		{ "ahb", 200000000 },
> +		{ "mod", 300000000 },
> +		}
> +};
> +
> +static const struct ce_variant ce_h6_variant = {
> +	.alg_cipher = { CE_ID_NOTSUPP, CE_ALG_AES, CE_ALG_DES, CE_ALG_3DES,
> +		CE_ALG_RAES,
> +	},
> +	.op_mode = { CE_ID_NOTSUPP, CE_OP_ECB, CE_OP_CBC
> +	},
> +	.model = CE_v2,

Can't that be derived from the version register and / or the
compatible? This seems to be redundant with each.

> +	.intreg = CE_ISR,
> +	.maxflow = 4,
> +	.ce_clks = {
> +		{ "ahb", 200000000 },
> +		{ "mod", 300000000 },
> +		{ "mbus", 400000000 },

That rate is going to be ignored as well.

> +		}
> +};
> +
> +static const struct ce_variant ce_a64_variant = {
> +	.alg_cipher = { CE_ID_NOTSUPP, CE_ALG_AES, CE_ALG_DES, CE_ALG_3DES,
> +		CE_ID_NOTSUPP,
> +	},
> +	.op_mode = { CE_ID_NOTSUPP, CE_OP_ECB, CE_OP_CBC
> +	},
> +	.intreg = CE_ISR,
> +	.maxflow = 4,
> +	.ce_clks = {
> +		{ "ahb", 200000000 },
> +		{ "mod", 300000000 },
> +		}
> +};

You should order your variants by alphabetical order.

> +static const struct ce_variant ce_r40_variant = {
> +	.alg_cipher = { CE_ID_NOTSUPP, CE_ALG_AES, CE_ALG_DES, CE_ALG_3DES,
> +		CE_ID_NOTSUPP,
> +	},
> +	.op_mode = { CE_ID_NOTSUPP, CE_OP_ECB, CE_OP_CBC
> +	},
> +	.intreg = CE_ISR,
> +	.maxflow = 4,
> +	.ce_clks = {
> +		{ "ahb", 200000000 },
> +		{ "mod", 300000000 },
> +		}
> +};
> +

...

> +int sun8i_ce_get_engine_number(struct sun8i_ce_dev *ce)
> +{
> +	return atomic_inc_return(&ce->flow) % ce->variant->maxflow;
> +}

I'm not sure what this is supposed to be doing, but that mod there
seems pretty dangerous.

...

> +static int sun8i_ce_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	u32 v;
> +	int err, i, ce_method, id, irq;
> +	unsigned long cr;
> +	struct sun8i_ce_dev *ce;
> +
> +	if (!pdev->dev.of_node)
> +		return -ENODEV;

This is pretty much guaranteed already

> +	ce = devm_kzalloc(&pdev->dev, sizeof(*ce), GFP_KERNEL);
> +	if (!ce)
> +		return -ENOMEM;
> +
> +	ce->variant = of_device_get_match_data(&pdev->dev);
> +	if (!ce->variant) {
> +		dev_err(&pdev->dev, "Missing Crypto Engine variant\n");
> +		return -EINVAL;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	ce->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(ce->base)) {
> +		err = PTR_ERR(ce->base);
> +		dev_err(&pdev->dev, "Cannot request MMIO err=%d\n", err);
> +		return err;

ioremap_resource already prints an error message on failure, so this
is redundant.

> +	}
> +
> +	for (i = 0; i < CE_MAX_CLOCKS; i++) {
> +		if (!ce->variant->ce_clks[i].name)
> +			continue;
> +		dev_info(&pdev->dev, "Get %s clock\n", ce->variant->ce_clks[i].name);

There's no reason to print this at the info level

> +		ce->ceclks[i] = devm_clk_get(&pdev->dev, ce->variant->ce_clks[i].name);
> +		if (IS_ERR(ce->ceclks[i])) {
> +			err = PTR_ERR(ce->ceclks[i]);
> +			dev_err(&pdev->dev, "Cannot get %s CE clock err=%d\n",
> +				ce->variant->ce_clks[i].name, err);
> +		}
> +		cr = clk_get_rate(ce->ceclks[i]);

So on error you'd call clk_get_rate on the clock still? That seems
pretty fragile, you should return there, it's a hard error.

> +		if (ce->variant->ce_clks[i].freq) {
> +			dev_info(&pdev->dev, "Set %s clock to %lu (%lu Mhz) from %lu (%lu Mhz)\n",
> +				 ce->variant->ce_clks[i].name,
> +				 ce->variant->ce_clks[i].freq,
> +				 ce->variant->ce_clks[i].freq / 1000000,
> +				 cr,
> +				 cr / 1000000);

Same remark about that message than the previous one.

> +			err = clk_set_rate(ce->ceclks[i], ce->variant->ce_clks[i].freq);
> +			if (err)
> +				dev_err(&pdev->dev, "Fail to set %s clk speed to %lu\n",
> +					ce->variant->ce_clks[i].name,
> +					ce->variant->ce_clks[i].freq);
> +		} else {
> +			dev_info(&pdev->dev, "%s run at %lu\n",
> +				 ce->variant->ce_clks[i].name, cr);

Ditto.

> +		}
> +		err = clk_prepare_enable(ce->ceclks[i]);

Do you really need this right now though?

> +		if (err) {
> +			dev_err(&pdev->dev, "Cannot prepare_enable %s\n",
> +				ce->variant->ce_clks[i].name);
> +			return err;
> +		}
> +	}
> +
> +	/* Get Non Secure IRQ */
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(ce->dev, "Cannot get NS IRQ\n");
> +		return irq;
> +	}
> +
> +	err = devm_request_irq(&pdev->dev, irq, ce_irq_handler, 0,
> +			       "sun8i-ce-ns", ce);
> +	if (err < 0) {
> +		dev_err(ce->dev, "Cannot request NS IRQ\n");
> +		return err;
> +	}
> +
> +	ce->reset = devm_reset_control_get_optional(&pdev->dev, "ahb");
> +	if (IS_ERR(ce->reset)) {
> +		if (PTR_ERR(ce->reset) == -EPROBE_DEFER)
> +			return PTR_ERR(ce->reset);
> +		dev_info(&pdev->dev, "No reset control found\n");

It's not optional though.

> +		ce->reset = NULL;
> +	}
> +
> +	err = reset_control_deassert(ce->reset);
> +	if (err) {
> +		dev_err(&pdev->dev, "Cannot deassert reset control\n");
> +		goto error_clk;
> +	}

Again, you don't really need this at this moment. Using runtime_pm
would make more sense.

> +	v = readl(ce->base + CE_CTR);
> +	v >>= 16;
> +	v &= 0x07;

This should be in a define

> +	dev_info(&pdev->dev, "CE_NS Die ID %x\n", v);

And if that really makes sense to print it, the error message should
be made less cryptic.

> +
> +	ce->dev = &pdev->dev;
> +	platform_set_drvdata(pdev, ce);
> +
> +	mutex_init(&ce->mlock);
> +
> +	ce->chanlist = devm_kcalloc(ce->dev, ce->variant->maxflow,
> +				    sizeof(struct sun8i_ce_flow), GFP_KERNEL);
> +	if (!ce->chanlist) {
> +		err = -ENOMEM;
> +		goto error_flow;
> +	}
> +
> +	for (i = 0; i < ce->variant->maxflow; i++) {
> +		init_completion(&ce->chanlist[i].complete);
> +		mutex_init(&ce->chanlist[i].lock);
> +
> +		ce->chanlist[i].engine = crypto_engine_alloc_init(ce->dev, true);
> +		if (!ce->chanlist[i].engine) {
> +			dev_err(ce->dev, "Cannot allocate engine\n");
> +			i--;
> +			goto error_engine;
> +		}
> +		err = crypto_engine_start(ce->chanlist[i].engine);
> +		if (err) {
> +			dev_err(ce->dev, "Cannot start engine\n");
> +			goto error_engine;
> +		}
> +		ce->chanlist[i].tl = dma_alloc_coherent(ce->dev,
> +							sizeof(struct ce_task),
> +							&ce->chanlist[i].t_phy,
> +							GFP_KERNEL);
> +		if (!ce->chanlist[i].tl) {
> +			dev_err(ce->dev, "Cannot get DMA memory for task %d\n",
> +				i);
> +			err = -ENOMEM;
> +			goto error_engine;
> +		}
> +	}

All this initialization should be done before calling
request_irq. You're using some of those fields in your handler.

> +
> +#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
> +	ce->dbgfs_dir = debugfs_create_dir("sun8i-ce", NULL);
> +	if (IS_ERR_OR_NULL(ce->dbgfs_dir)) {
> +		dev_err(ce->dev, "Fail to create debugfs dir");
> +		err = -ENOMEM;
> +		goto error_engine;
> +	}
> +	ce->dbgfs_stats = debugfs_create_file("stats", 0444,
> +					      ce->dbgfs_dir, ce,
> +					      &sun8i_ce_debugfs_fops);
> +	if (IS_ERR_OR_NULL(ce->dbgfs_stats)) {
> +		dev_err(ce->dev, "Fail to create debugfs stat");
> +		err = -ENOMEM;
> +		goto error_debugfs;
> +	}
> +#endif
> +	for (i = 0; i < ARRAY_SIZE(ce_algs); i++) {
> +		ce_algs[i].ce = ce;
> +		switch (ce_algs[i].type) {
> +		case CRYPTO_ALG_TYPE_SKCIPHER:
> +			id = ce_algs[i].ce_algo_id;
> +			ce_method = ce->variant->alg_cipher[id];
> +			if (ce_method == CE_ID_NOTSUPP) {
> +				dev_info(ce->dev,
> +					 "DEBUG: Algo of %s not supported\n",
> +					 ce_algs[i].alg.skcipher.base.cra_name);
> +				ce_algs[i].ce = NULL;
> +				break;
> +			}
> +			id = ce_algs[i].ce_blockmode;
> +			ce_method = ce->variant->op_mode[id];
> +			if (ce_method == CE_ID_NOTSUPP) {
> +				dev_info(ce->dev, "DEBUG: Blockmode of %s not supported\n",
> +					 ce_algs[i].alg.skcipher.base.cra_name);
> +				ce_algs[i].ce = NULL;
> +				break;
> +			}
> +			dev_info(ce->dev, "DEBUG: Register %s\n",
> +				 ce_algs[i].alg.skcipher.base.cra_name);
> +			err = crypto_register_skcipher(&ce_algs[i].alg.skcipher);
> +			if (err) {
> +				dev_err(ce->dev, "Fail to register %s\n",
> +					ce_algs[i].alg.skcipher.base.cra_name);
> +				ce_algs[i].ce = NULL;
> +				goto error_alg;
> +			}
> +			break;
> +		default:
> +			dev_err(ce->dev, "ERROR: tryed to register an unknown algo\n");
> +		}
> +	}
> +
> +	return 0;
> +error_alg:
> +	i--;
> +	for (; i >= 0; i--) {
> +		switch (ce_algs[i].type) {
> +		case CRYPTO_ALG_TYPE_SKCIPHER:
> +			if (ce_algs[i].ce)
> +				crypto_unregister_skcipher(&ce_algs[i].alg.skcipher);
> +			break;
> +		}
> +	}
> +#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
> +error_debugfs:
> +	debugfs_remove_recursive(ce->dbgfs_dir);
> +#endif
> +	i = ce->variant->maxflow;
> +error_engine:
> +	while (i >= 0) {
> +		crypto_engine_exit(ce->chanlist[i].engine);
> +		if (ce->chanlist[i].tl)
> +			dma_free_coherent(ce->dev, sizeof(struct ce_task),
> +					  ce->chanlist[i].tl,
> +					  ce->chanlist[i].t_phy);
> +		i--;
> +	}
> +error_flow:
> +	reset_control_assert(ce->reset);
> +error_clk:
> +	for (i = 0; i < CE_MAX_CLOCKS; i++)
> +		clk_disable_unprepare(ce->ceclks[i]);
> +	return err;
> +}

So that function takes around 200-250 LoC, this is definitely too
much and should be split into multiple functions.

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

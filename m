Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11654C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 17:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0E5B222C0
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 17:52:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SmxHhPti"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388554AbfJDRw0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 13:52:26 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36657 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388513AbfJDRw0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 13:52:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id y19so8254894wrd.3;
        Fri, 04 Oct 2019 10:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sFYbP+lwubqARXBpAaF4zcAm2S+7R8TyH0tAYLHpuSw=;
        b=SmxHhPtiS4HE+frxFMiA5OGhOlwdwsxbR3iaBCD2kV6eT9DtYjlFHI8Fi5D6clbRwh
         Nxh1rKkKxEruG3/W0r0y879a64kVB8lNpcfdt8BI6FT26/dmmvz4ufqdpX6vAqNtGGu7
         LrOVIYHjz/dUiik26uG1DX1uvj4RtRSO0G7DljiKkIO9FmGSxNg7GjhRpWixtgVPvEB8
         Z4gy9XNWnT83rVMNFxFplTis5Roe/e+4hn+nkfeie/7AY6W/7zlPuqRMjiVJ1/j4JHgW
         woYqWZk+VtzsVXuB8m82bKW7R2n8T1A0dGRkIR1p13bYn7Prt5sis7E4sfx/QQdSTbHY
         AUNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sFYbP+lwubqARXBpAaF4zcAm2S+7R8TyH0tAYLHpuSw=;
        b=jsSEcfFLtaX0UGWmsthp0pQfaQfbD4r/Aki/8mSLX9YDXzfM4PvDzbRCUoA/OQZa6J
         A7Krw4599RPDOCtliVUvdZV49Y8ZaSsavrFlgbZq+OHMWw7KbeDt7DB14m5rCa4zI7H6
         NgW4t/38flBLt/yDywchsXuCDHa/cO2IMpPAba1jtdHt/xxyogCnTfMy5V5Wil3Kvokx
         ou4S9OxYeKlMJMEnZ/hd0gIb/hbq7az70cvPPsVhELIJ7uHaDHvT9O3Z4YPmx9vUjW7O
         cVJtBOizMbH4WQH2f3KmIA9YnAPR0hgF0eR7PYbA+8UhLk5fQSuXaqH67d1Fzu10MPXc
         16jQ==
X-Gm-Message-State: APjAAAXx/A4gEgaWgJFh+6IONAV9a5pWZtFmHm5lRW1CHU8vqulnuhnE
        nNwwcqv9KBNladTzsD2NKQs=
X-Google-Smtp-Source: APXvYqxKktEBgCwY1UMUOGZ6XIxTAYM3I6bm5m3tonPbhiuAyeIqRpA6wiGOA/Vmhw7etSBN48lcaA==
X-Received: by 2002:adf:c7cf:: with SMTP id y15mr12982295wrg.54.1570211543488;
        Fri, 04 Oct 2019 10:52:23 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 59sm9181066wrc.23.2019.10.04.10.52.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 10:52:22 -0700 (PDT)
Date:   Fri, 4 Oct 2019 19:52:18 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Maxime Ripard <mripard@kernel.org>
Cc:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, robh+dt@kernel.org, wens@csie.org,
        will@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 02/11] crypto: Add Allwinner sun8i-ce Crypto Engine
Message-ID: <20191004175218.GA11208@Red>
References: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
 <20191001184141.27956-3-clabbe.montjoie@gmail.com>
 <20191002103506.zdoyhhzmroa6smwl@gilmour>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002103506.zdoyhhzmroa6smwl@gilmour>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 02, 2019 at 12:35:06PM +0200, Maxime Ripard wrote:
> Hi,
> 
> On Tue, Oct 01, 2019 at 08:41:32PM +0200, Corentin Labbe wrote:
> > +	/* CTS and recent CE (H6) need length in bytes, in word otherwise */
> > +	if (ce->variant->model == CE_v2)
> > +		cet->t_dlen = areq->cryptlen;
> 
> It's entirely redundant withe the compatible.
> 
> How about using something like has_t_dlen or whatever name you find
> best in the variant structure?
> 

Hello

I will fix that, I started with has_t_dlen_in_bytes

> > +static int sun8i_ce_probe(struct platform_device *pdev)
> > +{
> > +	struct resource *res;
> > +	u32 v;
> > +	int err, i, ce_method, id, irq;
> > +	unsigned long cr;
> > +	struct sun8i_ce_dev *ce;
> > +
> > +	ce = devm_kzalloc(&pdev->dev, sizeof(*ce), GFP_KERNEL);
> > +	if (!ce)
> > +		return -ENOMEM;
> > +
> > +	ce->dev = &pdev->dev;
> > +	platform_set_drvdata(pdev, ce);
> > +
> > +	ce->variant = of_device_get_match_data(&pdev->dev);
> > +	if (!ce->variant) {
> > +		dev_err(&pdev->dev, "Missing Crypto Engine variant\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	ce->base = devm_ioremap_resource(&pdev->dev, res);
> > +	if (IS_ERR(ce->base))
> > +		return PTR_ERR(ce->base);
> > +
> > +	for (i = 0; i < CE_MAX_CLOCKS; i++) {
> > +		if (!ce->variant->ce_clks[i].name)
> > +			continue;
> > +		ce->ceclks[i] = devm_clk_get(&pdev->dev, ce->variant->ce_clks[i].name);
> > +		if (IS_ERR(ce->ceclks[i])) {
> > +			err = PTR_ERR(ce->ceclks[i]);
> > +			dev_err(&pdev->dev, "Cannot get %s CE clock err=%d\n",
> > +				ce->variant->ce_clks[i].name, err);
> > +			return err;
> > +		}
> > +		cr = clk_get_rate(ce->ceclks[i]);
> > +		if (!cr)
> > +			return -EINVAL;
> > +		if (ce->variant->ce_clks[i].freq > 0 &&
> > +		    cr != ce->variant->ce_clks[i].freq) {
> > +			dev_info(&pdev->dev, "Set %s clock to %lu (%lu Mhz) from %lu (%lu Mhz)\n",
> > +				 ce->variant->ce_clks[i].name,
> > +				 ce->variant->ce_clks[i].freq,
> > +				 ce->variant->ce_clks[i].freq / 1000000,
> > +				 cr, cr / 1000000);
> > +			err = clk_set_rate(ce->ceclks[i], ce->variant->ce_clks[i].freq);
> > +			if (err)
> > +				dev_err(&pdev->dev, "Fail to set %s clk speed to %lu hz\n",
> > +					ce->variant->ce_clks[i].name,
> > +					ce->variant->ce_clks[i].freq);
> > +		}
> > +		if (ce->variant->ce_clks[i].max_freq > 0 &&
> > +		    cr > ce->variant->ce_clks[i].max_freq)
> > +			dev_warn(&pdev->dev, "Frequency for %s (%lu hz) is higher than datasheet's recommandation (%lu hz)",
> > +				 ce->variant->ce_clks[i].name, cr,
> > +				 ce->variant->ce_clks[i].max_freq);
> > +	}
> > +
> > +	/* Get Non Secure IRQ */
> > +	irq = platform_get_irq(pdev, 0);
> > +	if (irq < 0) {
> > +		dev_err(ce->dev, "Cannot get CryptoEngine Non-secure IRQ\n");
> > +		return irq;
> > +	}
> > +
> > +	ce->reset = devm_reset_control_get_optional(&pdev->dev, "bus");
> > +	if (IS_ERR(ce->reset)) {
> > +		if (PTR_ERR(ce->reset) == -EPROBE_DEFER)
> > +			return PTR_ERR(ce->reset);
> > +		dev_err(&pdev->dev, "No reset control found\n");
> > +		return PTR_ERR(ce->reset);
> > +	}
> > +
> > +	mutex_init(&ce->mlock);
> > +
> > +	err = allocate_chanlist(ce);
> > +	if (err)
> > +		return err;
> > +
> > +	err = sun8i_ce_pm_init(ce);
> > +	if (err)
> > +		goto error_pm;
> > +
> > +	err = devm_request_irq(&pdev->dev, irq, ce_irq_handler, 0,
> > +			       "sun8i-ce-ns", ce);
> > +	if (err) {
> > +		dev_err(ce->dev, "Cannot request CryptoEngine Non-secure IRQ (err=%d)\n", err);
> > +		goto error_irq;
> > +	}
> > +
> > +	for (i = 0; i < ARRAY_SIZE(ce_algs); i++) {
> > +		ce_algs[i].ce = ce;
> > +		switch (ce_algs[i].type) {
> > +		case CRYPTO_ALG_TYPE_SKCIPHER:
> > +			id = ce_algs[i].ce_algo_id;
> > +			ce_method = ce->variant->alg_cipher[id];
> > +			if (ce_method == CE_ID_NOTSUPP) {
> > +				dev_info(ce->dev,
> > +					 "DEBUG: Algo of %s not supported\n",
> > +					 ce_algs[i].alg.skcipher.base.cra_name);
> > +				ce_algs[i].ce = NULL;
> > +				break;
> > +			}
> > +			id = ce_algs[i].ce_blockmode;
> > +			ce_method = ce->variant->op_mode[id];
> > +			if (ce_method == CE_ID_NOTSUPP) {
> > +				dev_info(ce->dev, "DEBUG: Blockmode of %s not supported\n",
> > +					 ce_algs[i].alg.skcipher.base.cra_name);
> > +				ce_algs[i].ce = NULL;
> > +				break;
> > +			}
> > +			dev_info(ce->dev, "DEBUG: Register %s\n",
> > +				 ce_algs[i].alg.skcipher.base.cra_name);
> > +			err = crypto_register_skcipher(&ce_algs[i].alg.skcipher);
> > +			if (err) {
> > +				dev_err(ce->dev, "Fail to register %s\n",
> > +					ce_algs[i].alg.skcipher.base.cra_name);
> > +				ce_algs[i].ce = NULL;
> > +				goto error_alg;
> > +			}
> > +			break;
> > +		default:
> > +			ce_algs[i].ce = NULL;
> > +			dev_err(ce->dev, "ERROR: tryed to register an unknown algo\n");
> > +		}
> > +	}
> > +
> > +	err = pm_runtime_get_sync(ce->dev);
> > +	if (err < 0)
> > +		goto error_alg;
> > +
> > +	v = readl(ce->base + CE_CTR);
> > +	v >>= CE_DIE_ID_SHIFT;
> > +	v &= CE_DIE_ID_MASK;
> > +	dev_info(&pdev->dev, "CryptoEngine Die ID %x\n", v);
> > +
> > +	pm_runtime_put_sync(ce->dev);
> > +
> > +#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
> > +	/* Ignore error of debugfs */
> > +	ce->dbgfs_dir = debugfs_create_dir("sun8i-ce", NULL);
> > +	ce->dbgfs_stats = debugfs_create_file("stats", 0444,
> > +					      ce->dbgfs_dir, ce,
> > +					      &sun8i_ce_debugfs_fops);
> > +#endif
> > +	return 0;
> > +error_alg:
> > +	unregister_algs(ce);
> > +	i = MAXFLOW;
> > +error_irq:
> > +	sun8i_ce_pm_exit(ce);
> > +error_pm:
> > +	free_chanlist(ce, i);
> > +	return err;
> > +}
> 
> It's still pretty long. Can you move the clocks, algo initialisation
> (and debugfs maybe?) to a function of their own?
> 

It is much cleaner with clock and algo init in functions, thanks!

Regards

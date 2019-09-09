Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC18FC4740C
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 13:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74AC921920
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 13:19:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KehY9xnt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbfIINTN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 09:19:13 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33594 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728882AbfIINTN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 09:19:13 -0400
Received: by mail-wm1-f68.google.com with SMTP id r17so23742wme.0;
        Mon, 09 Sep 2019 06:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TXDC+z0IyI2JFm3KYb5ZtvylBoF5a96Rw6KfLJrAyP4=;
        b=KehY9xntRXwcJqP/Qmh+gxSGQi7Bn1NkHIqhNorXOSTakScu5c2VQKjAEzf2TJJOMM
         4QlbZS6/65MTryXd9be7eYvYhrPIIdNsWp0ol+0ajrj9dk9lzbzIZXhx61b8D+YA8wtF
         +AiM41c65dLtMI+zuaa4g480Qsh4+Sn6VBJqz466je3kYhmmOVlJpqDXB6UOy76cvfx9
         7tB/hV7GBEEO7D/77NTFSGAKJIn37y8jO/2lhXuSxObrkBmA1QNSEDOjW2sx9mw1DffZ
         jJlEBRVZVACCzjT+/UDM8OUGNJuPK/jwSZTYV0P62ScyGaHey8+7OyB/wbickPCHLHp1
         OnNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TXDC+z0IyI2JFm3KYb5ZtvylBoF5a96Rw6KfLJrAyP4=;
        b=cUSeUMqWd52ewI3GEEGDbTBqHTdHmRueElmSmwPpBf2Ly3Lm4YGKnIG7sgbVnTmG1b
         coeQzRlLSPM9wDpwrNFF4c4+rvUGGZkgTlP6z6vKsN2ZZfP9FzSHrFjkeuigoH0Zlg72
         g1ePxUh2/5EsN7JzI8nJ3Bgf4web8Z27vauXPEVhAqJwAUep9kuWFOx8fH2BDyk0zjpm
         hZEEsL2Iz/BDzgU6RwcNVXttteM5KrQBlre0QycZ0x9laPPcjsVvHXTklPNOhGPFZ2/b
         M1LQbmucs0kGcC4eaHEQ/L9ST/JrnAeba6w0J/z242HAYwVsYausQUY67DRWMhp5BBDj
         5B3g==
X-Gm-Message-State: APjAAAUU+Fgl1mORra4b9ue6aQOnSUa8SAiLwKhsCX0kEgtQD485JFaT
        iVgRGqIxRmSm7d2u9EDKkp0GZdIa
X-Google-Smtp-Source: APXvYqxowR+NZIgG4EBvrXMOcbX0mYRDnV4oZ2c1kIoJTlybzYFFVU2XdxIh9yBZMsqWzqEQcCJstw==
X-Received: by 2002:a7b:c392:: with SMTP id s18mr20291152wmj.25.1568035149799;
        Mon, 09 Sep 2019 06:19:09 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id r1sm14193636wro.13.2019.09.09.06.19.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 06:19:08 -0700 (PDT)
Date:   Mon, 9 Sep 2019 15:19:06 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Maxime Ripard <mripard@kernel.org>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux@armlinux.org.uk, mark.rutland@arm.com, robh+dt@kernel.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 2/9] crypto: Add Allwinner sun8i-ce Crypto Engine
Message-ID: <20190909131906.GA12882@Red>
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
 <20190906184551.17858-3-clabbe.montjoie@gmail.com>
 <20190907081951.v2huvhm44jfprfop@flea>
 <20190907190408.GE2628@Red>
 <20190909113837.vrnqdfgzhsiymfpm@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909113837.vrnqdfgzhsiymfpm@flea>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 09, 2019 at 01:38:37PM +0200, Maxime Ripard wrote:
> On Sat, Sep 07, 2019 at 09:04:08PM +0200, Corentin Labbe wrote:
> > > Also, I'm not sure what is the point of having the clocks names be
> > > parameters there as well. It's constant across all the compatibles,
> > > the only thing that isn't is the number of clocks and the module clock
> > > rate. It's what you should have in there.
> >
> > Since the datasheet give some max frequency, I think I will add a
> > max_freq and add a check to verify if the clock is in the right
> > range
> 
> It's a bit pointless. What are you going to do if it's not correct?
> What are you trying to fix / report with this?

I thinked to print a warning.
If someone want to play with overclocking for example, the driver should said that probably some result could be invalid.

> 
> > > > +		}
> > > > +};
> > > > +
> > > > +static const struct ce_variant ce_h5_variant = {
> > > > +	.alg_cipher = { CE_ID_NOTSUPP, CE_ALG_AES, CE_ALG_DES, CE_ALG_3DES,
> > > > +		CE_ID_NOTSUPP,
> > > > +	},
> > > > +	.op_mode = { CE_ID_NOTSUPP, CE_OP_ECB, CE_OP_CBC
> > > > +	},
> > > > +	.intreg = CE_ISR,
> > > > +	.maxflow = 4,
> > > > +	.ce_clks = {
> > > > +		{ "ahb", 200000000 },
> > > > +		{ "mod", 300000000 },
> > > > +		}
> > > > +};
> > > > +
> > > > +static const struct ce_variant ce_h6_variant = {
> > > > +	.alg_cipher = { CE_ID_NOTSUPP, CE_ALG_AES, CE_ALG_DES, CE_ALG_3DES,
> > > > +		CE_ALG_RAES,
> > > > +	},
> > > > +	.op_mode = { CE_ID_NOTSUPP, CE_OP_ECB, CE_OP_CBC
> > > > +	},
> > > > +	.model = CE_v2,
> > >
> > > Can't that be derived from the version register and / or the
> > > compatible? This seems to be redundant with each.
> >
> > I could use the compatible, but I want to avoid a string comparison
> > on each request.
> 
> Well, this is specifically what this structure is for then, right? So
> instead of having the model, just add the information that you want
> there.
> 

ok, I will change to a "bool all_size_in_bytes"

> > > > +int sun8i_ce_get_engine_number(struct sun8i_ce_dev *ce)
> > > > +{
> > > > +	return atomic_inc_return(&ce->flow) % ce->variant->maxflow;
> > > > +}
> > >
> > > I'm not sure what this is supposed to be doing, but that mod there
> > > seems pretty dangerous.
> > >
> > > ...
> >
> > This mod do a round robin on each channel.
> > I dont see why it is dangerous.
> 
> Well, you're using the atomic API here which is most commonly used for
> refcounting, while you're using a mod.
> 
> Plus, while the increment is atomic, the modulo isn't, so you can end
> up in a case where you would be preempted between the
> atomic_inc_return and the mod, which is dangerous.
> 
> Again, I'm not sure what this function is doing (which is also a
> problem in itself). I guess you should just make it clearer what it
> does, and then we can discuss it properly.

Each request need to be assigned to a channel.
Each channel are identified by a number from 1 to 4.

So this function return the channel to use, 1 then 2 then 3 then 4 then 1...
Note that this is uncritical. If, due to anything, two request are assigned to the same channel, nothing will break.

> 
> > > > +			err = clk_set_rate(ce->ceclks[i], ce->variant->ce_clks[i].freq);
> > > > +			if (err)
> > > > +				dev_err(&pdev->dev, "Fail to set %s clk speed to %lu\n",
> > > > +					ce->variant->ce_clks[i].name,
> > > > +					ce->variant->ce_clks[i].freq);
> > > > +		} else {
> > > > +			dev_info(&pdev->dev, "%s run at %lu\n",
> > > > +				 ce->variant->ce_clks[i].name, cr);
> > >
> > > Ditto.
> > >
> > > > +		}
> > > > +		err = clk_prepare_enable(ce->ceclks[i]);
> > >
> > > Do you really need this right now though?
> >
> > Not sure to understand, why I shouldnt do it now ?
> > Does it is related to your pm_runtime remark below ?
> >
> > My feeling was to submit the driver without PM and convert it after.
> 
> runtime_pm would be pretty cheap to add though judging by what you're
> doing there.
> 

I will try to add runtime_pm

> > > > +		if (err) {
> > > > +			dev_err(&pdev->dev, "Cannot prepare_enable %s\n",
> > > > +				ce->variant->ce_clks[i].name);
> > > > +			return err;
> > > > +		}
> > > > +	}
> > > > +
> > > > +	/* Get Non Secure IRQ */
> > > > +	irq = platform_get_irq(pdev, 0);
> > > > +	if (irq < 0) {
> > > > +		dev_err(ce->dev, "Cannot get NS IRQ\n");
> > > > +		return irq;
> > > > +	}
> > > > +
> > > > +	err = devm_request_irq(&pdev->dev, irq, ce_irq_handler, 0,
> > > > +			       "sun8i-ce-ns", ce);
> > > > +	if (err < 0) {
> > > > +		dev_err(ce->dev, "Cannot request NS IRQ\n");
> > > > +		return err;
> > > > +	}
> > > > +
> > > > +	ce->reset = devm_reset_control_get_optional(&pdev->dev, "ahb");
> > > > +	if (IS_ERR(ce->reset)) {
> > > > +		if (PTR_ERR(ce->reset) == -EPROBE_DEFER)
> > > > +			return PTR_ERR(ce->reset);
> > > > +		dev_info(&pdev->dev, "No reset control found\n");
> > >
> > > It's not optional though.
> >
> > I dont understand why.
> 
> On all the SoCs, you need that reset line to be deasserted, otherwise
> the IP (and therefore the driver) will be non-functional. It's not an
> option to run without it.

Currently all the SoC have a reset, but nothing prevent a new SoC with CE without reset.
Anyway, I will made the reset mandatory for the moment.

> 
> > > > +		ce->reset = NULL;
> > > > +	}
> > > > +
> > > > +	err = reset_control_deassert(ce->reset);
> > > > +	if (err) {
> > > > +		dev_err(&pdev->dev, "Cannot deassert reset control\n");
> > > > +		goto error_clk;
> > > > +	}
> > >
> > > Again, you don't really need this at this moment. Using runtime_pm
> > > would make more sense.
> > >
> > > > +	v = readl(ce->base + CE_CTR);
> > > > +	v >>= 16;
> > > > +	v &= 0x07;
> > >
> > > This should be in a define
> > >
> >
> > Will fix.
> >
> > > > +	dev_info(&pdev->dev, "CE_NS Die ID %x\n", v);
> > >
> > > And if that really makes sense to print it, the error message should
> > > be made less cryptic.
> > >
> >
> > Will fix.
> >
> > > > +
> > > > +	ce->dev = &pdev->dev;
> > > > +	platform_set_drvdata(pdev, ce);
> > > > +
> > > > +	mutex_init(&ce->mlock);
> > > > +
> > > > +	ce->chanlist = devm_kcalloc(ce->dev, ce->variant->maxflow,
> > > > +				    sizeof(struct sun8i_ce_flow), GFP_KERNEL);
> > > > +	if (!ce->chanlist) {
> > > > +		err = -ENOMEM;
> > > > +		goto error_flow;
> > > > +	}
> > > > +
> > > > +	for (i = 0; i < ce->variant->maxflow; i++) {
> > > > +		init_completion(&ce->chanlist[i].complete);
> > > > +		mutex_init(&ce->chanlist[i].lock);
> > > > +
> > > > +		ce->chanlist[i].engine = crypto_engine_alloc_init(ce->dev, true);
> > > > +		if (!ce->chanlist[i].engine) {
> > > > +			dev_err(ce->dev, "Cannot allocate engine\n");
> > > > +			i--;
> > > > +			goto error_engine;
> > > > +		}
> > > > +		err = crypto_engine_start(ce->chanlist[i].engine);
> > > > +		if (err) {
> > > > +			dev_err(ce->dev, "Cannot start engine\n");
> > > > +			goto error_engine;
> > > > +		}
> > > > +		ce->chanlist[i].tl = dma_alloc_coherent(ce->dev,
> > > > +							sizeof(struct ce_task),
> > > > +							&ce->chanlist[i].t_phy,
> > > > +							GFP_KERNEL);
> > > > +		if (!ce->chanlist[i].tl) {
> > > > +			dev_err(ce->dev, "Cannot get DMA memory for task %d\n",
> > > > +				i);
> > > > +			err = -ENOMEM;
> > > > +			goto error_engine;
> > > > +		}
> > > > +	}
> > >
> > > All this initialization should be done before calling
> > > request_irq. You're using some of those fields in your handler.
> >
> > No interrupt could fire, since algorithms are still not registred.
> 
> That's not true. Spurious interrupts are a thing, the engine could
> have been left in a weird state by the bootloader / kexec / reboot
> with some pending interrupts, etc.
> 
> You have registered that handler already, you should expect it to be
> called at any point in time.
> 

Ok will fix.

Thanks for your review.

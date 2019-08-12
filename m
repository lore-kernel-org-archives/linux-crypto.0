Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4788AC31E40
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 19:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0423206C1
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 19:27:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o2QA/lHt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfHLT1w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 15:27:52 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34737 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfHLT1v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 15:27:51 -0400
Received: by mail-ot1-f67.google.com with SMTP id n5so163333113otk.1;
        Mon, 12 Aug 2019 12:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ILsSYtoFc2CKUlsvQby1NfpnXmUVs1DoYSPvAsEfls8=;
        b=o2QA/lHtWsZXoUWoPCY1fi2EbjP3gU2sfs7+RY7eESxVYX8lLeUmip9oXzJ7XGDJIR
         MR0abaxb3jMRolf3wgB78dNbWcvM0hnBgRq22Ta8W21hxFjeSgc6TpXFToll2I/kqPvd
         jghGveeNTsg30U1mIIgM4bo23kl3dE/Z1hrXuQRC3MPbjgCPIVe6hSCaLTXOfCmLJeWl
         PojFObeFGcz37hrOMnRu1e2xlwmCyyeuUJ2kaiLIxIPNuqhfrsdaJ5jcvogDB0GMOqwn
         sZC4TbnU8vDoEqfmxaFXkPrji8il2qEl0gGVkzlGC1uNCptGdCT9wegAPhltsU1T4ycC
         nToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ILsSYtoFc2CKUlsvQby1NfpnXmUVs1DoYSPvAsEfls8=;
        b=ZCHiW31uACdNKcpr92+17y556Yxj+1iIQtTByh5vKpHAH+IHd8IzMq5gCBoBE02DWg
         g75W3YDfj/1VjmX3nuxs1asJZ8MyzWuzSOi7TGksrxVqP1OZl6J24mQeTPs+nZcmGXjP
         +MAfG08rVHNmDxBgjVU3sDOcvW6lvq1nqmKkrVvKqoG2b7SpN6EDXBa8YmZQKCV2jNGv
         qqXgvcmyclw/SaLH4RF5Vgy1bev/AlR5y6U30mReGmwHJ2uZ3SDwqGhO67VmQmVPH3Li
         5xGqYLZmBcwpR0N+xwn95wKf5+h0LFlpENpb9qQBjQIKr8tt4Pzbwq/KdWxX0ZH2CuyC
         9r7A==
X-Gm-Message-State: APjAAAXFvZyvCGP9E6rR+8oSdh4MmBT55PFLavRiHOcrGauah82H/zrL
        ErXBVQ129brykx45CaYSLofDRia3/DoygztUid4=
X-Google-Smtp-Source: APXvYqyFv5k85LuUb92ftiZ5NcKrsW1BBLp8/X85YaDKrUsvOGGM29LDofD561J6Qe5XmNJQ26XFzrsVX+X/wKpwUOc=
X-Received: by 2002:a6b:4107:: with SMTP id n7mr11786212ioa.12.1565638070771;
 Mon, 12 Aug 2019 12:27:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
 <20190717152458.22337-13-andrew.smirnov@gmail.com> <VI1PR0402MB348580480F5EAF5F539B585A98DA0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB348580480F5EAF5F539B585A98DA0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 12 Aug 2019 12:27:38 -0700
Message-ID: <CAHQ1cqEiCkXP+-w9WUc33oW6vDhHza2Jq_kQsXjKZ+__T5g77g@mail.gmail.com>
Subject: Re: [PATCH v6 12/14] crypto: caam - force DMA address to 32-bit on
 64-bit i.MX SoCs
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 5, 2019 at 1:23 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 7/17/2019 6:25 PM, Andrey Smirnov wrote:
> > i.MX8 SoC still use 32-bit addresses in its CAAM implmentation, so
> i.MX8 SoC or i.MX8 mScale?
> Looking at the documentation, some i.MX8 parts (for e.g. QM and QXP)
> allow for 36-bit addresses.
>

mScale. Will update the message.

> > change all of the code to be able to handle that.
> >
> Shouldn't this case (32-bit CAAM and CONFIG_ARCH_DMA_ADDR_T_64BIT=y) work
> for any ARMv8 SoC, i.e. how is this i.MX-specific?
>

It's a generic change.

> > @@ -603,11 +603,13 @@ static int caam_probe(struct platform_device *pdev)
> >               ret = init_clocks(dev, ctrlpriv, imx_soc_match->data);
> >               if (ret)
> >                       return ret;
> > +
> > +             caam_ptr_sz = sizeof(u32);
> > +     } else {
> > +             caam_ptr_sz = sizeof(dma_addr_t);
> caam_ptr_sz should be deduced by reading MCFGR[PS] bit, i.e. decoupled
> from dma_addr_t.
>

MCFGR[PS] is not mentioned in i.MX8MQ SRM and MCFG_PS in CTPR_MS is
documented as set to "0" (seems to match in real HW as well). Doesn't
seem like a workable solution for i.MX8MQ. Is there something I am
missing?

> There is another configuration that should be considered
> (even though highly unlikely):
> caam_ptr_sz=1  - > 32-bit addresses for CAAM
> CONFIG_ARCH_DMA_ADDR_T_64BIT=n - 32-bit dma_addr_t
> so the logic has to be carefully evaluated.
>

I don't understand what you mean here. 32-bit CAAM + 32-bit dma_addr_t
should already be the case for i.MX6, etc. how is what you describe
different?

> > @@ -191,7 +191,8 @@ static inline u64 caam_dma64_to_cpu(u64 value)
> >
> >  static inline u64 cpu_to_caam_dma(u64 value)
> >  {
> > -     if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
> > +     if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) &&
> > +         !caam_imx)
> Related to my previous comment (i.MX-specific vs. SoC-generic),
> this should probably change to smth. like: caam_ptr_sz == sizeof(u64)
>

Makes sense, will do here and in other places.

Thanks,
Andrey Smirnov

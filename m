Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07757C3A5A7
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 12:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE52A22CED
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 12:10:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aWAM2/49"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfIDMKt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Sep 2019 08:10:49 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36122 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbfIDMKt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Sep 2019 08:10:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id y19so21000151wrd.3
        for <linux-crypto@vger.kernel.org>; Wed, 04 Sep 2019 05:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mJJcTnGDZBXZ8Ni0GuiTKJbKloYHirZ/pYSwY4GcC2A=;
        b=aWAM2/49d7ffyKv7EO7xuTQABGvH43O89L4hFV48XceBs2FySAwGzSF/0B4ovCljmV
         WrCkC1wxalkdO50J0khXCqQkDMIPHHQg2SCguuTIWMfv0yGgTGWX/kiN6of1Tbng4qXR
         Cp//CD/iMqYspPiMOOVPgTCtSlCFkfN/Lu1QuSgBTdg6+XOYGOTSMydEF3gV1a55lJ/O
         SvpwPd0fB/LAXOR1BGPST7D+D2I/o1XuJK/xw3XGTpCdnOG3nzBXgf+6oP8TahIc1KmG
         rUeHYv53TtuG5zNIjfHGkF/QCmvMDTxHQ13NmJ+6oLbE27f4stXs+IK9Bsx6wQAcA30x
         hKLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mJJcTnGDZBXZ8Ni0GuiTKJbKloYHirZ/pYSwY4GcC2A=;
        b=HUNTDXdTpPcqM0KsgH8A5ZsaFnMCSnLqMhkSbx8L15rR4J62yEFty5QjS70lfZ43OY
         I5/f4FkTp93JdnKSAFJO4k5z+wws4hp7lRxc9Y913vncZ2vjpz1SBMZkDGtE08XR4Bhz
         6WkaVCGiugmfvDCkaDWETi9mvebpimERJArRauQFxqjQU14VX2pHPTnNd+ex/MxrOU/K
         mmGehn9wJQDZNRKz9AyczXI+8cgs+IBYdCx36Ee7FRbxXKzkQ6pf0C9ja5aQ4mtL+Cdt
         HQzNtazABFeRLLB6zcwB/AQLYQo3rdj17uJ+ZH1DTMWOSqbKkx/rW+1HVBj/Y04eiSZa
         vTag==
X-Gm-Message-State: APjAAAUDVueasm0yqWhWMxNh2MqMmS6jYNdPAF5x4h3iq3ykpQFIAJYn
        1zsyw+twz7XsXsumqfLQCc7vdUsvn/CrJTpF3IsHtpqEOOptSw==
X-Google-Smtp-Source: APXvYqzRplwD9M8TpHvsm4pRUX3XKDyUQKQBWB+IdnkScjyOEFRMgT+goyayzIdeKzqLgMaJrM2zEFqVmSENexvwKkc=
X-Received: by 2002:a05:6000:128d:: with SMTP id f13mr49323600wrx.241.1567599046462;
 Wed, 04 Sep 2019 05:10:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190902141910.1080-1-yuehaibing@huawei.com> <20190903014518.20880-1-yuehaibing@huawei.com>
 <MN2PR20MB29732EEECB217DDDF822EDA5CAB80@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB29732EEECB217DDDF822EDA5CAB80@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 4 Sep 2019 05:10:34 -0700
Message-ID: <CAKv+Gu8PVYyA-mzjrhR6r6upMc=xzpAhsbkuKRtb8T2noo_2XQ@mail.gmail.com>
Subject: Re: [PATCH v2 -next] crypto: inside-secure - Fix build error without CONFIG_PCI
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pvanleeuwen@insidesecure.com" <pvanleeuwen@insidesecure.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 4 Sep 2019 at 04:57, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
>
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of
> > YueHaibing
> > Sent: Tuesday, September 3, 2019 3:45 AM
> > To: antoine.tenart@bootlin.com; herbert@gondor.apana.org.au; davem@davemloft.net;
> > pvanleeuwen@insidesecure.com
> > Cc: linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org; YueHaibing
> > <yuehaibing@huawei.com>
> > Subject: [PATCH v2 -next] crypto: inside-secure - Fix build error without CONFIG_PCI
> >
> > If CONFIG_PCI is not set, building fails:
> >
> > rivers/crypto/inside-secure/safexcel.c: In function safexcel_request_ring_irq:
> > drivers/crypto/inside-secure/safexcel.c:944:9: error: implicit declaration of function
> > pci_irq_vector;
> >  did you mean rcu_irq_enter? [-Werror=implicit-function-declaration]
> >    irq = pci_irq_vector(pci_pdev, irqid);
> >          ^~~~~~~~~~~~~~
> >
> > Use #ifdef block to guard this.
> >
> Actually, this is interesting. My *original* implementation was using
> straight #ifdefs, but then I got review feedback stating that I should not
> do that, as it's not compile testable, suggesting to use regular C if's
> instead. Then there was quite some back-and-forth on the actual
> implementation and I ended up with this.
>
> So now it turns out that doesn't work and I'm suggested to go full-circle
> back to straight #ifdef's? Or is there some other way to make this work?
> Because I don't know where to go from here ...
>


C conditionals are preferred over preprocessor conditional, but if the
conditional code refers to symbols that are not declared when the
Kconfig symbol is not defined, preprocessor conditionals are the only
option.

This is the reason we have so many empty static inline functions in
header files - it ensures that the symbols are declared even if the
only invocations are from dead code.


> > Fixes: 625f269a5a7a ("crypto: inside-secure - add support for PCI based FPGA development
> > board")
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > ---
> > v2: use 'ifdef' instead of 'IS_ENABLED'
> > ---
> >  drivers/crypto/inside-secure/safexcel.c | 13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-
> > secure/safexcel.c
> > index e12a2a3..5253900 100644
> > --- a/drivers/crypto/inside-secure/safexcel.c
> > +++ b/drivers/crypto/inside-secure/safexcel.c
> > @@ -937,7 +937,8 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
> >       int ret, irq;
> >       struct device *dev;
> >
> > -     if (IS_ENABLED(CONFIG_PCI) && is_pci_dev) {
> > +#ifdef CONFIG_PCI
> > +     if (is_pci_dev) {
> >               struct pci_dev *pci_pdev = pdev;
> >
> >               dev = &pci_pdev->dev;
> > @@ -947,7 +948,10 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
> >                               irqid, irq);
> >                       return irq;
> >               }
> > -     } else if (IS_ENABLED(CONFIG_OF)) {
> > +     } else
> > +#endif
> > +     {
> > +#ifdef CONFIG_OF
> >               struct platform_device *plf_pdev = pdev;
> >               char irq_name[6] = {0}; /* "ringX\0" */
> >
> > @@ -960,6 +964,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
> >                               irq_name, irq);
> >                       return irq;
> >               }
> > +#endif
> >       }
> >
> >       ret = devm_request_threaded_irq(dev, irq, handler,
> > @@ -1137,7 +1142,8 @@ static int safexcel_probe_generic(void *pdev,
> >
> >       safexcel_configure(priv);
> >
> > -     if (IS_ENABLED(CONFIG_PCI) && priv->version == EIP197_DEVBRD) {
> > +#ifdef CONFIG_PCI
> > +     if (priv->version == EIP197_DEVBRD) {
> >               /*
> >                * Request MSI vectors for global + 1 per ring -
> >                * or just 1 for older dev images
> > @@ -1153,6 +1159,7 @@ static int safexcel_probe_generic(void *pdev,
> >                       return ret;
> >               }
> >       }
> > +#endif
> >
> >       /* Register the ring IRQ handlers and configure the rings */
> >       priv->ring = devm_kcalloc(dev, priv->config.rings,
> > --
> > 2.7.4
> >
>
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> www.insidesecure.com

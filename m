Return-Path: <SRS0=EVKT=6F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF537C54FCC
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 13:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 941F6206F4
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 13:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgDUNeP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Apr 2020 09:34:15 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38680 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728422AbgDUNeO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Apr 2020 09:34:14 -0400
Received: by mail-ot1-f65.google.com with SMTP id g19so1070170otk.5;
        Tue, 21 Apr 2020 06:34:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lh5pVJZRcLVBFtKesabUO59pO9pTmaMQl3f9s4jugGY=;
        b=rMjeWykbnunU7DIQCZ+K054kvjWz4FsTtfu7x4d6fSoL108s8HCXry/A5kRmojSF6u
         Fflu5IEluoy6FLqDaNFIxBIRltUKoAsAPvpGtFiWUBzdmzmFPsR2/uah9y06wt7Gb4M/
         Cl1/mQGwjcw/x45fSM6m9QvzqVo6Pt3Ye6gIzYaL7arC7vU6uw9fQTifvqdjsnZrL7hc
         OgduFSXh6nYuLdFTbSadBVoATrMln9Jf3rxznvhXrIZlivMK/6gLZK5zQ7F8MnRlVTHr
         tG3DpLYjA9AyDuHSOfs3I1I+bSiJnDLx2mKm5o5ZXG5TJaBsmrBBDKF3LUlsVObGz2L9
         WoIw==
X-Gm-Message-State: AGi0PuZc9S3ZK3+CRuedtRJrIUCuR0JHE9w3zwOiKg+wm/EA/gQR9Zy5
        NOIFZs4m7elOm9FNwyajmA6IIKFHuEVY5kc42Wg=
X-Google-Smtp-Source: APiQypKjSLZvCUom9i5XEMJJRF+xev9IVN+sAhLGeyV7fqmrQYYuyDhWvpuOL/sM0BJlaEAL07MAxjJetD+5d4xBD78=
X-Received: by 2002:a9d:76c7:: with SMTP id p7mr13264034otl.145.1587476053078;
 Tue, 21 Apr 2020 06:34:13 -0700 (PDT)
MIME-Version: 1.0
References: <1585289423-18440-1-git-send-email-hadar.gat@arm.com>
 <1585289423-18440-3-git-send-email-hadar.gat@arm.com> <CAMuHMdV6Uce79MPs7jfJfX3WOqAMH22vf2V_=Ui0zLHYqsJ+Xg@mail.gmail.com>
 <DB6PR0802MB25338BD19DD2F7E662BB1065E9D50@DB6PR0802MB2533.eurprd08.prod.outlook.com>
In-Reply-To: <DB6PR0802MB25338BD19DD2F7E662BB1065E9D50@DB6PR0802MB2533.eurprd08.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 21 Apr 2020 15:34:01 +0200
Message-ID: <CAMuHMdWujabV8dr=EojXFBVD0TcUuZ2kCGjjo93u=PE-AmzVHA@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] hw_random: cctrng: introduce Arm CryptoCell driver
To:     Hadar Gat <Hadar.Gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <Ofir.Drang@arm.com>, nd <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Hadar,

On Tue, Apr 21, 2020 at 3:16 PM Hadar Gat <Hadar.Gat@arm.com> wrote:
> > -----Original Message-----
> > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > Sent: Monday, 20 April 2020 16:45
> >
> > On Fri, Mar 27, 2020 at 7:11 AM Hadar Gat <hadar.gat@arm.com> wrote:
> > > Introduce low level Arm CryptoCell TRNG HW support.
> > >
> > > Signed-off-by: Hadar Gat <hadar.gat@arm.com>
> >
> > Thanks for your patch!
> >
> > > --- /dev/null
> > > +++ b/drivers/char/hw_random/cctrng.c
> >
> > > +static int cctrng_probe(struct platform_device *pdev) {
> > > +       struct resource *req_mem_cc_regs = NULL;
> > > +       struct cctrng_drvdata *drvdata;
> > > +       struct device *dev = &pdev->dev;
> > > +       int rc = 0;
> > > +       u32 val;
> > > +       int irq;
> > > +
> > > +       drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
> > > +       if (!drvdata)
> > > +               return -ENOMEM;
> > > +
> > > +       drvdata->rng.name = devm_kstrdup(dev, dev_name(dev),
> > GFP_KERNEL);
> > > +       if (!drvdata->rng.name)
> > > +               return -ENOMEM;
> > > +
> > > +       drvdata->rng.read = cctrng_read;
> > > +       drvdata->rng.priv = (unsigned long)drvdata;
> > > +       drvdata->rng.quality = CC_TRNG_QUALITY;
> > > +
> > > +       platform_set_drvdata(pdev, drvdata);
> > > +       drvdata->pdev = pdev;
> > > +
> > > +       drvdata->circ.buf = (char *)drvdata->data_buf;
> > > +
> > > +       /* Get device resources */
> > > +       /* First CC registers space */
> > > +       req_mem_cc_regs = platform_get_resource(pdev,
> > IORESOURCE_MEM, 0);
> > > +       /* Map registers space */
> > > +       drvdata->cc_base = devm_ioremap_resource(dev,
> > req_mem_cc_regs);
> > > +       if (IS_ERR(drvdata->cc_base)) {
> > > +               dev_err(dev, "Failed to ioremap registers");
> > > +               return PTR_ERR(drvdata->cc_base);
> > > +       }
> > > +
> > > +       dev_dbg(dev, "Got MEM resource (%s): %pR\n", req_mem_cc_regs-
> > >name,
> > > +               req_mem_cc_regs);
> > > +       dev_dbg(dev, "CC registers mapped from %pa to 0x%p\n",
> > > +               &req_mem_cc_regs->start, drvdata->cc_base);
> > > +
> > > +       /* Then IRQ */
> > > +       irq = platform_get_irq(pdev, 0);
> > > +       if (irq < 0) {
> > > +               dev_err(dev, "Failed getting IRQ resource\n");
> > > +               return irq;
> > > +       }
> > > +
> > > +       /* parse sampling rate from device tree */
> > > +       rc = cc_trng_parse_sampling_ratio(drvdata);
> > > +       if (rc) {
> > > +               dev_err(dev, "Failed to get legal sampling ratio for rosc\n");
> > > +               return rc;
> > > +       }
> > > +
> > > +       rc = cc_trng_clk_init(drvdata);
> > > +       if (rc) {
> > > +               dev_err(dev, "cc_trng_clk_init failed\n");
> > > +               return rc;
> > > +       }
> > > +
> > > +       INIT_WORK(&drvdata->compwork, cc_trng_compwork_handler);
> > > +       INIT_WORK(&drvdata->startwork, cc_trng_startwork_handler);
> > > +       spin_lock_init(&drvdata->read_lock);
> > > +
> > > +       /* register the driver isr function */
> > > +       rc = devm_request_irq(dev, irq, cc_isr, IRQF_SHARED, "cctrng",
> > > + drvdata);
> >
> > Shoudn't this be done after clearing the pending interrupts below?
>
> I'm not sure what do you mean in your question...
> I assume you're suggesting that the registration of the driver ISR function should be done only after clearing the pending interrupts?!

Indeed.

> Anyway, any pending interrupt that might exist is irrelevant to the current cctrng driver which just started (we're in the probe function)

If there is a pending interrupt, your interrupt handler (which returns
IRQ_NONE in this case) will be called repeatedly, until the driver gets
to clearing the pending interrupts below, or until the interrupt core
decides to give up, and disable it for good.

> > > +       if (rc) {
> > > +               dev_err(dev, "Could not register to interrupt %d\n", irq);
> > > +               goto post_clk_err;
> > > +       }
> > > +       dev_dbg(dev, "Registered to IRQ: %d\n", irq);
> > > +
> > > +       /* Clear all pending interrupts */
> > > +       val = cc_ioread(drvdata, CC_HOST_RGF_IRR_REG_OFFSET);
> > > +       dev_dbg(dev, "IRR=0x%08X\n", val);
> > > +       cc_iowrite(drvdata, CC_HOST_RGF_ICR_REG_OFFSET, val);
> >
> > The above accesses the engine's registers...
>
> That is right.
>
> > > +
> > > +       /* unmask HOST RNG interrupt */
> > > +       cc_iowrite(drvdata, CC_HOST_RGF_IMR_REG_OFFSET,
> > > +                  cc_ioread(drvdata, CC_HOST_RGF_IMR_REG_OFFSET) &
> > > +                  ~CC_HOST_RNG_IRQ_MASK);
> > > +
> > > +       /* init PM */
> > > +       rc = cc_trng_pm_init(drvdata);
> > > +       if (rc) {
> > > +               dev_err(dev, "cc_trng_pm_init failed\n");
> > > +               goto post_clk_err;
> > > +       }
> >
> > > +
> > > +       /* increment device's usage counter */
> > > +       rc = cc_trng_pm_get(dev);
> >
> > ... but only here is Runtime PM initialized, and the device guaranteed to be
> > powered.  If a device is accessed while powered down, this may lead to an
> > asynchronous external abort, or a plain lockup.
>
> It is assumed that when the driver is probed it is already powered. Only then, the driver initializes and enables the runtime PM to allow power down of the HW when it is not in use.

Who guarantees it is powered up? Your driver has indeed enabled the
(optional) clock above, but if the hardware block is part of a power
domain, it may still be powered down. The only way to make sure a
hardware block in a power domain is powered, is by enabling Runtime
PM and calling pm_runtime_get_sync().

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

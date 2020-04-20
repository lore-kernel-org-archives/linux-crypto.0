Return-Path: <SRS0=BVES=6E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F98C3815B
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 13:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50F8521473
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 13:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgDTNpG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Apr 2020 09:45:06 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:41119 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgDTNpG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Apr 2020 09:45:06 -0400
Received: by mail-oi1-f193.google.com with SMTP id k9so8751350oia.8;
        Mon, 20 Apr 2020 06:45:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=30fPuFeZ8+KowrZfxxMKA5oN9jvkWbTz83d3a3WghjU=;
        b=rlpq95L/PL26iyvWu9o7ByjWXc7PAbQeY6E8IPpcK0R6zn2/QVS2o9WicO83ZLK96x
         unG965rNSu84pPEvq/KuQ9QhXHlDwsBTjlQWTwKqnVps/edKViQEq0XUHmC83PGrChzP
         B5VfRLSHUuuHIsMvOs9jDKpZgr0EnFspOmURXUFn+XB4dpfMhpG3RHAjCek7e9B16Obc
         /oE90sRBOwgMIUpUOqnHm+0PperCO2rExyEX7x+ZCcjEBd1dmNuiygw35pLhW1UUAptq
         vFFGo0mRDr4fBQX9ckX3I4zdI7lbqTPM0Didxwx2eieJy3ExIOnFOiliGo7lIsOkG9c4
         dhUQ==
X-Gm-Message-State: AGi0PuZ2viCHTn0AAAg+pd6lE6x4fcRaLfuJXCX+2TFZ9lin+lrQ2glu
        ahtPhGfrROHMFhgccz2kryh3pMSnvXoWQQtRnwA=
X-Google-Smtp-Source: APiQypLA1Qn55GQn4mJL7GDyTOFPDO/nthf1o88r87quKKxquHFgIz8br0NuoDllWsVGK1L+6g+sKJxp7nqM8ixUaKU=
X-Received: by 2002:aca:f541:: with SMTP id t62mr10122357oih.148.1587390304100;
 Mon, 20 Apr 2020 06:45:04 -0700 (PDT)
MIME-Version: 1.0
References: <1585289423-18440-1-git-send-email-hadar.gat@arm.com> <1585289423-18440-3-git-send-email-hadar.gat@arm.com>
In-Reply-To: <1585289423-18440-3-git-send-email-hadar.gat@arm.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 20 Apr 2020 15:44:51 +0200
Message-ID: <CAMuHMdV6Uce79MPs7jfJfX3WOqAMH22vf2V_=Ui0zLHYqsJ+Xg@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] hw_random: cctrng: introduce Arm CryptoCell driver
To:     Hadar Gat <hadar.gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
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
        Ofir Drang <ofir.drang@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Hadar,

On Fri, Mar 27, 2020 at 7:11 AM Hadar Gat <hadar.gat@arm.com> wrote:
> Introduce low level Arm CryptoCell TRNG HW support.
>
> Signed-off-by: Hadar Gat <hadar.gat@arm.com>

Thanks for your patch!

> --- /dev/null
> +++ b/drivers/char/hw_random/cctrng.c

> +static int cctrng_probe(struct platform_device *pdev)
> +{
> +       struct resource *req_mem_cc_regs = NULL;
> +       struct cctrng_drvdata *drvdata;
> +       struct device *dev = &pdev->dev;
> +       int rc = 0;
> +       u32 val;
> +       int irq;
> +
> +       drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
> +       if (!drvdata)
> +               return -ENOMEM;
> +
> +       drvdata->rng.name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
> +       if (!drvdata->rng.name)
> +               return -ENOMEM;
> +
> +       drvdata->rng.read = cctrng_read;
> +       drvdata->rng.priv = (unsigned long)drvdata;
> +       drvdata->rng.quality = CC_TRNG_QUALITY;
> +
> +       platform_set_drvdata(pdev, drvdata);
> +       drvdata->pdev = pdev;
> +
> +       drvdata->circ.buf = (char *)drvdata->data_buf;
> +
> +       /* Get device resources */
> +       /* First CC registers space */
> +       req_mem_cc_regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       /* Map registers space */
> +       drvdata->cc_base = devm_ioremap_resource(dev, req_mem_cc_regs);
> +       if (IS_ERR(drvdata->cc_base)) {
> +               dev_err(dev, "Failed to ioremap registers");
> +               return PTR_ERR(drvdata->cc_base);
> +       }
> +
> +       dev_dbg(dev, "Got MEM resource (%s): %pR\n", req_mem_cc_regs->name,
> +               req_mem_cc_regs);
> +       dev_dbg(dev, "CC registers mapped from %pa to 0x%p\n",
> +               &req_mem_cc_regs->start, drvdata->cc_base);
> +
> +       /* Then IRQ */
> +       irq = platform_get_irq(pdev, 0);
> +       if (irq < 0) {
> +               dev_err(dev, "Failed getting IRQ resource\n");
> +               return irq;
> +       }
> +
> +       /* parse sampling rate from device tree */
> +       rc = cc_trng_parse_sampling_ratio(drvdata);
> +       if (rc) {
> +               dev_err(dev, "Failed to get legal sampling ratio for rosc\n");
> +               return rc;
> +       }
> +
> +       rc = cc_trng_clk_init(drvdata);
> +       if (rc) {
> +               dev_err(dev, "cc_trng_clk_init failed\n");
> +               return rc;
> +       }
> +
> +       INIT_WORK(&drvdata->compwork, cc_trng_compwork_handler);
> +       INIT_WORK(&drvdata->startwork, cc_trng_startwork_handler);
> +       spin_lock_init(&drvdata->read_lock);
> +
> +       /* register the driver isr function */
> +       rc = devm_request_irq(dev, irq, cc_isr, IRQF_SHARED, "cctrng", drvdata);

Shoudn't this be done after clearing the pending interrupts below?

> +       if (rc) {
> +               dev_err(dev, "Could not register to interrupt %d\n", irq);
> +               goto post_clk_err;
> +       }
> +       dev_dbg(dev, "Registered to IRQ: %d\n", irq);
> +
> +       /* Clear all pending interrupts */
> +       val = cc_ioread(drvdata, CC_HOST_RGF_IRR_REG_OFFSET);
> +       dev_dbg(dev, "IRR=0x%08X\n", val);
> +       cc_iowrite(drvdata, CC_HOST_RGF_ICR_REG_OFFSET, val);

The above accesses the engine's registers...

> +
> +       /* unmask HOST RNG interrupt */
> +       cc_iowrite(drvdata, CC_HOST_RGF_IMR_REG_OFFSET,
> +                  cc_ioread(drvdata, CC_HOST_RGF_IMR_REG_OFFSET) &
> +                  ~CC_HOST_RNG_IRQ_MASK);
> +
> +       /* init PM */
> +       rc = cc_trng_pm_init(drvdata);
> +       if (rc) {
> +               dev_err(dev, "cc_trng_pm_init failed\n");
> +               goto post_clk_err;
> +       }

> +
> +       /* increment device's usage counter */
> +       rc = cc_trng_pm_get(dev);

... but only here is Runtime PM initialized, and the device guaranteed
to be powered.  If a device is accessed while powered down, this may
lead to an asynchronous external abort, or a plain lockup.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

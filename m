Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E70BFC49ED6
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 15:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABF75218DE
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 15:10:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="T9wK89NI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbfIIPKk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 11:10:40 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38570 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbfIIPKk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 11:10:40 -0400
Received: by mail-wm1-f68.google.com with SMTP id o184so15125160wme.3
        for <linux-crypto@vger.kernel.org>; Mon, 09 Sep 2019 08:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sNBY+Xlzyd2k0VKUgwFYB3mkBB2wr1jCJnHQkHU/vRc=;
        b=T9wK89NInM5L0iMeCYgbJKr09ZPQNzaBRk389o67nDwq2gC5USDMzIDm0QLB13jDY4
         QVihZJnVSX0u1jO2JW8Ml+FnBP2mjI8CzyHOULyx9TAPQbVu7/nJwqrzNEaYg0zAuFd6
         k42SOXMZiTOM06vckYunQvAAX+F3eEA5AKyFB58/RCO0rgbRJBGackWrMzWUohdRUK69
         XsqWmuUrNLsB0/yUegaHrrApxuaBTc+iUAjxU2m7gsC+bsTMXYf5W83amQDTOu8EEP5H
         JNFL4QG9E2jkdlIxyuRHru7Vdl9mDmuJubY1d5Mdi1W6hMwtZAj2LrpHKmMSh9qp1XCy
         3HVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sNBY+Xlzyd2k0VKUgwFYB3mkBB2wr1jCJnHQkHU/vRc=;
        b=czNazn8z9/4ydz1xEwpF2OrMM2CRU1kq7C/WZ0Oi/Rhmk2CVeIwRvlVn8rDuqt+N6Z
         YHpQMSeQqc8eyoOnlCcoomSYf5/s4rz6xJWOtiOAV6jQVzWCjhcbf4rK0lUUaDp2Uk20
         90eual0QlHNt1Uf5KtIqS2s0Bf3QrYPBxyJPh3Kl35jTosyZuzL9RTdiJhct82edFJbO
         wR2U+o+xUVaGlCFjiz3B8SmHm47vxUNhJJzx/aptC28766AQgqMSZTh2Ij6mYrZeETt0
         rc562zFtVSHKfMrugj72bpulMjqrkukbd0cmyBL+b6Fwnoiii+68INe3+n/cCWQr/usl
         c7yw==
X-Gm-Message-State: APjAAAW+JP24dVN7LJ8YocXA7s2VkuNSuadmm90DXQup2ONcH560d5vc
        RCstD5CmfunhRPYI3esUnX+9RQ==
X-Google-Smtp-Source: APXvYqx1hfWgaXuqxLJlaPazQ+kYONuGH4QB63z1G1PkgOSMud/fp2NValUDV3XEREq7QgAuvHsV7g==
X-Received: by 2002:a05:600c:34d:: with SMTP id u13mr18970221wmd.97.1568041837014;
        Mon, 09 Sep 2019 08:10:37 -0700 (PDT)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id g15sm13921575wmk.17.2019.09.09.08.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 08:10:35 -0700 (PDT)
Date:   Mon, 9 Sep 2019 16:10:33 +0100
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Tomer Maimon <tmaimon77@gmail.com>
Cc:     mpm@selenic.com, herbert@gondor.apana.org.au,
        Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Avi Fishman <avifishman70@gmail.com>,
        Tali Perry <tali.perry1@gmail.com>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>, sumit.garg@linaro.org,
        jens.wiklander@linaro.org, vkoul@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Joel Stanley <joel@jms.id.au>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH v1 2/2] hwrng: npcm: add NPCM RNG driver
Message-ID: <20190909151033.f3inbbas4duzsmh5@holly.lan>
References: <20190828162617.237398-1-tmaimon77@gmail.com>
 <20190828162617.237398-3-tmaimon77@gmail.com>
 <20190829104721.tnjk3bqt3cq6iagr@holly.lan>
 <CAP6Zq1jXUhKjwBHiDKiKcpt_PiJQA61z2SUNg4_LztcnMMJ-Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP6Zq1jXUhKjwBHiDKiKcpt_PiJQA61z2SUNg4_LztcnMMJ-Ng@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 09, 2019 at 05:31:30PM +0300, Tomer Maimon wrote:
> Hi Daniel,
> 
> appreciate your comments and sorry for the late reply
> 
> On Thu, 29 Aug 2019 at 13:47, Daniel Thompson <daniel.thompson@linaro.org>
> wrote:
> 
> > On Wed, Aug 28, 2019 at 07:26:17PM +0300, Tomer Maimon wrote:
> > > Add Nuvoton NPCM BMC Random Number Generator(RNG) driver.
> > >
> > > Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
> > > ---
> > >  drivers/char/hw_random/Kconfig    |  13 ++
> > >  drivers/char/hw_random/Makefile   |   1 +
> > >  drivers/char/hw_random/npcm-rng.c | 207 ++++++++++++++++++++++++++++++
> > >  3 files changed, 221 insertions(+)
> > >  create mode 100644 drivers/char/hw_random/npcm-rng.c
> > >
> > > diff --git a/drivers/char/hw_random/npcm-rng.c
> > b/drivers/char/hw_random/npcm-rng.c
> > > new file mode 100644
> > > index 000000000000..5b4b1b6cb362
> > > --- /dev/null
> > > +++ b/drivers/char/hw_random/npcm-rng.c
> > > @@ -0,0 +1,207 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +// Copyright (c) 2019 Nuvoton Technology corporation.
> > > +
> > > +#include <linux/kernel.h>
> > > +#include <linux/module.h>
> > > +#include <linux/io.h>
> > > +#include <linux/iopoll.h>
> > > +#include <linux/init.h>
> > > +#include <linux/random.h>
> > > +#include <linux/err.h>
> > > +#include <linux/platform_device.h>
> > > +#include <linux/hw_random.h>
> > > +#include <linux/delay.h>
> > > +#include <linux/of_irq.h>
> > > +#include <linux/pm_runtime.h>
> > > +
> > > +#define NPCM_RNGCS_REG               0x00    /* Control and status
> > register */
> > > +#define NPCM_RNGD_REG                0x04    /* Data register */
> > > +#define NPCM_RNGMODE_REG     0x08    /* Mode register */
> > > +
> > > +#define NPCM_RNG_CLK_SET_25MHZ       GENMASK(4, 3) /* 20-25 MHz */
> > > +#define NPCM_RNG_DATA_VALID  BIT(1)
> > > +#define NPCM_RNG_ENABLE              BIT(0)
> > > +#define NPCM_RNG_M1ROSEL     BIT(1)
> > > +
> > > +#define NPCM_RNG_TIMEOUT_POLL        20
> >
> > Might be better to define this in real-world units (such as
> > milliseconds) since the timeout is effectively the longest time the
> > hardware can take to generate 4 bytes.
> >
> > > +
> > > +#define to_npcm_rng(p)       container_of(p, struct npcm_rng, rng)
> > > +
> > > +struct npcm_rng {
> > > +     void __iomem *base;
> > > +     struct hwrng rng;
> > > +};
> > > +
> > > +static int npcm_rng_init(struct hwrng *rng)
> > > +{
> > > +     struct npcm_rng *priv = to_npcm_rng(rng);
> > > +     u32 val;
> > > +
> > > +     val = readl(priv->base + NPCM_RNGCS_REG);
> > > +     val |= NPCM_RNG_ENABLE;
> > > +     writel(val, priv->base + NPCM_RNGCS_REG);
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +static void npcm_rng_cleanup(struct hwrng *rng)
> > > +{
> > > +     struct npcm_rng *priv = to_npcm_rng(rng);
> > > +     u32 val;
> > > +
> > > +     val = readl(priv->base + NPCM_RNGCS_REG);
> > > +     val &= ~NPCM_RNG_ENABLE;
> > > +     writel(val, priv->base + NPCM_RNGCS_REG);
> > > +}
> > > +
> > > +static bool npcm_rng_wait_ready(struct hwrng *rng, bool wait)
> > > +{
> > > +     struct npcm_rng *priv = to_npcm_rng(rng);
> > > +     int timeout_cnt = 0;
> > > +     int ready;
> > > +
> > > +     ready = readl(priv->base + NPCM_RNGCS_REG) & NPCM_RNG_DATA_VALID;
> > > +     while ((ready == 0) && (timeout_cnt < NPCM_RNG_TIMEOUT_POLL)) {
> > > +             usleep_range(500, 1000);
> > > +             ready = readl(priv->base + NPCM_RNGCS_REG) &
> > > +                     NPCM_RNG_DATA_VALID;
> > > +             timeout_cnt++;
> > > +     }
> > > +
> > > +     return !!ready;
> > > +}
> >
> > This looks like an open-coded version of readl_poll_timeout()... better
> > to use the library function.
> >
> > Also the sleep looks a bit long to me. What is the generation rate of
> > the peripheral? Most RNG drivers have short intervals between data
> > generation so they use delays rather than sleeps (a.k.a.
> > readl_poll_timeout_atomic() ).
>
> the HWRNG generate byte of random data in a few milliseconds so it is
> better to use the sleep command.

That's fine, just use readl_poll_timeout() then.


> > > +
> > > +static int npcm_rng_read(struct hwrng *rng, void *buf, size_t max, bool
> > wait)
> > > +{
> > > +     struct npcm_rng *priv = to_npcm_rng(rng);
> > > +     int retval = 0;
> > > +
> > > +     pm_runtime_get_sync((struct device *)priv->rng.priv);
> > > +
> > > +     while (max >= sizeof(u32)) {
> > > +             if (!npcm_rng_wait_ready(rng, wait))
> > > +                     break;
> >
> > The code as currently written does not honour the wait parameter (e.g.
> > it sleeps even when wait is false).
> >
> >
> > > +
> > > +             *(u32 *)buf = readl(priv->base + NPCM_RNGD_REG);
> > > +             retval += sizeof(u32);
> > > +             buf += sizeof(u32);
> > > +             max -= sizeof(u32);
> > > +     }
> > > +
> > > +     pm_runtime_mark_last_busy((struct device *)priv->rng.priv);
> > > +     pm_runtime_put_sync_autosuspend((struct device *)priv->rng.priv);
> > > +
> > > +     return retval || !wait ? retval : -EIO;
> > > +}
> > > +
> > > +static int npcm_rng_probe(struct platform_device *pdev)
> > > +{
> > > +     struct npcm_rng *priv;
> > > +     struct resource *res;
> > > +     u32 quality;
> > > +     int ret;
> > > +
> > > +     priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> > > +     if (!priv)
> > > +             return -ENOMEM;
> > > +
> > > +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > +     priv->base = devm_ioremap_resource(&pdev->dev, res);
> > > +     if (IS_ERR(priv->base))
> > > +             return PTR_ERR(priv->base);
> > > +
> > > +     priv->rng.name = pdev->name;
> > > +#ifndef CONFIG_PM
> > > +     priv->rng.init = npcm_rng_init;
> > > +     priv->rng.cleanup = npcm_rng_cleanup;
> > > +#endif
> > > +     priv->rng.read = npcm_rng_read;
> > > +     priv->rng.priv = (unsigned long)&pdev->dev;
> > > +     if (of_property_read_u32(pdev->dev.of_node, "quality", &quality))
> > > +             priv->rng.quality = 1000;
> > > +     else
> > > +             priv->rng.quality = quality;
> > > +
> > > +     writel(NPCM_RNG_M1ROSEL, priv->base + NPCM_RNGMODE_REG);
> > > +#ifndef CONFIG_PM
> > > +     writel(NPCM_RNG_CLK_SET_25MHZ, priv->base + NPCM_RNGCS_REG);
> > > +#else
> > > +     writel(NPCM_RNG_CLK_SET_25MHZ | NPCM_RNG_ENABLE,
> > > +            priv->base + NPCM_RNGCS_REG);
> > > +#endif
> >
> > If this initialization was moved to npcm_rng_init() then there would be
> > no need for the additional ifdefing. It would also get rid of the
> > (potentially slow) readl calls on the PM wakeup path.
> >
> 
> But when the Kernel have PM configuration than the priv->rng.init is not
> set and
> *add_early_randomness* function is called. for the *add_early_randomness*
> success
> the hwrng need to enabled in the probe.

Sorry but I don't understand this reply.

When CONFIG_PM is enabled then the probe function does not currently set
NPCM_RNG_ENABLE; instead is relies on npcm_rng_init() being called by
the PM logic (as part of pm_runtime_get_sync() ).

Given the code *already* relies on npcm_rng_init() being called by the
PM logic why does it matter if additional init is put there?


Daniel.

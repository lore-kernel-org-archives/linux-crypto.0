Return-Path: <SRS0=jX8O=RE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C27CFC43381
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 10:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D53B2085A
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 10:07:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Fz9mVTBR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387765AbfCAKHa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Mar 2019 05:07:30 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:38445 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733008AbfCAKHa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Mar 2019 05:07:30 -0500
Received: by mail-io1-f65.google.com with SMTP id p18so19126127ioh.5
        for <linux-crypto@vger.kernel.org>; Fri, 01 Mar 2019 02:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LG6JncRnG3r386DmLZKM+48qPJD8K/l3MztsfA3x/jo=;
        b=Fz9mVTBRSYCdK4UbA6m9P33P6LmXhX4eIFSAEUxj+ZuGFr+wckhSAk2cDRFMG061gz
         j+LpoSPU2dv7s/BHYgSSQUG9YWwV7kELzbyhwrWrIWTqbTLwuS+kolhzFBnEXsU+zBU8
         Bn5u8Y9KHh614FdQYz3oRRWxSZKlIQLmHTdRuGBOSJZyzQQcTaNr5Rcn5fBNMoJUzpKE
         neolS3HIDU4xs6lawC7yOYZShXW698axYMawHuOpOB6WoLGC3GQ6VlvK4M1qGEOhLew3
         LXqr+n6AZQyG3Nd78x1kSw+UfZpbPpO+SigiMbC3MfACt49u0LXGLLU4u6jUrxiS7l7a
         bKSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LG6JncRnG3r386DmLZKM+48qPJD8K/l3MztsfA3x/jo=;
        b=naqtKXoYboFv7+hIXV2XQt1HhXUOJAp9nH3OdZUGc40PENSwwEF0VuzqTNonsYjr0N
         q56gQ7Uhq5wt/ntVqwMl6PD+uHyydJhNL/kSP9W/IlRZbvBYepAJ5XDZ5vYh68JMrGbi
         3Vs6AHvI9e3HxLHXjo7Ut0SmDbdcT9Ub05WciMgWukMYk6w+9LAgjTM35IUheHZkCDEP
         ZBlkfP2Urb0LjaIBcDa5CYCzfdjevhDuro3aeVlhfv3hpeG9fFE6UN68iwCs0e7fNHCc
         +W1O/HVFpvf8zvjXWUH9lzE9JOqRsUxwH7oiLp67FsUsm/Rhgn0cQ7fsAD/ZBki1EKLk
         UN4w==
X-Gm-Message-State: APjAAAWLtz4AM9W9fcbf23/deGbibUr1RvFUeZ61T7MSXdD9QyciK0Ka
        0MzxCWBbg4nSI1Ck9sj1xrh/Cy1MNGuaX89X13eJyPvkD4I=
X-Google-Smtp-Source: APXvYqxUmQo9kpVdDWmzhD9BTr3n7nBKuiIPJYSWaS7ZVutkXZ7FB8YfDHzFJ4rhvk2pd6RkJBK3kefmewF2tgZp1XQ=
X-Received: by 2002:a6b:7b02:: with SMTP id l2mr2322929iop.60.1551434849469;
 Fri, 01 Mar 2019 02:07:29 -0800 (PST)
MIME-Version: 1.0
References: <CGME20190222122204eucas1p1ee66c9d937bdf328588ececb1f005526@eucas1p1.samsung.com>
 <20190222122144.19024-1-k.konieczny@partner.samsung.com> <20190222122144.19024-4-k.konieczny@partner.samsung.com>
 <CAJKOXPdgcQPriU7nT3K_DyB+NniLDf6b8993qu9zwW_dEuYogw@mail.gmail.com>
In-Reply-To: <CAJKOXPdgcQPriU7nT3K_DyB+NniLDf6b8993qu9zwW_dEuYogw@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 1 Mar 2019 11:07:17 +0100
Message-ID: <CAKv+Gu8EhppjBbBa3KDheb_YGFVZ0JBxe=mf8Fpq68PWazcyrQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] crypto: s5p: add AES support for Exynos5433
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 1 Mar 2019 at 10:56, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Fri, 22 Feb 2019 at 13:22, Kamil Konieczny
> <k.konieczny@partner.samsung.com> wrote:
> >
> > Add AES crypto HW acceleration for Exynos5433, with the help of SlimSSS IP.
> >
> > Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
> > Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> > ---
> >  drivers/crypto/s5p-sss.c | 50 ++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 46 insertions(+), 4 deletions(-)
> > diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> > index 0064be0e3941..3f45cc5cb94a 100644
> > --- a/drivers/crypto/s5p-sss.c
> > +++ b/drivers/crypto/s5p-sss.c
> > @@ -232,6 +232,7 @@
> >   * struct samsung_aes_variant - platform specific SSS driver data
> >   * @aes_offset: AES register offset from SSS module's base.
> >   * @hash_offset: HASH register offset from SSS module's base.
> > + * @clk_names: names of clocks needed to run SSS IP
> >   *
> >   * Specifies platform specific configuration of SSS module.
> >   * Note: A structure for driver specific platform data is used for future
> > @@ -240,6 +241,7 @@
> >  struct samsung_aes_variant {
> >         unsigned int                    aes_offset;
> >         unsigned int                    hash_offset;
> > +       const char                      *clk_names[];
> >  };
> >
> >  struct s5p_aes_reqctx {
> > @@ -296,6 +298,7 @@ struct s5p_aes_ctx {
> >  struct s5p_aes_dev {
> >         struct device                   *dev;
> >         struct clk                      *clk;
> > +       struct clk                      *pclk;
> >         void __iomem                    *ioaddr;
> >         void __iomem                    *aes_ioaddr;
> >         int                             irq_fc;
> > @@ -384,11 +387,19 @@ struct s5p_hash_ctx {
> >  static const struct samsung_aes_variant s5p_aes_data = {
> >         .aes_offset     = 0x4000,
> >         .hash_offset    = 0x6000,
> > +       .clk_names      = { "secss", },
> >  };
> >
> >  static const struct samsung_aes_variant exynos_aes_data = {
> >         .aes_offset     = 0x200,
> >         .hash_offset    = 0x400,
> > +       .clk_names      = { "secss", },
> > +};
> > +
> > +static const struct samsung_aes_variant exynos5433_slim_aes_data = {
> > +       .aes_offset     = 0x400,
> > +       .hash_offset    = 0x800,
> > +       .clk_names      = { "pclk", "aclk", },
> >  };
> >
> >  static const struct of_device_id s5p_sss_dt_match[] = {
> > @@ -400,6 +411,10 @@ static const struct of_device_id s5p_sss_dt_match[] = {
> >                 .compatible = "samsung,exynos4210-secss",
> >                 .data = &exynos_aes_data,
> >         },
> > +       {
> > +               .compatible = "samsung,exynos5433-slim-sss",
> > +               .data = &exynos5433_slim_aes_data,
> > +       },
> >         { },
> >  };
> >  MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
> > @@ -2208,18 +2223,39 @@ static int s5p_aes_probe(struct platform_device *pdev)
> >                         return PTR_ERR(pdata->ioaddr);
> >         }
> >
> > -       pdata->clk = devm_clk_get(dev, "secss");
> > +       pdata->clk = devm_clk_get(dev, variant->clk_names[0]);
> >         if (IS_ERR(pdata->clk)) {
> > -               dev_err(dev, "failed to find secss clock source\n");
> > +               dev_err(dev, "failed to find secss clock %s\n",
> > +                       variant->clk_names[0]);
> >                 return -ENOENT;
> >         }
> >
> >         err = clk_prepare_enable(pdata->clk);
> >         if (err < 0) {
> > -               dev_err(dev, "Enabling SSS clk failed, err %d\n", err);
> > +               dev_err(dev, "Enabling clock %s failed, err %d\n",
> > +                       variant->clk_names[0], err);
> >                 return err;
> >         }
> >
> > +       if (variant->clk_names[1]) {
> > +               pdata->pclk = devm_clk_get(dev, variant->clk_names[1]);
>
> I see on today's linux next:
> [ 6.391256] Unable to handle kernel paging request at virtual address 00004000
> on all my Exynos boards (U3, XU, XU3, HC1).
> I did not do a bisect yet but it might be connected with this commit.
>
> The call trace is:
> (strcmp) from [<c0774014>] (of_property_match_string+0x58/0xd0)
> (of_property_match_string) from [<c04d3d2c>] (__of_clk_get_by_name+0x5c/0x130)
> (__of_clk_get_by_name) from [<c04d3fa0>] (clk_get+0x34/0x70)
> (clk_get) from [<c04d3680>] (devm_clk_get+0x38/0x74)
> (devm_clk_get) from [<c075c248>] (s5p_aes_probe+0xd4/0x4a0)
> (s5p_aes_probe) from [<c059dbc4>] (platform_drv_probe+0x6c/0xa4)
> (platform_drv_probe) from [<c059b4c8>] (really_probe+0x280/0x414)
> (really_probe) from [<c059b810>] (driver_probe_device+0x78/0x1c0)
> (driver_probe_device) from [<c059bbb8>] (device_driver_attach+0x58/0x60)
> (device_driver_attach) from [<c059bcbc>] (__driver_attach+0xfc/0x160)
> (__driver_attach) from [<c059928c>] (bus_for_each_dev+0x68/0xb4)
> (bus_for_each_dev) from [<c059a5c4>] (bus_add_driver+0x158/0x214)
> (bus_add_driver) from [<c059cb94>] (driver_register+0x78/0x110)
> (driver_register) from [<c01031f8>] (do_one_initcall+0x8c/0x404)
>
> Full log:
> https://krzk.eu/#/builders/21/builds/1153/steps/12/logs/serial0
>
> The s5p_aes_probe address points here.
>

It seems that dereferencing clk_names[1] of struct samsung_aes_variant
exynos_aes_data

> > +       .clk_names      = { "secss", },

returns the first member of

> >  static const struct samsung_aes_variant s5p_aes_data = {
> >         .aes_offset     = 0x4000,

since the array has only one entry in this case, and so the second,
non-existing entry overlaps with the next data item in the object
file.

So the fix would be to use

.clk_names      = { "secss", NULL },

instead (or define the array to have 2 members)


>
> >
> > +               if (IS_ERR(pdata->pclk)) {
> > +                       dev_err(dev, "failed to find clock %s\n",
> > +                               variant->clk_names[1]);
> > +                       err = -ENOENT;
> > +                       goto err_clk;
> > +               }
> > +
> > +               err = clk_prepare_enable(pdata->pclk);
> > +               if (err < 0) {
> > +                       dev_err(dev, "Enabling clock %s failed, err %d\n",
> > +                               variant->clk_names[0], err);
> > +                       goto err_clk;
> > +               }
> > +       } else {
> > +               pdata->pclk = NULL;
> > +       }
> > +
> >         spin_lock_init(&pdata->lock);
> >         spin_lock_init(&pdata->hash_lock);
> >
> > @@ -2295,8 +2331,11 @@ static int s5p_aes_probe(struct platform_device *pdev)
> >         tasklet_kill(&pdata->tasklet);
> >
> >  err_irq:
> > -       clk_disable_unprepare(pdata->clk);
> > +       if (pdata->pclk)
> > +               clk_disable_unprepare(pdata->pclk);
> >
> > +err_clk:
> > +       clk_disable_unprepare(pdata->clk);
> >         s5p_dev = NULL;
> >
> >         return err;
> > @@ -2323,6 +2362,9 @@ static int s5p_aes_remove(struct platform_device *pdev)
> >                 pdata->use_hash = false;
> >         }
> >
> > +       if (pdata->pclk)
> > +               clk_disable_unprepare(pdata->pclk);
> > +
> >         clk_disable_unprepare(pdata->clk);
> >         s5p_dev = NULL;
> >
> > --
> > 2.20.1
> >

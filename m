Return-Path: <SRS0=jX8O=RE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3CAC43381
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 10:12:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAF682087E
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Mar 2019 10:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551435155;
	bh=4zI19HcoLDF46FyEYyPQI5PrixkUD2cR1vcwr2BbLb8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=oGsY4AqA7/8yFGwwK+EV3+y65owi8xt0L5C9XFPTWE+mMVa8oky8pKpfCfDsf/d0B
	 LX9wcb1pJo4ImxKZ1Lio3PW7Z1E64k6qu9GQ8DPK2WJoFzm7Z/meHETcj7D6hn3Dbh
	 Sr79B+nvzPiyh6xYmD+YZ5MwHEikp/1KnQENM8BU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731675AbfCAKMe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Mar 2019 05:12:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728300AbfCAKMd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Mar 2019 05:12:33 -0500
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CEA9218D8;
        Fri,  1 Mar 2019 10:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551435152;
        bh=4zI19HcoLDF46FyEYyPQI5PrixkUD2cR1vcwr2BbLb8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TIKZttWMyUSKWYzS/Jwa9UOhiWDshtlkG9BJflpvEi3YyviUvB5zqNgZ7M1gz3h50
         c7T8Uu0KNrdletRpET48bIuoXrlqTq+/ivL9lLSZcfXfQca2YaN3ULnCrWp+qtHd/P
         W2DQ+18L1zl0Lo+QNXs1PRMkONvFVvxxuv3PkHVY=
Received: by mail-lf1-f45.google.com with SMTP id m73so12039552lfa.2;
        Fri, 01 Mar 2019 02:12:32 -0800 (PST)
X-Gm-Message-State: APjAAAX5gbdhUp4S/ZD7SjNKlbK2a/CzcAbSyfViasICw9C7nj12ndHw
        0KjBqPFrXwgH8IsdH7zElqMe/33BFVDRWaEuTHo=
X-Google-Smtp-Source: APXvYqy7tg+SEugo+s55O6YAKzoyAn2XcSKVS9+1o1fZD8yNFFHtIcseQvqcrr2peKqeYxC6VZfwDXZbd3/CuDppWVI=
X-Received: by 2002:a19:2396:: with SMTP id j144mr2440072lfj.159.1551435150160;
 Fri, 01 Mar 2019 02:12:30 -0800 (PST)
MIME-Version: 1.0
References: <CGME20190222122204eucas1p1ee66c9d937bdf328588ececb1f005526@eucas1p1.samsung.com>
 <20190222122144.19024-1-k.konieczny@partner.samsung.com> <20190222122144.19024-4-k.konieczny@partner.samsung.com>
 <CAJKOXPdgcQPriU7nT3K_DyB+NniLDf6b8993qu9zwW_dEuYogw@mail.gmail.com> <CAKv+Gu8EhppjBbBa3KDheb_YGFVZ0JBxe=mf8Fpq68PWazcyrQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu8EhppjBbBa3KDheb_YGFVZ0JBxe=mf8Fpq68PWazcyrQ@mail.gmail.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Fri, 1 Mar 2019 11:12:18 +0100
X-Gmail-Original-Message-ID: <CAJKOXPfzsPS1VT08SDR013a5Xz+m9sjVvEMNb-Q64Zr_nKG8kg@mail.gmail.com>
Message-ID: <CAJKOXPfzsPS1VT08SDR013a5Xz+m9sjVvEMNb-Q64Zr_nKG8kg@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] crypto: s5p: add AES support for Exynos5433
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
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

On Fri, 1 Mar 2019 at 11:07, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Fri, 1 Mar 2019 at 10:56, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> >
> > On Fri, 22 Feb 2019 at 13:22, Kamil Konieczny
> > <k.konieczny@partner.samsung.com> wrote:
> > >
> > > Add AES crypto HW acceleration for Exynos5433, with the help of SlimSSS IP.
> > >
> > > Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
> > > Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> > > ---
> > >  drivers/crypto/s5p-sss.c | 50 ++++++++++++++++++++++++++++++++++++----
> > >  1 file changed, 46 insertions(+), 4 deletions(-)
> > > diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> > > index 0064be0e3941..3f45cc5cb94a 100644
> > > --- a/drivers/crypto/s5p-sss.c
> > > +++ b/drivers/crypto/s5p-sss.c
> > > @@ -232,6 +232,7 @@
> > >   * struct samsung_aes_variant - platform specific SSS driver data
> > >   * @aes_offset: AES register offset from SSS module's base.
> > >   * @hash_offset: HASH register offset from SSS module's base.
> > > + * @clk_names: names of clocks needed to run SSS IP
> > >   *
> > >   * Specifies platform specific configuration of SSS module.
> > >   * Note: A structure for driver specific platform data is used for future
> > > @@ -240,6 +241,7 @@
> > >  struct samsung_aes_variant {
> > >         unsigned int                    aes_offset;
> > >         unsigned int                    hash_offset;
> > > +       const char                      *clk_names[];
> > >  };
> > >
> > >  struct s5p_aes_reqctx {
> > > @@ -296,6 +298,7 @@ struct s5p_aes_ctx {
> > >  struct s5p_aes_dev {
> > >         struct device                   *dev;
> > >         struct clk                      *clk;
> > > +       struct clk                      *pclk;
> > >         void __iomem                    *ioaddr;
> > >         void __iomem                    *aes_ioaddr;
> > >         int                             irq_fc;
> > > @@ -384,11 +387,19 @@ struct s5p_hash_ctx {
> > >  static const struct samsung_aes_variant s5p_aes_data = {
> > >         .aes_offset     = 0x4000,
> > >         .hash_offset    = 0x6000,
> > > +       .clk_names      = { "secss", },
> > >  };
> > >
> > >  static const struct samsung_aes_variant exynos_aes_data = {
> > >         .aes_offset     = 0x200,
> > >         .hash_offset    = 0x400,
> > > +       .clk_names      = { "secss", },
> > > +};
> > > +
> > > +static const struct samsung_aes_variant exynos5433_slim_aes_data = {
> > > +       .aes_offset     = 0x400,
> > > +       .hash_offset    = 0x800,
> > > +       .clk_names      = { "pclk", "aclk", },
> > >  };
> > >
> > >  static const struct of_device_id s5p_sss_dt_match[] = {
> > > @@ -400,6 +411,10 @@ static const struct of_device_id s5p_sss_dt_match[] = {
> > >                 .compatible = "samsung,exynos4210-secss",
> > >                 .data = &exynos_aes_data,
> > >         },
> > > +       {
> > > +               .compatible = "samsung,exynos5433-slim-sss",
> > > +               .data = &exynos5433_slim_aes_data,
> > > +       },
> > >         { },
> > >  };
> > >  MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
> > > @@ -2208,18 +2223,39 @@ static int s5p_aes_probe(struct platform_device *pdev)
> > >                         return PTR_ERR(pdata->ioaddr);
> > >         }
> > >
> > > -       pdata->clk = devm_clk_get(dev, "secss");
> > > +       pdata->clk = devm_clk_get(dev, variant->clk_names[0]);
> > >         if (IS_ERR(pdata->clk)) {
> > > -               dev_err(dev, "failed to find secss clock source\n");
> > > +               dev_err(dev, "failed to find secss clock %s\n",
> > > +                       variant->clk_names[0]);
> > >                 return -ENOENT;
> > >         }
> > >
> > >         err = clk_prepare_enable(pdata->clk);
> > >         if (err < 0) {
> > > -               dev_err(dev, "Enabling SSS clk failed, err %d\n", err);
> > > +               dev_err(dev, "Enabling clock %s failed, err %d\n",
> > > +                       variant->clk_names[0], err);
> > >                 return err;
> > >         }
> > >
> > > +       if (variant->clk_names[1]) {
> > > +               pdata->pclk = devm_clk_get(dev, variant->clk_names[1]);
> >
> > I see on today's linux next:
> > [ 6.391256] Unable to handle kernel paging request at virtual address 00004000
> > on all my Exynos boards (U3, XU, XU3, HC1).
> > I did not do a bisect yet but it might be connected with this commit.
> >
> > The call trace is:
> > (strcmp) from [<c0774014>] (of_property_match_string+0x58/0xd0)
> > (of_property_match_string) from [<c04d3d2c>] (__of_clk_get_by_name+0x5c/0x130)
> > (__of_clk_get_by_name) from [<c04d3fa0>] (clk_get+0x34/0x70)
> > (clk_get) from [<c04d3680>] (devm_clk_get+0x38/0x74)
> > (devm_clk_get) from [<c075c248>] (s5p_aes_probe+0xd4/0x4a0)
> > (s5p_aes_probe) from [<c059dbc4>] (platform_drv_probe+0x6c/0xa4)
> > (platform_drv_probe) from [<c059b4c8>] (really_probe+0x280/0x414)
> > (really_probe) from [<c059b810>] (driver_probe_device+0x78/0x1c0)
> > (driver_probe_device) from [<c059bbb8>] (device_driver_attach+0x58/0x60)
> > (device_driver_attach) from [<c059bcbc>] (__driver_attach+0xfc/0x160)
> > (__driver_attach) from [<c059928c>] (bus_for_each_dev+0x68/0xb4)
> > (bus_for_each_dev) from [<c059a5c4>] (bus_add_driver+0x158/0x214)
> > (bus_add_driver) from [<c059cb94>] (driver_register+0x78/0x110)
> > (driver_register) from [<c01031f8>] (do_one_initcall+0x8c/0x404)
> >
> > Full log:
> > https://krzk.eu/#/builders/21/builds/1153/steps/12/logs/serial0
> >
> > The s5p_aes_probe address points here.
> >
>
> It seems that dereferencing clk_names[1] of struct samsung_aes_variant
> exynos_aes_data
>
> > > +       .clk_names      = { "secss", },
>
> returns the first member of
>
> > >  static const struct samsung_aes_variant s5p_aes_data = {
> > >         .aes_offset     = 0x4000,
>
> since the array has only one entry in this case, and so the second,
> non-existing entry overlaps with the next data item in the object
> file.
>
> So the fix would be to use
>
> .clk_names      = { "secss", NULL },
>
> instead (or define the array to have 2 members)

Ah yes, the size of the array is not fixed during definition. Probably
having explicit size would be less error-prone in the future (if
someone adds third clock).

Best regards,
Krzysztof

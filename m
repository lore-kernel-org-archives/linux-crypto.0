Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC7C3C31E40
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 17:56:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FB8E20663
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 17:56:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mux8a8LR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfHLR4Y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 13:56:24 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:40022 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfHLR4X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 13:56:23 -0400
Received: by mail-ot1-f67.google.com with SMTP id c34so22133999otb.7;
        Mon, 12 Aug 2019 10:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DwkJnZQwcd2vdtvKtixBQGDvtW9rbIGj3aJiuLEEfEw=;
        b=Mux8a8LRF8dsI5HB6we1YRsuzPlDkVt/DE+bSeIlvt5J4wTpRiAMlxErc2mSeE8f5x
         Ars+Buig/NYgI/C8GATm4HWWMrLMFIrgmPjcjRgnEtNoUcnrhnnUh6wRB4Erkco0b/5G
         hp9C21qRYKvHXaEywD0D+Z3Kno+R6OKsKKXW1xHwOAAjUwkOg4GAiGsbkQNvaYMfVAXr
         SjV/DIsIwfCQGFryADIe0tge0yDGBezynvYiMn+lbiuK8N/kbzV+9IsHgCAegQvmeGol
         rS034sRa2Th+HSNdzjVzjEwQWInBZxxDY2EG8S1IduwwWjHTIhny76MJ25mgzpLY4bDs
         +YWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DwkJnZQwcd2vdtvKtixBQGDvtW9rbIGj3aJiuLEEfEw=;
        b=EkdqB1nwTi5DCV/ZEXu+qJHnRuaAA6iyBbYdpMTyDRAVquhibrBv3FKcH2GAj7KXXR
         9SvYShEZX15zIxuF/PeXlXELmpmKRHyN29vw2lBChgdsSRMgT6NF5G4BE9JtzdxQBh/w
         m+HY55vDOBf62hR3+O/F7+Sgs5cEw14dE2d/CdxRggOufo2GyDOSiLhUyZWiwqkofJPO
         5OKQmEiWgM82WXb7cAQtG/cVQJZXIuRgy/lzcm6xmsfxhU//x/DOQaEh/Gze0iTjveCP
         hpPNdMGdJ0IwtnFX6GnYJG82Owbxynf5rCSbGlUCyp1pQmi0HA1XoJvmioJ/KqIP52Fy
         xVpQ==
X-Gm-Message-State: APjAAAWmwJJcKVIkkCXM5A2E2/HtO/OJqniK9qBXTzDwmvbc6OBVBaJD
        amp3BenJ1fS5sHQRCil1CHv35LLUiTlNYlnGq10=
X-Google-Smtp-Source: APXvYqx3ZW8jVc7kI7rD18JChyHGb8gtCcVTNL5M4EJrHiQf0uMaV9kOvHszHGopenJZP0cGJ2qTzgDhoLL6yyjHdFY=
X-Received: by 2002:a02:16c5:: with SMTP id a188mr22241140jaa.86.1565632582885;
 Mon, 12 Aug 2019 10:56:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
 <20190717152458.22337-3-andrew.smirnov@gmail.com> <VI1PR0402MB3485E4DDB5E3BDCBC2AAAFE398C70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485E4DDB5E3BDCBC2AAAFE398C70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 12 Aug 2019 10:56:11 -0700
Message-ID: <CAHQ1cqF=7h=mcKSBNRoYX5mkRetEbvb8dGkDyqHcDf1TCpr40w@mail.gmail.com>
Subject: Re: [PATCH v6 02/14] crypto: caam - simplfy clock initialization
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 23, 2019 at 7:17 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 7/17/2019 6:25 PM, Andrey Smirnov wrote:
> > Simplify clock initialization code by converting it to use clk-bulk,
> > devres and soc_device_match() match table. No functional change
> > intended.
> >
> Thanks.
> Two nitpicks below.
>
> > +static int init_clocks(struct device *dev,
> > +                    struct caam_drv_private *ctrlpriv,
> > +                    const struct caam_imx_data *data)
> > +{
> > +     int ret;
> > +
> > +     ctrlpriv->num_clks = data->num_clks;
> > +     ctrlpriv->clks = devm_kmemdup(dev, data->clks,
> > +                                   data->num_clks * sizeof(data->clks[0]),
> > +                                   GFP_KERNEL);
> > +     if (!ctrlpriv->clks)
> > +             return -ENOMEM;
> > +
> > +     ret = devm_clk_bulk_get(dev, ctrlpriv->num_clks, ctrlpriv->clks);
> > +     if (ret) {
> > +             dev_err(dev,
> > +                     "Failed to request all necessary clocks\n");
> > +             return ret;
> > +     }
> > +
> > +     ret = clk_bulk_prepare_enable(ctrlpriv->num_clks, ctrlpriv->clks);
> > +     if (ret) {
> > +             dev_err(dev,
> > +                     "Failed to prepare/enable all necessary clocks\n");
> > +             return ret;
> > +     }
> > +
> > +     ret = devm_add_action_or_reset(dev, disable_clocks, ctrlpriv);
> > +     if (ret)
> > +             return ret;
> > +
> > +     return 0;
> Or directly:
>         return devm_add_action_or_reset(dev, disable_clocks, ctrlpriv);
>
> > +     imx_soc_match = soc_device_match(caam_imx_soc_table);
> > +     if (imx_soc_match) {
> > +             if (!imx_soc_match->data) {
> > +                     dev_err(dev, "No clock data provided for i.MX SoC");
> > +                     return -EINVAL;
> [...]
> > +             ret = init_clocks(dev, ctrlpriv, imx_soc_match->data);
> ctrlpriv can be retrieved using dev_get_drvdata(dev), thus there's no need
> to pass it as parameter.
>

Will fix in v7.

Thanks,
Andrey Smirnov

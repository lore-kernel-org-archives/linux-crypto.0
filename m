Return-Path: <SRS0=7mlD=VM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB35C7618F
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 18:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 741B820665
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 18:14:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G6kNtcg+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbfGOSO4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 14:14:56 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39364 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729596AbfGOSO4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 14:14:56 -0400
Received: by mail-io1-f65.google.com with SMTP id f4so35626232ioh.6;
        Mon, 15 Jul 2019 11:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g8sVhGK6F62BS3Usb2zjSl3PuqTfL6BiWLfDVyku7Eo=;
        b=G6kNtcg+vxLoflZCoFR2fy40N4eUm0Xm6mGAoM53qF3YSfB4zEJNAILcXWUzKNFAiu
         qbyHEYdY8ByLy1j4W3lKtgsQRewpraawsUdufD+J/LQzjW63cHAu5UT1f9rQ3UH2w90X
         55Onu17UpNilKibqqhGL6Pbg50PvLRXrAtv7QFWI3DOVdVs+95b1vzJ7zYXNKutZ4W7A
         pJypXiHTEHdlOg+WpxdAuz9hpxlqw3xhwUI3CeRqKuR+DTVyzHtWZ6RzaC62fP+oBSrP
         mDwiDFOAfon7JccJ81nrOOU00D3vDepHOdJqI4it83sMXuKAxG0TpCF3uJCktHtE60j6
         iYgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g8sVhGK6F62BS3Usb2zjSl3PuqTfL6BiWLfDVyku7Eo=;
        b=WbXD3R0/ELt+kw6/mKByKxF8v3By6vw2eBn6M9Qyt+9QovE+Vkzx8nS3Ky1mfOaEUB
         BYoIUP91aOxonsU7olsLiYHDuYKRmiKE65CZ2Q40wDE2StFbWLeKfpzHtw/5AOuHUiLK
         cl6tmePmTka/hk3elDM1Mz6uc3fpWA1mc7F6XmU7LB3/EqATek43pZxESOqAGPHHDiLP
         t89XsALvqKXwJubAipJiEKzay4l8xRrNEJlRvVUuZ+he+Eh7iXz3fBicEfbNg0jVspe4
         Ulyk+UZmaPhDA2/0uSHePGp4O3hVdETs6ljx5Qu5sVrIsDj8EPFavGeMdUvGThcNM6jG
         mlSA==
X-Gm-Message-State: APjAAAXqCX96fqo2URdVCvyVuRtzedK8n+rgAyQU2Rwf0h3FvrbYq1GB
        l1RQk/pOU/wVhBeKD3QNyj1qwpV/GTxDTvgq6M4=
X-Google-Smtp-Source: APXvYqwATO9IwaZSQroTV7zde4rhkPaWU0alXqJiqT5PX/jRUfEvJVmffJrMP9UmlblfbIoH5O1vSbJiBhZyRGlbWLI=
X-Received: by 2002:a02:16c5:: with SMTP id a188mr29949004jaa.86.1563214495209;
 Mon, 15 Jul 2019 11:14:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190703081327.17505-1-andrew.smirnov@gmail.com>
 <20190703081327.17505-3-andrew.smirnov@gmail.com> <VI1PR04MB44452213E0EB98FA1FCC31688CFA0@VI1PR04MB4445.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB44452213E0EB98FA1FCC31688CFA0@VI1PR04MB4445.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 15 Jul 2019 11:14:43 -0700
Message-ID: <CAHQ1cqFCraDXFr4DYCE5XHM-fM=xQ5VrZkTVdV1NyrtdDyoR_A@mail.gmail.com>
Subject: Re: [PATCH v4 02/16] crypto: caam - simplify clock initialization
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 4, 2019 at 8:43 AM Iuliana Prodan <iuliana.prodan@nxp.com> wrot=
e:
>
> On 7/3/2019 11:15 AM, Andrey Smirnov wrote:
> > Simplify clock initialization code by converting it to use clk-bulk,
> > devres and soc_device_match() match table. No functional change
> > intended.
> >
> > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > Cc: Chris Spencer <christopher.spencer@sea.co.uk>
> > Cc: Cory Tusar <cory.tusar@zii.aero>
> > Cc: Chris Healy <cphealy@gmail.com>
> > Cc: Lucas Stach <l.stach@pengutronix.de>
> > Cc: Horia Geant=C4=83 <horia.geanta@nxp.com>
> > Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
> > Cc: Leonard Crestez <leonard.crestez@nxp.com>
> > Cc: linux-crypto@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >   drivers/crypto/caam/ctrl.c   | 203 +++++++++++++++++-----------------=
-
> >   drivers/crypto/caam/intern.h |   7 +-
> >   2 files changed, 98 insertions(+), 112 deletions(-)
> >
> > diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> > index e674d8770cdb..908d3ecf6d1c 100644
> > --- a/drivers/crypto/caam/ctrl.c
> > +++ b/drivers/crypto/caam/ctrl.c
> > @@ -25,16 +25,6 @@ EXPORT_SYMBOL(caam_dpaa2);
> >   #include "qi.h"
> >   #endif
> >
> > -/*
> > - * i.MX targets tend to have clock control subsystems that can
> > - * enable/disable clocking to our device.
> > - */
> > -static inline struct clk *caam_drv_identify_clk(struct device *dev,
> > -                                             char *clk_name)
> > -{
> > -     return caam_imx ? devm_clk_get(dev, clk_name) : NULL;
> > -}
> > -
> >   /*
> >    * Descriptor to instantiate RNG State Handle 0 in normal mode and
> >    * load the JDKEK, TDKEK and TDSK registers
> > @@ -342,13 +332,6 @@ static int caam_remove(struct platform_device *pde=
v)
> >       /* Unmap controller region */
> >       iounmap(ctrl);
> >
> > -     /* shut clocks off before finalizing shutdown */
> > -     clk_disable_unprepare(ctrlpriv->caam_ipg);
> > -     if (ctrlpriv->caam_mem)
> > -             clk_disable_unprepare(ctrlpriv->caam_mem);
> > -     clk_disable_unprepare(ctrlpriv->caam_aclk);
> > -     if (ctrlpriv->caam_emi_slow)
> > -             clk_disable_unprepare(ctrlpriv->caam_emi_slow);
> >       return 0;
> >   }
> >
> > @@ -497,20 +480,102 @@ static const struct of_device_id caam_match[] =
=3D {
> >   };
> >   MODULE_DEVICE_TABLE(of, caam_match);
> >
> > +struct caam_imx_data {
> > +     const struct clk_bulk_data *clks;
> > +     int num_clks;
> > +};
> > +
> > +static const struct clk_bulk_data caam_imx6_clks[] =3D {
> > +     { .id =3D "ipg" },
> > +     { .id =3D "mem" },
> > +     { .id =3D "aclk" },
> > +     { .id =3D "emi_slow" },
> > +};
> > +
> > +static const struct caam_imx_data caam_imx6_data =3D {
> > +     .clks =3D caam_imx6_clks,
> > +     .num_clks =3D ARRAY_SIZE(caam_imx6_clks),
> > +};
> > +
> > +static const struct clk_bulk_data caam_imx7_clks[] =3D {
> > +     { .id =3D "ipg" },
> > +     { .id =3D "aclk" },
> > +};
> > +
> > +static const struct caam_imx_data caam_imx7_data =3D {
> > +     .clks =3D caam_imx7_clks,
> > +     .num_clks =3D ARRAY_SIZE(caam_imx7_clks),
> > +};
> > +
> > +static const struct clk_bulk_data caam_imx6ul_clks[] =3D {
> > +     { .id =3D "ipg" },
> > +     { .id =3D "mem" },
> > +     { .id =3D "aclk" },
> > +};
> > +
> > +static const struct caam_imx_data caam_imx6ul_data =3D {
> > +     .clks =3D caam_imx6ul_clks,
> > +     .num_clks =3D ARRAY_SIZE(caam_imx6ul_clks),
> > +};
> > +
> > +static const struct soc_device_attribute caam_imx_soc_table[] =3D {
> > +     { .soc_id =3D "i.MX6UL", .data =3D &caam_imx6ul_data },
> > +     { .soc_id =3D "i.MX6*",  .data =3D &caam_imx6_data },
> > +     { .soc_id =3D "i.MX7*",  .data =3D &caam_imx7_data },
> > +     { .family =3D "Freescale i.MX" },
> > +};
>
> You need to add a {/* sentinel */} in caam_imx_soc_table, otherwise will
> crash for other than i.MX targets, when trying to identify the SoC.
>

Ugh, definitely, my bad. Thanks for catching this!

Thanks,
Andrey Smirnov

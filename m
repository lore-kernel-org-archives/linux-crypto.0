Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C01C433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Dec 2020 11:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30DDA23B40
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Dec 2020 11:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730808AbgLILgF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Dec 2020 06:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730807AbgLILgF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Dec 2020 06:36:05 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF6DC0613CF
        for <linux-crypto@vger.kernel.org>; Wed,  9 Dec 2020 03:35:25 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id l200so1354255oig.9
        for <linux-crypto@vger.kernel.org>; Wed, 09 Dec 2020 03:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7QgIXFIx2619+Sv0D1J698p67aLoB7CiWe4qn9IZ9fA=;
        b=QKhW0KHWi8LJUTWN2aJUiGQNl17B5Hcl/5SnQlduWfcuux/p4JOmKHbW51/PUx104E
         1er+gxgaHTpeTpszMGBAAUt1NBd/Nq/WbAns4tmovMzYVNATQWvIWxAWIM4fwZg8CoX3
         u7BUrCOqKBHMpPnpxthyEsjVAW1fbisRYSkmbSeYdA+JBROS/E8dnlT9LhPwnPwAys8C
         JwM58+B+Qe8TJ+UKETWsdgfatco/aDU6nZgS+pdffGM5QX4kpBHRtQq2S4VPfhIHzU0x
         r94L3xjpgEI9l0aZBD+sII8+WUw7z+etENI82niWJMwffOdn7GT2xy518PosBqP6gIrP
         P9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7QgIXFIx2619+Sv0D1J698p67aLoB7CiWe4qn9IZ9fA=;
        b=pNMxVhGD3u1gm4vFRex9uUlhVbFy4tcjh6Ou3vYj+SIyY46zFLltTr6J6w3kOKtMj/
         2a6uDlJgXSny9sQgmdGYg0IqGBquMMgqIg0Tc8o0PJk+PoWt0sRI6P3wguiUTFjiPZOw
         dKfIJ5CXhxNSCZlliGsUc+DgKPFszvhCysHSqbJZP/zTHIN/qzCqy/dR5uxDEMRayjle
         riOifbOl+qnDJqAsg8ndguYazIZjR4362kbS6hi/6WQFgpFHW6dILQW3gxdqXEhzhrG3
         SZJojdqz73YcZtuXjJU94swo099Bpp+PvJfPB5DQ1lhMsiICIvtYB5vimEy7Tds5jq7n
         J9tw==
X-Gm-Message-State: AOAM5337dj/MrtHYlmG8ZhJimN75id9uCwq8lVIniM5Ew3YXXXtvuZsH
        X+Cohe6mlZsopa00aafW24RrA0hcTpZvWzteAmg=
X-Google-Smtp-Source: ABdhPJxo+YAVUJuwUAsAimCGcO4b9d3fGK0RJpNYgt1d85Dc1Zj/oofK7hDBnu/negH78i5muBC1369WD00//6vXU4c=
X-Received: by 2002:a05:6808:685:: with SMTP id k5mr1372009oig.135.1607513724444;
 Wed, 09 Dec 2020 03:35:24 -0800 (PST)
MIME-Version: 1.0
References: <20201207085931.661267-1-allen.lkml@gmail.com> <20201207085931.661267-8-allen.lkml@gmail.com>
 <CAOtvUMeAQYwoB_9jmMdwi8tTYtD8=-r5T7RFTiKgEnDHgkbP+g@mail.gmail.com>
In-Reply-To: <CAOtvUMeAQYwoB_9jmMdwi8tTYtD8=-r5T7RFTiKgEnDHgkbP+g@mail.gmail.com>
From:   Allen <allen.lkml@gmail.com>
Date:   Wed, 9 Dec 2020 17:05:12 +0530
Message-ID: <CAOMdWSKz3+K0fPuiCJN3QxQCY7zYTORF0AhgHeDNrYVLA9puVw@mail.gmail.com>
Subject: Re: [RESEND 07/19] crypto: ccree: convert tasklets to use new
 tasklet_setup() API
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com, jesper.nilsson@axis.com,
        lars.persson@axis.com,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        aymen.sghaier@nxp.com, bbrezillon@kernel.org,
        Arnaud Ebalard <arno@natisbad.org>, schalla@marvell.com,
        Matthias Brugger <matthias.bgg@gmail.com>, heiko@sntech.de,
        krzk@kernel.org, vz@mleia.com, k.konieczny@samsung.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Allen Pais <apais@microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> >
> > Signed-off-by: Romain Perier <romain.perier@gmail.com>
> > Signed-off-by: Allen Pais <apais@microsoft.com>
> > ---
> >  drivers/crypto/ccree/cc_fips.c        |  6 +++---
> >  drivers/crypto/ccree/cc_request_mgr.c | 12 ++++++------
> >  2 files changed, 9 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/crypto/ccree/cc_fips.c b/drivers/crypto/ccree/cc_f=
ips.c
> > index 702aefc21447..bad228a36776 100644
> > --- a/drivers/crypto/ccree/cc_fips.c
> > +++ b/drivers/crypto/ccree/cc_fips.c
> > @@ -109,9 +109,9 @@ void cc_tee_handle_fips_error(struct cc_drvdata *p_=
drvdata)
> >  }
> >
> >  /* Deferred service handler, run as interrupt-fired tasklet */
> > -static void fips_dsr(unsigned long devarg)
> > +static void fips_dsr(struct tasklet_struct *t)
>
> Sorry for the nitpick, but I would really prefer to have a more
> meaningful name for this parameter than just 't'.
>
> tasklet, task, tsk... any descriptive name is fine.
>

 Sure, I will fix it and send out V2.

Thanks.

> >  {
> > -       struct cc_drvdata *drvdata =3D (struct cc_drvdata *)devarg;
> > +       struct cc_drvdata *drvdata =3D from_tasklet(drvdata, t, tasklet=
);
> >         u32 irq, val;
> >
> >         irq =3D (drvdata->irq & (CC_GPR0_IRQ_MASK));
> > @@ -143,7 +143,7 @@ int cc_fips_init(struct cc_drvdata *p_drvdata)
> >         p_drvdata->fips_handle =3D fips_h;
> >
> >         dev_dbg(dev, "Initializing fips tasklet\n");
> > -       tasklet_init(&fips_h->tasklet, fips_dsr, (unsigned long)p_drvda=
ta);
> > +       tasklet_setup(&fips_h->tasklet, fips_dsr);
> >         fips_h->drvdata =3D p_drvdata;
> >         fips_h->nb.notifier_call =3D cc_ree_fips_failure;
> >         atomic_notifier_chain_register(&fips_fail_notif_chain, &fips_h-=
>nb);
> > diff --git a/drivers/crypto/ccree/cc_request_mgr.c b/drivers/crypto/ccr=
ee/cc_request_mgr.c
> > index 33fb27745d52..ec0f3bf00d33 100644
> > --- a/drivers/crypto/ccree/cc_request_mgr.c
> > +++ b/drivers/crypto/ccree/cc_request_mgr.c
> > @@ -70,7 +70,7 @@ static const u32 cc_cpp_int_masks[CC_CPP_NUM_ALGS][CC=
_CPP_NUM_SLOTS] =3D {
> >           BIT(CC_HOST_IRR_REE_OP_ABORTED_SM_7_INT_BIT_SHIFT) }
> >  };
> >
> > -static void comp_handler(unsigned long devarg);
> > +static void comp_handler(struct tasklet_struct *t);
> >  #ifdef COMP_IN_WQ
> >  static void comp_work_handler(struct work_struct *work);
> >  #endif
> > @@ -140,8 +140,7 @@ int cc_req_mgr_init(struct cc_drvdata *drvdata)
> >         INIT_DELAYED_WORK(&req_mgr_h->compwork, comp_work_handler);
> >  #else
> >         dev_dbg(dev, "Initializing completion tasklet\n");
> > -       tasklet_init(&req_mgr_h->comptask, comp_handler,
> > -                    (unsigned long)drvdata);
> > +       tasklet_setup(&req_mgr_h->comptask, comp_handler);
> >  #endif
> >         req_mgr_h->hw_queue_size =3D cc_ioread(drvdata,
> >                                              CC_REG(DSCRPTR_QUEUE_SRAM_=
SIZE));
> > @@ -611,11 +610,12 @@ static inline u32 cc_axi_comp_count(struct cc_drv=
data *drvdata)
> >  }
> >
> >  /* Deferred service handler, run as interrupt-fired tasklet */
> > -static void comp_handler(unsigned long devarg)
> > +static void comp_handler(struct tasklet_struct *t)
> >  {
> > -       struct cc_drvdata *drvdata =3D (struct cc_drvdata *)devarg;
> >         struct cc_req_mgr_handle *request_mgr_handle =3D
> > -                                               drvdata->request_mgr_ha=
ndle;
> > +                               from_tasklet(request_mgr_handle, t, com=
ptask);
> > +       struct cc_drvdata *drvdata =3D container_of((void *)request_mgr=
_handle,
> > +                                    typeof(*drvdata), request_mgr_hand=
le);
> >         struct device *dev =3D drvdata_to_dev(drvdata);
> >         u32 irq;
> >
> > --
> > 2.25.1
> >
>
> Other than that it looks good to me.
>
> Thanks,
> Gilad
>
> --
> Gilad Ben-Yossef
> Chief Coffee Drinker
>
> values of =CE=B2 will give rise to dom!



--=20
       - Allen

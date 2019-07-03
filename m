Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C6DC0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 17:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D0EF21881
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 17:14:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UX5GJ5a3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfGCROv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 13:14:51 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45441 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfGCROv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 13:14:51 -0400
Received: by mail-io1-f68.google.com with SMTP id e3so6202661ioc.12;
        Wed, 03 Jul 2019 10:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nh9dEJ9u2Y4ShTiHFYbydyiw3WYwXZ47VJXMaHvlETk=;
        b=UX5GJ5a3W8vnXqaG6bYQid9Tk2rxUC2cxFyHfISjXfw3xZRhBp7g5yal7gmi6b+6bi
         2OLiaKbvjjNWqKVDRvxuLXZeTzOAx7XWNj4cscpT5PGP01nMamx5ZgU+H3IJCmIBzqDU
         KgQXltDjEnYoX2BhQEahn5u43RU8j9EqAdsuofkq42ucH0lBO56IHtRvRphjKhqKzVoQ
         9fShBsIyuPVasNQazC/c6i/B7Xou5NXhw9stdppSWRzSsuZsL3sewE8at0IeHbRAE/Pe
         bYVRthrz3Rfw4iYDW5dX4GLX1rf3ctOZdw1gLtCF2Rxca41XJjSpReslNoHg9O0h4rBq
         sSXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nh9dEJ9u2Y4ShTiHFYbydyiw3WYwXZ47VJXMaHvlETk=;
        b=Sf5AYg6N1HXJhPATSZu5PO02y25DkQaU2rukL1Wom47pG2llUUDi8UNgeftCrKR+wD
         FOFHuAeQTCtEuF8hm0dPWOqwLDm3FvXyKpILA7AqbTcQlGlirmWB3DmTsPN5sYFMEHdV
         7g5Pz56wV4Q/GUcwBXmrI+st8rKCXK13Bz8VGi41cBs1jhFihOXBItr5fMd5bhsqcbzU
         6CbAjAx6TeFijKOK5yjMw1y6zywyd1N7xSnK0Jtzbl2z0XiD+tuN76tM4EKrpBfnpeJ7
         DC1Pz+VLtO/HlPyCm2gi3Dpj23QYibogykhFwFvdLNYK1OA0vCGJzLJg8d5qeKxPEEN6
         y1sQ==
X-Gm-Message-State: APjAAAX72VWkPG5O3xQ1K6ES4RhLIw5UxfS4dEjXVshqhwoFvDfWaIk3
        1cBKpiSnZekyG4jrmM+0RDiREdGcJFRfsFeh7Vo=
X-Google-Smtp-Source: APXvYqzxSGfndHH5s8QQP6JMhmrjCfpxwk4akPLDTwdab+2QJvkTvQ8scvf2HrUvngz2nLIFp8dcUZexpefSjuHWDW8=
X-Received: by 2002:a02:8814:: with SMTP id r20mr45482735jai.115.1562174090222;
 Wed, 03 Jul 2019 10:14:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190703081327.17505-1-andrew.smirnov@gmail.com>
 <20190703081327.17505-4-andrew.smirnov@gmail.com> <VI1PR04MB505565EC5520F4820E234A84EEFB0@VI1PR04MB5055.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB505565EC5520F4820E234A84EEFB0@VI1PR04MB5055.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Wed, 3 Jul 2019 10:14:38 -0700
Message-ID: <CAHQ1cqHfBU92g-P7jDfiWtEr0m-kv5Lw9yZcvUEXYg7OyhURfg@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] crypto: caam - move tasklet_init() call down
To:     Leonard Crestez <leonard.crestez@nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
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

On Wed, Jul 3, 2019 at 6:51 AM Leonard Crestez <leonard.crestez@nxp.com> wrote:
>
> On 7/3/2019 11:14 AM, Andrey Smirnov wrote:
> > Move tasklet_init() call further down in order to simplify error path
> > cleanup. No functional change intended.
> >
> > diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> > index 4b25b2fa3d02..a7ca2bbe243f 100644
> > --- a/drivers/crypto/caam/jr.c
> > +++ b/drivers/crypto/caam/jr.c
> > @@ -441,15 +441,13 @@ static int caam_jr_init(struct device *dev)
> >
> >       jrp = dev_get_drvdata(dev);
> >
> > -     tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);
> > -
> >       /* Connect job ring interrupt handler. */
> >       error = request_irq(jrp->irq, caam_jr_interrupt, IRQF_SHARED,
> >                           dev_name(dev), dev);
> >       if (error) {
> >               dev_err(dev, "can't connect JobR %d interrupt (%d)\n",
> >                       jrp->ridx, jrp->irq);
> > -             goto out_kill_deq;
> > +             return error;
> >       }
>
> The caam_jr_interrupt handler can schedule the tasklet so it makes sense
> to have it be initialized ahead of request_irq. In theory it's possible
> for an interrupt to be triggered immediately when request_irq is called.
>
> I'm not very familiar with the CAAM ip, can you ensure no interrupts are
> pending in HW at probe time? The "no functional change" part is not obvious.
>

Said tasklet will use both jrp->outring and jrp->entinfo array
initialized after IRQ request call in both versions of the code
(before/after this patch). AFAICT, the only case where this patch
would change initialization safety of the original code is if JR was
scheduled somehow while ORSFx is 0 (no jobs done), which I don't think
is possible.

Thanks,
Andrey Smirnov

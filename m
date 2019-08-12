Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19EF8C433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 18:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD811206C2
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 18:00:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XB3wyrg/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfHLSAJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 14:00:09 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37795 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbfHLSAJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 14:00:09 -0400
Received: by mail-ot1-f65.google.com with SMTP id f17so26800511otq.4;
        Mon, 12 Aug 2019 11:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fGpuQrmzy1FwsMj9TWHIASi6W9ylGMJSZYJThCVeJRs=;
        b=XB3wyrg/V5N1EHWm7v0n8Sh0CJ8wyH2LjlBLunj2JehIwNDmpUeAWK15ucBjUGy8Km
         sR7ut9SSNvpGY/zJ734FVCR5WgLMbSOh34j+z7kwkWShV2+IMofxiJlFDGMGjsF7L0cf
         eK15o16mTTFxFRp1T5uRrsW2o/1FcSfMWFz+FFo0WvPMB1GzjEf58j9xoMzqwmTr/EwC
         W/GnmI6HLiJWSq7+qdc7pZMdiNC9yQcsuQLt/UG9Y9H8dR9Fk97XawSQmndTAEMSAvNc
         CWyqL1ORXQxQusypiF4jmj9pMS2xxmLheMOpKULEVq9YrinTI0nz6gJPdaBBv91VkKHM
         YvzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fGpuQrmzy1FwsMj9TWHIASi6W9ylGMJSZYJThCVeJRs=;
        b=cSdbmiOaIqe+84PgvtJsyDl3LGzfiVUDVIUdezVw3jWULkdrdEnOtWgeA2Whd9/w7x
         fbaxOIF0k8qSQai7ebjl9gG99iPbNF8cDuGSTvObQh4BYaR1ibKao62UFfJY0RCkflFQ
         P4Y482YKP9rCKlUBLFUMjRAOzuFomRK9be76Ga1RfRVViZ/f0GQJDPMkQQCmA4/KFQjB
         3sYj+wvIfKSXAcpbddnV2VwqP3sUJ+LQ46XmrNNwMYyiWQ1bDoVm8BrZhGO8NWBEoW+b
         U0WAdFjlyNx9Au5ZtQYdUNugC636uGaOL6DEjHHjIRz66JujiJ9q8Q7QFCbI4Ijrnf9l
         3+MA==
X-Gm-Message-State: APjAAAU2a+inJ+7p/tuA9aRuqxcysnHm2sEScXdteCsk3CdgzMl7dDLg
        pSaBCpBkcdrmuMTnMpsN0xpxXh00bCkJrhXhrMw=
X-Google-Smtp-Source: APXvYqyssTKPXbJDSlF9l6L93EOn6Pvx11xwGZ+Lev+PZBmup9Uh5e7i7z/YF0ouyQXSq4LZoqtJDNNWy5G99o/EwUw=
X-Received: by 2002:a5e:8a48:: with SMTP id o8mr26890028iom.287.1565632808028;
 Mon, 12 Aug 2019 11:00:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
 <20190717152458.22337-5-andrew.smirnov@gmail.com> <VI1PR0402MB34854421031A02B1AE3F953098C70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB34854421031A02B1AE3F953098C70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 12 Aug 2019 10:59:56 -0700
Message-ID: <CAHQ1cqEhS+rSW7avtP5Yt5o+6AH2wPzXCxpqKW9J7U6k7FMOBA@mail.gmail.com>
Subject: Re: [PATCH v6 04/14] crypto: caam - request JR IRQ as the last step
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 23, 2019 at 9:02 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 7/17/2019 6:25 PM, Andrey Smirnov wrote:
> > In order to avoid any risk of JR IRQ request being handled while some
> > of the resources used for that are not yet allocated move the code
> > requesting said IRQ to the endo of caam_jr_init(). No functional
>                              ^ typo
> > change intended.
> >
> What qualifies as a "functional change"?
> I've seen this comment in several commits.
>

My intent was to mark refactoring only changes as such. Probably not
appropriate for this commit. Will drop in v7.

> >       error = caam_reset_hw_jr(dev);
> >       if (error)
> > -             goto out_kill_deq;
> > +             return error;
> >
> >       error = -ENOMEM;
> >       jrp->inpring = dmam_alloc_coherent(dev, sizeof(*jrp->inpring) *
> >                                          JOBR_DEPTH, &inpbusaddr,
> >                                          GFP_KERNEL);
> >       if (!jrp->inpring)
> > -             goto out_kill_deq;
> > +             return -ENOMEM;
> Above there's "error = -ENOMEM;", so why not "return err;" here and
> in all the other cases below?
>

I was going to remove that "error = -ENOMEM;", but forgot. Will do in v7.

> >
> >       jrp->outring = dmam_alloc_coherent(dev, sizeof(*jrp->outring) *
> >                                          JOBR_DEPTH, &outbusaddr,
> >                                          GFP_KERNEL);
> >       if (!jrp->outring)
> > -             goto out_kill_deq;
> > +             return -ENOMEM;
> >
> >       jrp->entinfo = devm_kcalloc(dev, JOBR_DEPTH, sizeof(*jrp->entinfo),
> >                                   GFP_KERNEL);
> >       if (!jrp->entinfo)
> > -             goto out_kill_deq;
> > +             return -ENOMEM;
> >
> >       for (i = 0; i < JOBR_DEPTH; i++)
> >               jrp->entinfo[i].desc_addr_dma = !0;
> > @@ -483,10 +472,19 @@ static int caam_jr_init(struct device *dev)
> >                     (JOBR_INTC_COUNT_THLD << JRCFG_ICDCT_SHIFT) |
> >                     (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
> >
> > +     tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);
> > +
> > +     /* Connect job ring interrupt handler. */
> > +     error = devm_request_irq(dev, jrp->irq, caam_jr_interrupt, IRQF_SHARED,
> > +                              dev_name(dev), dev);
> > +     if (error) {
> > +             dev_err(dev, "can't connect JobR %d interrupt (%d)\n",
> > +                     jrp->ridx, jrp->irq);
> > +             tasklet_kill(&jrp->irqtask);
> > +             return error;
> "return error;" should be moved out the if block.
>

Sure, will do in v7.

Thanks,
Andrey Smirnov

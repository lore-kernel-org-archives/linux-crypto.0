Return-Path: <SRS0=ZPwR=WJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B800C32750
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 18:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0348E2054F
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 18:50:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tFi1hOTN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfHMSuq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Aug 2019 14:50:46 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38026 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfHMSup (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Aug 2019 14:50:45 -0400
Received: by mail-ot1-f67.google.com with SMTP id r20so26590243ota.5;
        Tue, 13 Aug 2019 11:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NHzbEGdc+m7R0uItpjFfL5xI7qf8YOLbAGx8I9P0xM4=;
        b=tFi1hOTN/g0N4nYbGmv16uNB1sJlgBLsRyxyOcrXliBsxx0a0+FKKKERtj9BDGi4D4
         cg4XfUACWDQ8nmML0RdtB+TUbEiVlDpE4giTFY3EZSoFBibg3BbQ2mInYsoA1F9GFhOH
         +JhlPlwOivxI/72ol9nbtzi5zBrxkKy1nlkWqSUT2W3fHAWbupS0ZYeWS1azxTspM/Xj
         58hiJUAQz4QB9ZbKO+AZno1V/lJbmcN5L2lJR3GHzENOeacxigv6WdNJUnSGbhAeSu2b
         FDIRfdsACp14MStRCVhie1IUHs6qsLyeeqEQzhHPpC/6tjB6RvBCdMqDIJ72zZKkpJtu
         lENg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NHzbEGdc+m7R0uItpjFfL5xI7qf8YOLbAGx8I9P0xM4=;
        b=f+8JXHzvGz/jv5gj4y/mo/kMGgiGKv/VAE6FcfjU9tvScjN/DgfdWQYi/q/lZZ8p/r
         RlBNc27gF8k2+Ms+PUCjFEtMcqNqlAJqyNCTTD3xzG0A7NoDg8yDzp61442WtylawOTZ
         UFtL02Mq/vF8sk+BTQN5IxsFLe1jU/NiOMKZiJYHKc+0Ae+ypDo6W2/IEdl216B9HLru
         aecZkLqWJ2XykLX35JgavLkFhJcbq1BEGX8tUmhSu93QxR4RjC1DAN35Lg7ux4MjCX2A
         ey9KMfEBvAp2oe76H5Q+0br/Di+2vIgkGcr8I9kXzGnNBlrQhpJuQ0UeXommuLDvUYBK
         7Sbg==
X-Gm-Message-State: APjAAAX9Sxep+bdVogxTOz6eUbY7lm81ZkwBCH+qnuDMxj8EfuzSpiR/
        z1hF7vaTWacUtGkwla+t/F9PA4+614etup1wC9s=
X-Google-Smtp-Source: APXvYqwAxlPUcfHt3Cl4V2jTRcAnGGDPbRirnOjYgD6lQETWjM7nhi/2p7Hs5DRVY5l0F7oDTWhEvVBZ8KdooWqpW1g=
X-Received: by 2002:a6b:4107:: with SMTP id n7mr16705742ioa.12.1565722244792;
 Tue, 13 Aug 2019 11:50:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
 <20190717152458.22337-13-andrew.smirnov@gmail.com> <VI1PR0402MB348580480F5EAF5F539B585A98DA0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAHQ1cqEiCkXP+-w9WUc33oW6vDhHza2Jq_kQsXjKZ+__T5g77g@mail.gmail.com> <VI1PR0402MB3485AE1FD97765AF1D43BAF298D20@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485AE1FD97765AF1D43BAF298D20@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Tue, 13 Aug 2019 11:50:33 -0700
Message-ID: <CAHQ1cqGdT8Td_1iDCKuCazti53hCJ9HC3-mJMCo+g6FzZBnEOw@mail.gmail.com>
Subject: Re: [PATCH v6 12/14] crypto: caam - force DMA address to 32-bit on
 64-bit i.MX SoCs
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

On Tue, Aug 13, 2019 at 6:38 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 8/12/2019 10:27 PM, Andrey Smirnov wrote:
> > On Mon, Aug 5, 2019 at 1:23 AM Horia Geanta <horia.geanta@nxp.com> wrote:
> >>
> >> On 7/17/2019 6:25 PM, Andrey Smirnov wrote:
> >>> @@ -603,11 +603,13 @@ static int caam_probe(struct platform_device *pdev)
> >>>               ret = init_clocks(dev, ctrlpriv, imx_soc_match->data);
> >>>               if (ret)
> >>>                       return ret;
> >>> +
> >>> +             caam_ptr_sz = sizeof(u32);
> >>> +     } else {
> >>> +             caam_ptr_sz = sizeof(dma_addr_t);
> >> caam_ptr_sz should be deduced by reading MCFGR[PS] bit, i.e. decoupled
> >> from dma_addr_t.
> >>
> >
> > MCFGR[PS] is not mentioned in i.MX8MQ SRM and MCFG_PS in CTPR_MS is
> > documented as set to "0" (seems to match in real HW as well). Doesn't
> > seem like a workable solution for i.MX8MQ. Is there something I am
> > missing?
> >
> If CTPR_MS[PS]=0, this means CAAM does not allow choosing the "pointer size"
> via MCFGR[PS]. Usually in this case the RM does not document MCFGR[PS] bit,
> which is identical to MCFGR[PS]=0.
>
> Thus the logic should be smth. like:
>         caam_ptr_sz = CTPR_MS[PS] && MCFGR[PS] ? 64 : 32;
>

Where is PS located in MCFGR? Same as in CTPR_MS, i.e. BIT(17)?

> >> There is another configuration that should be considered
> >> (even though highly unlikely):
> >> caam_ptr_sz=1  - > 32-bit addresses for CAAM
> >> CONFIG_ARCH_DMA_ADDR_T_64BIT=n - 32-bit dma_addr_t
> >> so the logic has to be carefully evaluated.
> >>
> >
> > I don't understand what you mean here. 32-bit CAAM + 32-bit dma_addr_t
> > should already be the case for i.MX6, etc. how is what you describe
> > different?
> >
> Sorry for not being clear.
>
> caam_ptr_sz=1  - > 32-bit addresses for CAAM
> should have been
> caam_ptr_sz=*64*  - > 32-bit addresses for CAAM
> i.e. CAAM address has "more than" (>) 32 bits (exact number of bits is
> SoC / chassis specific) and thus will be represented on 8 bytes.
>

Ah, I see. Can this use-case be addressed in a separate series when
the need for it arises?

Thanks,
Andrey Smirnov

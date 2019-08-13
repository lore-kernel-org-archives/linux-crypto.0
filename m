Return-Path: <SRS0=ZPwR=WJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FCBC433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 18:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A41FC2054F
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 18:51:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kl/pWKzV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfHMSvY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Aug 2019 14:51:24 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40666 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfHMSvY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Aug 2019 14:51:24 -0400
Received: by mail-ot1-f66.google.com with SMTP id c34so36440461otb.7;
        Tue, 13 Aug 2019 11:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b1Ocmmg17vAyCpqu4Pu+8MBoc/VHasvcMG1VyB/RThs=;
        b=kl/pWKzVWrAM3hq5DLpwHsChhKvxHCarJXzH6axT6D8KRc/19ZOylq6+pbUoIteIVZ
         NvwoeCJj2MIhFXlf3P2ZwKQ2HNQTXagCTP0la2BKMF5H0v+9S1ZIpoinfdVj7oAOXiGi
         EtyvdvAirIXXGBpTnMgooFBLvFW9y6qHWDt8GioIMKz2D4Xj/LirZoAxHiAAYMOGpCZm
         FSJopc8e/fmopdC3W1WSVI5GFE5dfdjCbjdsqu/qNOayVE5sZLrnJDCRcteBiYH2vKCa
         +vOFEetu2aKH0XvDjGh8OLlpbUWwAryj4nOfhmeuMXN0QXLD9evazJ0zIB4SDx+KxZan
         i4qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b1Ocmmg17vAyCpqu4Pu+8MBoc/VHasvcMG1VyB/RThs=;
        b=T7HF48qQIzMhbDT59XZK06spW5bbPeLoaj4lvOFMicgecj+MLqzaQY9YUl61vbCd0X
         L3ZaK9UL9KFaDHIq5ppNhXdj7BPqiT68gLgg9ls68GcxeBBihtQ8tUca1sI3oncdC01C
         Bp0S0trKS88KJ0uTmJUz3g9gEsSRC6qxAW3mFIpZlipHAwRQf9XOKu8sGbGGLRCeSl0m
         nvJAJY+xtDSm8DfeCUCpoE7BEUksqkr9XGhB/RUPdkPnQ8houQnC4X2ommbFWUk4OIJd
         30QUmih4Ij9L5x3dtlc3ummryRbRkD21jf9LBB9aJ7ZGFj0kdClO3WXBM5K4ga2eWrPe
         Sg0g==
X-Gm-Message-State: APjAAAWrFgYm+1gNZytJaNsL/nwcrCmjwtJ0IaXKRGaQq6ETgiNtRPgu
        gXZZmEOMeNvAO1m4qXBuCIxyvNJAulgelcTHGy0=
X-Google-Smtp-Source: APXvYqy4ljRyrVOBed//32I64TnhVm+nXcOSRZoCJhp4ZSA9RJmbXxUcaD9xylbf2jl8UnB/UTqAKzxaostDKTz5j6c=
X-Received: by 2002:a6b:f607:: with SMTP id n7mr27088775ioh.263.1565722283708;
 Tue, 13 Aug 2019 11:51:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190812200739.30389-1-andrew.smirnov@gmail.com> <VI1PR0402MB34857B6486BDFE28B75A642398D20@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB34857B6486BDFE28B75A642398D20@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Tue, 13 Aug 2019 11:51:11 -0700
Message-ID: <CAHQ1cqE1UOaWUghuFC69+LVGZcp3TiV4uNPCS=86KMroEWrZcg@mail.gmail.com>
Subject: Re: [PATCH v7 00/15] crypto: caam - Add i.MX8MQ support
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

On Tue, Aug 13, 2019 at 6:59 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 8/12/2019 11:08 PM, Andrey Smirnov wrote:
> > Everyone:
> >
> > Picking up where Chris left off (I chatted with him privately
> > beforehead), this series adds support for i.MX8MQ to CAAM driver. Just
> > like [v1], this series is i.MX8MQ only.
> >
> > Feedback is welcome!
> > Thanks,
> > Andrey Smirnov
> >
> > Changes since [v6]:
> >
> >   - Fixed build problems in "crypto: caam - make CAAM_PTR_SZ dynamic"
> >
> >   - Collected Reviewied-by from Horia
> >
> >   - "crypto: caam - force DMA address to 32-bit on 64-bit i.MX SoCs"
> >     is changed to check 'caam_ptr_sz' instead of using 'caam_imx'
> >
> >   - Incorporated feedback for "crypto: caam - request JR IRQ as the
> >     last step" and "crypto: caam - simplfy clock initialization"
> >
> FYI - the series does not apply cleanly on current cryptodev-2.6 tree.
>

OK, sorry about that, will fix.

Thanks,
Andrey Smirnov

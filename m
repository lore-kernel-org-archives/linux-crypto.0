Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB4CDC31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 16:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC7D221019
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 16:28:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NJy20Mnq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502132AbfFLQ26 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 12:28:58 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:35739 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502128AbfFLQ26 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 12:28:58 -0400
Received: by mail-it1-f195.google.com with SMTP id n189so11579265itd.0;
        Wed, 12 Jun 2019 09:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yATkbjTw8m3Q2dRPh5UAzdwM9szsemwHSJzk0zw5vRI=;
        b=NJy20Mnqfu+Z39JVh+cD+rlnma0I6e0xYfIA6aMB86ck/8gq0ulfhoZuq50qFwrPjp
         YpKU/FucIoUuzRYZBuWq/qrB7YbnqLf/E0CAeqUQoMjcBnZ5YL4pKqGx2Y5Nda09727g
         okaSOVQ2IXunryTsYPSHYNJOHygLR3NZjF65121kpqkwqvSkFA0X4UsF75X7GjCdX3Cx
         0yKoADdNzJm9pJjf0w4lyF3joG64/G+46n+aOxRS2U/sCcl/AztvAc13IVzrqRYASdM6
         fwWD98c1SnsDyEGk+qZx3LXBk36NRosoeBukK8ohbPb3XYncV+zpmtf6vGlTzgesDLbR
         ZIZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yATkbjTw8m3Q2dRPh5UAzdwM9szsemwHSJzk0zw5vRI=;
        b=iIchdfm+/gMYv8AkV0JOyeWJFxlJ6OCnk0i8oNFa5noSpEAalw1XnjTxDDWFGHtTJp
         YEsA0QjNxnTYp76ApTqQVvOP9/Ms42Vp6AEuhXecYAFs/XEP/oSo2PvgCU4dq2OHtLiJ
         WP3gwDMYuKe6WJEJ7qmA85Nww3xHZBZI1/ZorQz0o1qJSp5ZyO4Ew9eo2uLP2tULb6X3
         QJqza7L6K8SsjfWQJj/0TS2Fk6Hjk4ef2erc9Uv9dp5c6ikNcudELtHwl+/X2I90jECd
         jlRaYZdsxmgnTWsz7nFm/JWMyhPkftlbvvpKs2cRZ+gyVaXTn3Vel069oP6xbNk06Qcm
         6pYQ==
X-Gm-Message-State: APjAAAUB3qB9YaNLAbDcrTp08DGN5fsGnDTRWgeCbhLQjmEPPB06GGa3
        NJcqJ04w/7AW98vSjOd9xc4OG18t8By9W1Dw5UE=
X-Google-Smtp-Source: APXvYqyFy2pdIz1NIdWEELkm+gtHMFJN4Sd8HaM3yVeRCc656dsv6Qlh7LAzwGcFw1K4ggW00KmzMxZsCUTJRrfmunM=
X-Received: by 2002:a02:3b62:: with SMTP id i34mr50167719jaf.91.1560356937141;
 Wed, 12 Jun 2019 09:28:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190607200225.21419-1-andrew.smirnov@gmail.com>
 <20190607200225.21419-2-andrew.smirnov@gmail.com> <VI1PR04MB50558864B434388A52A00915EEEC0@VI1PR04MB5055.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB50558864B434388A52A00915EEEC0@VI1PR04MB5055.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Wed, 12 Jun 2019 09:28:45 -0700
Message-ID: <CAHQ1cqHw4whpq9Q0hNOrh4Q-72dxQVoNqJ-VEk9g7ZMimNTCkg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] crypto: caam - do not initialise clocks on the i.MX8
To:     Leonard Crestez <leonard.crestez@nxp.com>
Cc:     Chris Spencer <christopher.spencer@sea.co.uk>,
        Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 12, 2019 at 6:53 AM Leonard Crestez <leonard.crestez@nxp.com> wrote:
>
> On 07.06.2019 23:03, Andrey Smirnov wrote:
>
> > There are no clocks that the CAAM driver needs to initialise on the
> > i.MX8.
>
> The clk handling inside CAAM is very convoluted and this patch doesn't
> help. All the driver actually does is "enable all required clocks", this
> shouldn't be complicated.
>

As I mentioned before, this patch is now dropped. It is replaced with
a one-liner to avoid requesting "emi_slow" clock on i.mx8mq.

> I propose adding a const caam_soc_data struct which has a bool flag
> marking if each clock is required or not, the replace all the
> of_machine_is_compatible() logic with statements of the form:
>
> if (ctrlpriv->soc_data->need_ipg_clk)
>      ctrlpriv->caam_ipg = devm_clk_get("ipg");
>
> You could even make all clks optional and claim that if a clk is not
> listed in DT then it's assumed to be always on. However that means that
> on some SOCs if DT is incorrect you can get a hang (due to missing clk)
> instead of a probe error.
>

I agree with this approach in principle, but I'd rather focus this
series on adding i.MX8MQ support with least amount changes needed. I
have a separate series doing a bunch of devres related cleanup on this
driver, which I plan to submit once i.MX8MQ is supported and we can
(and I'd rather) address the problem there.

> > +     clk_disable_unprepare(ctrlpriv->caam_ipg);
> > +     if (ctrlpriv->caam_mem)
> > +             clk_disable_unprepare(ctrlpriv->caam_mem);
> > +     clk_disable_unprepare(ctrlpriv->caam_aclk);
> > +     if (ctrlpriv->caam_emi_slow)
> > +             clk_disable_unprepare(ctrlpriv->caam_emi_slow);
>
> Clock APIs have no effect if clk argument is NULL, please just drop
> these if statements.

As a part of my refactoring changes I replaced all of that code with
devres, so it should already be addressed there.

Thanks,
Andrey Smirnov

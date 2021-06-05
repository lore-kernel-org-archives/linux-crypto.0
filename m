Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03560C47082
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Jun 2021 08:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D686460D07
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Jun 2021 08:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhFEI2r (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Jun 2021 04:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhFEI2r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Jun 2021 04:28:47 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D21BC061767
        for <linux-crypto@vger.kernel.org>; Sat,  5 Jun 2021 01:27:00 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id v27-20020a056830091bb02903cd67d40070so8376466ott.1
        for <linux-crypto@vger.kernel.org>; Sat, 05 Jun 2021 01:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HKyUqf7NI2Yuw0Cm11CrEyV9uYKyJhwCEAKigEKJNJ8=;
        b=ZS6EUPMoBJoX6MkxGQ9BXtnrqLzaWaesaMMxH99UlWaxLN0dTg8LcmeGrxD5kWX0OT
         RL+cn0uTJqQmllPGzucLq8e/7lvwU4XSeiaX4MMIZSFLeODXFvXfENBjbp70qDH7lTiF
         65bdM67WQJwnlcr//9cu38chzebttAT4TXJA3BA0A8+IJjo2v2xqG6KBwB769tFB8UK7
         sp7L7k3FWnKHFS4Gguj+Vb57YMMQr4R6ptKeW0MKZqDgQz1F+w13d37fdO7wQQMsg89k
         e0hXbn5vaHyz1AHDz0vVS+SdXyir9I/k+ueh88t33DXZub8SPyqQWaMuBRc4zmEbkH2n
         4uMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HKyUqf7NI2Yuw0Cm11CrEyV9uYKyJhwCEAKigEKJNJ8=;
        b=OC7GQ1HFJ2vsTKV80DGRChkZ6VBR1LvFjhemTpwnMJb4PERtHt4cUsyJpJp5j/qxvI
         ch8WHTLCBr5ewTcgf25dsJfMzKMzsWbB+sHV+VpqmiFth04wo/Dj8Lew0aZa7Swz25iG
         8kyKdKV3h5VAeEmCuRrGaGr/htybmeW+QqJ9PcAibdd65DgNHKkuhu1AVcCGsUKK4nd0
         P7pVVSnOf/FIO7IF5SL//JM9t3/SHHzIKYWPcKdJxNYVqiAsLRSGQNJIXTHmoewc0/a9
         6IauzjayTd+AhkPaYD1rxs1xHs8fXX9YSCg/BBIBAwRfse4Q/xFGnues2v0l9nbsSe7d
         361A==
X-Gm-Message-State: AOAM5301uIe97Yu7wPlME9Uy0QUY6qhVrnIeqLxGv+VIqApRJ7aY+X8T
        avFGudSfUg/O9EkcomTYpqIqswiYqYCO63oJhoTFkA==
X-Google-Smtp-Source: ABdhPJxnmzc/8hxfB8fveUdflIof7ixtQvUsNexucCkGmlOQVpwJQn70pCPp044bin6dr/pH+6DjV0HdWVtuhUOPgQg=
X-Received: by 2002:a9d:7982:: with SMTP id h2mr742263otm.51.1622881619504;
 Sat, 05 Jun 2021 01:26:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210519143700.27392-1-bhupesh.sharma@linaro.org>
 <20210519143700.27392-17-bhupesh.sharma@linaro.org> <ca0e576d-0231-d1a8-06c5-e85f0706c993@linaro.org>
In-Reply-To: <ca0e576d-0231-d1a8-06c5-e85f0706c993@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Sat, 5 Jun 2021 13:56:48 +0530
Message-ID: <CAH=2NtwuPP+qAidYKJ6i_iQg1VMtPS6xeGvnSKcNE0pf0HqcNQ@mail.gmail.com>
Subject: Re: [PATCH v3 16/17] crypto: qce: Defer probing if BAM dma channel is
 not yet initialized
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhupesh.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Thara,

Thanks for the review and sorry for the late reply.

On Fri, 21 May 2021 at 07:27, Thara Gopinath <thara.gopinath@linaro.org> wrote:
>
>
>
> On 5/19/21 10:36 AM, Bhupesh Sharma wrote:
> > Since the Qualcomm qce crypto driver needs the BAM dma driver to be
> > setup first (to allow crypto operations), it makes sense to defer
> > the qce crypto driver probing in case the BAM dma driver is not yet
> > probed.
> >
> > Move the code leg requesting dma channels earlier in the
> > probe() flow. This fixes the qce probe failure issues when both qce
> > and BMA dma are compiled as static part of the kernel.
>
> So, I do not understand what issue you faced with the current code
> ordering. When bam dma is not initialized, qce_dma_request will fail and
> rest the error path kicks in.
> To me the correct ordering for enabling a driver is to turn on clocks
> and interconnect before requesting for dma. Unless, there is a specific
> issue, I will ask for that order to be maintained.

Sure. The problem I faced was the following. Let's consider the
scenario where while the qce crypto driver and the interconnect are
compiled as static parts of the kernel, the bam DMA driver is compiled
as a module, then the -EPROBE_DEFER return leg from the qce crypto
driver is very late in the probe() flow, as we first turn on the
clocks and then the interconnect.

Now the suggested linux deferred probe implementation is to return as
early from the caling driver in case the called driver (subdev) is not
yet ready. SInce the qce crypto driver requires the bam DMA to be set
up first, it makes sense to move 'qce_dma_request' early in the boot
flow. If it's not yet probed(), it probably doesn't make sense to set
up the clks and interconnects yet in the qce driver. We can do it
later when the bam DMA is setup.

I have tested the following combinations with the change I made in
this patchset:

1. qce - static, bam - module, interconnect - module ->
qce_dma_request returned -EPROBE_DEFER
2. qce - static, bam - module, interconnect - static ->
qce_dma_request returned -EPROBE_DEFER
3. qce - static, bam - static, interconnect - module ->
qce_dma_request returned -EPROBE_DEFER
4. qce - static, bam - static, interconnect - static -> no -EPROBE_DEFER

Thanks,
Bhupesh

> > Cc: Thara Gopinath <thara.gopinath@linaro.org>
> > Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: Andy Gross <agross@kernel.org>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Stephen Boyd <sboyd@kernel.org>
> > Cc: Michael Turquette <mturquette@baylibre.com>
> > Cc: Vinod Koul <vkoul@kernel.org>
> > Cc: dmaengine@vger.kernel.org
> > Cc: linux-clk@vger.kernel.org
> > Cc: linux-crypto@vger.kernel.org
> > Cc: devicetree@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: bhupesh.linux@gmail.com
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > ---
> >   drivers/crypto/qce/core.c | 16 +++++++++-------
> >   1 file changed, 9 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> > index 8b3e2b4580c2..207221d5b996 100644
> > --- a/drivers/crypto/qce/core.c
> > +++ b/drivers/crypto/qce/core.c
> > @@ -218,6 +218,14 @@ static int qce_crypto_probe(struct platform_device *pdev)
> >       if (ret < 0)
> >               goto err_out;
> >
> > +     /* qce driver requires BAM dma driver to be setup first.
> > +      * In case the dma channel are not set yet, this check
> > +      * helps use to return -EPROBE_DEFER earlier.
> > +      */
> > +     ret = qce_dma_request(qce->dev, &qce->dma);
> > +     if (ret)
> > +             return ret;
> > +
> >       qce->mem_path = devm_of_icc_get(qce->dev, "memory");
> >       if (IS_ERR(qce->mem_path))
> >               return dev_err_probe(dev, PTR_ERR(qce->mem_path),
> > @@ -269,10 +277,6 @@ static int qce_crypto_probe(struct platform_device *pdev)
> >                       goto err_clks_iface;
> >       }
> >
> > -     ret = qce_dma_request(qce->dev, &qce->dma);
> > -     if (ret)
> > -             goto err_clks;
> > -
> >       ret = qce_check_version(qce);
> >       if (ret)
> >               goto err_clks;
> > @@ -287,12 +291,10 @@ static int qce_crypto_probe(struct platform_device *pdev)
> >
> >       ret = qce_register_algs(qce);
> >       if (ret)
> > -             goto err_dma;
> > +             goto err_clks;
> >
> >       return 0;
> >
> > -err_dma:
> > -     qce_dma_release(&qce->dma);
> >   err_clks:
> >       clk_disable_unprepare(qce->bus);
> >   err_clks_iface:
> >
>
>

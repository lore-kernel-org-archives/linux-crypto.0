Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B417C433FE
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Oct 2021 13:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E971B60FBF
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Oct 2021 13:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhJXNzY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Oct 2021 09:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhJXNzX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Oct 2021 09:55:23 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE77C061764
        for <linux-crypto@vger.kernel.org>; Sun, 24 Oct 2021 06:53:02 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id g125so11839463oif.9
        for <linux-crypto@vger.kernel.org>; Sun, 24 Oct 2021 06:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x+Jl0hYAJo4q4OVBu8UADJo86vPV7s9MdDgSLack3Ms=;
        b=KaFhuHL+6HbA4J0fnTUq2UD/GB9EhCiJkFWSj/mkmbIpM8NpSZt8oHwR30syZ9f+Bd
         X0DMniHP66b8er4+4kRj+DMWnQ7X/W3Vnn9hrQcoa+ZHhm8pnOE/nTYze+hHGsaTOvEH
         hf9cDH/hhGRctA4Myyl3jn02jSnI8ZkF9owHNSLQI4MnWF5ljtbBMzckVQ1KYIjhYM8+
         XT91+3d+En3RyxzcYcproCAnvnuMmF2LBmXraYx3lKp88DnMTHRNKqs2atNc15iRDOIf
         U5BWHrIK2U46kx5aI6qUUfKCpIbG7Eg2VmU42sKlwOtKMIertF1kToHPektcwXJl1NpJ
         Tz2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x+Jl0hYAJo4q4OVBu8UADJo86vPV7s9MdDgSLack3Ms=;
        b=oL5kgLWDC2MP9LThligU2B5Zt4EBKilpGMbDN6rwsTf+NXxkFyw3BKw5d+S2dSyb5A
         XVgdX8sw+dO1m6e/rSuDZz5q5I3Sqq/oHbMSWyl0IzpK0T6xay4LuOkkFkngg2PXQhyq
         DHbJEL6hoOvZnNzlBCAgydK0I1IuSI39wTHAJjd8Uie1Zwct32wtXvosAhfbllF82t8r
         EjRVFaYfYUQwu9hA/qDwVaCvMBXOeKw1I9RWdIcUW/9/e95/qTMqBAJGc3By7+5kKc+n
         LK3DeCJivm0j66rEUxSVihRipZppc0LEp81UIZCXaqxV3MVjwHmJnVgNcrr71Hei1dLz
         a48g==
X-Gm-Message-State: AOAM532uJnTkAJXVLJi3aAuNyYIsjLs20n68zD1Vqa+qD9t7axY2FM8X
        hf25WKMyvd79qUgr2UTwFDsqayXZYHy/8lrvG14dRw==
X-Google-Smtp-Source: ABdhPJxGDYKcwK6TbkAwG6je1mVoZsbdcex9+R6FHaO7vT7dqOKuafRi17KJ3g9iuXiR2XrK894RyPfakJGJYqrrwE0=
X-Received: by 2002:aca:58d6:: with SMTP id m205mr18843393oib.126.1635083581982;
 Sun, 24 Oct 2021 06:53:01 -0700 (PDT)
MIME-Version: 1.0
References: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
 <20211013105541.68045-16-bhupesh.sharma@linaro.org> <6aecc0aa-6219-d440-0075-39935aec0c7e@linaro.org>
In-Reply-To: <6aecc0aa-6219-d440-0075-39935aec0c7e@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Sun, 24 Oct 2021 19:22:50 +0530
Message-ID: <CAH=2NtyCMX-7Jk7kZKVKoQopJ_SQUiG7GRqDoDhm9rsCKigWJw@mail.gmail.com>
Subject: Re: [PATCH v4 15/20] crypto: qce: Add new compatibles for qce crypto driver
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     MSM <linux-arm-msm@vger.kernel.org>, linux-crypto@vger.kernel.org,
        bhupesh.linux@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Thara and Vladimir,

On Wed, 20 Oct 2021 at 19:37, Thara Gopinath <thara.gopinath@linaro.org> wrote:
>
>
>
> On 10/13/21 6:55 AM, Bhupesh Sharma wrote:
> > Since we decided to use soc specific compatibles for describing
> > the qce crypto IP nodes in the device-trees, adapt the driver
> > now to handle the same.
> >
> > Cc: Thara Gopinath <thara.gopinath@linaro.org>
> > Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > ---
> >   drivers/crypto/qce/core.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> > index 033c7278aa5d..2ab0b97d718c 100644
> > --- a/drivers/crypto/qce/core.c
> > +++ b/drivers/crypto/qce/core.c
> > @@ -298,8 +298,8 @@ static int qce_crypto_remove(struct platform_device *pdev)
> >   }
> >
> >   static const struct of_device_id qce_crypto_of_match[] = {
> > -     { .compatible = "qcom,crypto-v5.1", },
> Hi Bhupesh,
>
> I think we should keep the qcom,crypto-v5.1 here for backward
> compatibility. Since v5.4 was added only recently it might be okay to
> remove it.

Thanks, I will fix this in the v5.

Regards,
Bhupesh

> > -     { .compatible = "qcom,crypto-v5.4", },
> > +     { .compatible = "qcom,ipq6018-qce", },
> > +     { .compatible = "qcom,sdm845-qce", },
> >       {}
> >   };
> >   MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
> >
>
>

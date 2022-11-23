Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7101DC3A59F
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Nov 2022 21:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238491AbiKWVf0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Nov 2022 16:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238459AbiKWVfZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Nov 2022 16:35:25 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2440BAB0C0
        for <linux-crypto@vger.kernel.org>; Wed, 23 Nov 2022 13:35:24 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-36cbcda2157so186581637b3.11
        for <linux-crypto@vger.kernel.org>; Wed, 23 Nov 2022 13:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/zxUg/3ClqWga+7Ed6StA1cm4QFeF6wTlClAy8FmIzU=;
        b=RM3VeqxfkFIy8zz8Nl4T3pjNDIYv8xVYnY8rVzE53vCSoGEYJ0HflBsnVQ3Wh4oJT2
         U5mYOFXNU+C6z2s4ZQf6JUf6MP/w5O0Llsf2RXwDKGS7X+oEKxoNtNPaTuX41bzoWac2
         BybSWzGu4u5ibNrDdRtumvHaVcJLYdIRgUWuNJq66dwydaIPJcusUZ4Aq3Syj7F/HIC7
         S9ltlqBpeQzsrchmpEM8I3NgX3751PlOY1/cb9UUp34IfGSKGYg+dFvhSziPn+OEE+2D
         tpVbj+jNkKPUtg+FB3RXgkJtGk6JdO5yP/Jr4oL3vKvv3I8UtmyZHspDN5/WwXvKzLYw
         mkRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/zxUg/3ClqWga+7Ed6StA1cm4QFeF6wTlClAy8FmIzU=;
        b=BsIgH4lK6m64JBgXYdP6XDMbeSHfxkYdvytLzjg6G8FMQnnjY588XWWn86jCQ+pWUC
         XUN8Y1uKC0IpAGupHPjamMKWJjiVQpFuCIJHG0CC1JL5r0BD39PoGjff53I/dILAtNJm
         rEXKxpoiJzNazTzCPPHtS2ry5Q1Yw5/i+yi0rd9Ar0nH3/YXrk/XCkZe0ippuJxLBWO6
         jOwp720AxOHZ1nn9b3A6jX/qSmlbKH2AB840pKHuOebYH3RkuVhNcF2lr3orepPzz1mb
         Zdg29Ip29EYcIQxc0eovMaJBQSw2fpdtHv/jMwalQPZpXwS7+Vd/19VHc/ZDH6DdWD2t
         jPig==
X-Gm-Message-State: ANoB5pki4lg65mi2Ve4YMVm3BzAqNeXiYBJn4r+6ywy4kkm6uXJ8AJf1
        za1jU8r6JZLDrf7i+vg0TQ6U1Bs0oT2O2Aa97CSMLg==
X-Google-Smtp-Source: AA0mqf4DAxvv5I96oWrIjGntJqn8cl3w0Gig1toUsFFzNHH6W/jvXb9tymyP4gjzy3MKGT3r0P6dywTTL64+amTtDR8=
X-Received: by 2002:a81:3855:0:b0:38b:17c4:4297 with SMTP id
 f82-20020a813855000000b0038b17c44297mr11062402ywa.446.1669239323231; Wed, 23
 Nov 2022 13:35:23 -0800 (PST)
MIME-Version: 1.0
References: <20221119221219.1232541-1-linus.walleij@linaro.org>
 <20221119221219.1232541-2-linus.walleij@linaro.org> <73df18a2-b0d6-72de-37bb-17ba84b54b82@kernel.org>
In-Reply-To: <73df18a2-b0d6-72de-37bb-17ba84b54b82@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 23 Nov 2022 22:35:11 +0100
Message-ID: <CACRpkdZsxk2MH0AEHE=kpHuikdP35d3_q6wrr3+Yrs2QpZy62A@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] dt-bindings: crypto: Let STM32 define Ux500 CRYP
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 23, 2022 at 5:13 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:

> > Cc: devicetree@vger.kernel.org
> > Cc: Lionel Debieve <lionel.debieve@foss.st.com>
> > Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> > Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
(...)
>
> Please use scripts/get_maintainers.pl to get a list of necessary people
> and lists to CC.  It might happen, that command when run on an older
> kernel, gives you outdated entries.  Therefore please be sure you base
> your patches on recent Linux kernel.

The people reported by get_maintainers are maybe not on the CC
line of the patch, but if you look at the mail header they are
on the Cc: line... because I pass the not immediately relevant people
to git-send-email rather than add them in the Cc tags.

> > diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
> > index ed23bf94a8e0..69614ab51f81 100644
> > --- a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
> > +++ b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
> > @@ -6,12 +6,18 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
> >
> >  title: STMicroelectronics STM32 CRYP bindings
> >
> > +description: The STM32 CRYP block is built on the CRYP block found in
> > +  the STn8820 SoC introduced in 2007, and subsequently used in the U8500
> > +  SoC in 2010.
> > +
> >  maintainers:
> >    - Lionel Debieve <lionel.debieve@foss.st.com>
> >
> >  properties:
> >    compatible:
> >      enum:
> > +      - st,stn8820-cryp
> > +      - stericsson,ux500-cryp
> >        - st,stm32f756-cryp
> >        - st,stm32mp1-cryp
> >
> > @@ -27,6 +33,19 @@ properties:
> >    resets:
> >      maxItems: 1
> >
> > +  dmas:
> > +    items:
> > +      - description: mem2cryp DMA channel
> > +      - description: cryp2mem DMA channel
> > +
> > +  dma-names:
> > +    items:
> > +      - const: mem2cryp
> > +      - const: cryp2mem
> > +
> > +  power-domains:
> > +    maxItems: 1
>
> Are these all valid for other variants?

The commit message of the patch reads:

> The two properties added are DMA channels and power domain.
> Power domains are a generic SoC feature and the STM32 variant
> also has DMA channels.

I think of power domains kind of like resets, clocks or supplies,
something that is optional.

> > +  - |
> > +    #include <dt-bindings/interrupt-controller/irq.h>
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +    #include <dt-bindings/reset/stericsson,db8500-prcc-reset.h>
> > +    #include <dt-bindings/arm/ux500_pm_domains.h>
> > +    cryp@a03cb000 {
>
> Drop the example, it's almost the same and difference in one new
> property does not warrant a new example.

OK I drop it. Thanks for reviewing!

Yours,
Linus Walleij

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F2CC433E9
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 13:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2935464F6A
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 13:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhCQNVG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Mar 2021 09:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbhCQNUu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Mar 2021 09:20:50 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3957AC061762
        for <linux-crypto@vger.kernel.org>; Wed, 17 Mar 2021 06:20:50 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id x135so37232618oia.9
        for <linux-crypto@vger.kernel.org>; Wed, 17 Mar 2021 06:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ajom+qoaBVWvI/o5yJYUTXtAcdgS/F3iXCD59b+2ARE=;
        b=U936Qixe60vWzMVURSAw8RqVD016hKL3IrWdWxt3ZMSodiR8i6SGPvoyRwGTgCQATk
         dTnNZdDc4s1hcBop0WYFE+4NAq2vKaCWEXt09j1di5EnLljLaddsK5kqgbyVtwfStBd8
         7+8TEGurjTFRvfWGm2mV6CNDH9LKZVGuW1Lxq8LboLX+c2qLybWxXbG18L1WdRnvlhfQ
         hG8K0WgV2pRnrUvFXcCojo8G1Wu6r7aYmessvdlxqMAtyIMQSFPIJWyN3SEg/FclMPBS
         oENrbv62mwPOvNvSxOgIwBIBrkLT5/mZc/MWVpGVrvuDg6TGW94F/tFBhxjlnmCp9RHH
         2OzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ajom+qoaBVWvI/o5yJYUTXtAcdgS/F3iXCD59b+2ARE=;
        b=aZpg0txxvPgEuJxvwixukXxPVVp0nheR40/NP4AeliDu3vnGeellZ4HA4Vm10WQscH
         n79JDPT/5E1dceupygCpr3+VmMa0f+a/OyCMeEqynrtNpVE6Th1fkdHfmG+qzKWGp69O
         lZQpEWtfUTor9SeAhLWo/Cg9Mr0FmFVMTXRiyjL9wzhR3CtohTawyGy88t9xxJIkyGB9
         BgVov+lhRBxlrN6pzQMLqyyB0ziLHIAJNzsJI78vC+IzMG+qpJzBK8WmGEabYxIuzcSQ
         NCBmhLZjd3k6HXH32Y/+4PRPggiUtQb7ETv/3taDouL2kSa3iLf2KVbbOcNudn34zvSE
         6sVg==
X-Gm-Message-State: AOAM532IcE6pdxhNUE9s4FB0rXUFwDBPw1LhS7sXUuod/h9Cd95Bgac4
        KdrkhnttkSHxkuwpASmVSPfkEXgs7kIfbopU79MG3w==
X-Google-Smtp-Source: ABdhPJyXMS61jORQoueJSGAiIEgP7/O76pOuZO2+PRMPv2KLW56V6uSfLC1n+2k7X3AfIlpXZQbL+bB6VONbxFccCLo=
X-Received: by 2002:a54:4590:: with SMTP id z16mr2825628oib.40.1615987249445;
 Wed, 17 Mar 2021 06:20:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210310052503.3618486-1-bhupesh.sharma@linaro.org>
 <20210310052503.3618486-3-bhupesh.sharma@linaro.org> <20210316222825.GA3792517@robh.at.kernel.org>
In-Reply-To: <20210316222825.GA3792517@robh.at.kernel.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Wed, 17 Mar 2021 18:50:38 +0530
Message-ID: <CAH=2Ntw2dMaSYsx-Q=mXx_mMBr5PcmwhhBvTcmPYYKmy=rcCqw@mail.gmail.com>
Subject: Re: [PATCH 2/8] dt-bindings: crypto : Add new compatible strings for qcom-qce
To:     Rob Herring <robh@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhupesh.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Rob,

Thanks for your review.

On Wed, 17 Mar 2021 at 03:58, Rob Herring <robh@kernel.org> wrote:
>
> On Wed, Mar 10, 2021 at 10:54:57AM +0530, Bhupesh Sharma wrote:
> > Newer qcom chips support newer versions of the qce IP, so add
> > new compatible strings for qcom-qce (in addition to the existing
> > "qcom,crypto-v5.1").
> >
> > With [1], Thara tried to add the support for new compatible strings,
> > but we couldn't conclude on the approach to be used. Since we have
> > a number of new qcom arm64 SoCs available now, several of which
> > support the same crypto IP version, so it makes more sense to use
> > the IP version for the compatible string, rather than using the soc
> > name as the compatible string.
> >
> > [1]. https://lore.kernel.org/linux-arm-msm/20201119155233.3974286-7-thara.gopinath@linaro.org/
> >
> > Cc: Thara Gopinath <thara.gopinath@linaro.org>
> > Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: Andy Gross <agross@kernel.org>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Stephen Boyd <sboyd@kernel.org>
> > Cc: Michael Turquette <mturquette@baylibre.com>
> > Cc: linux-clk@vger.kernel.org
> > Cc: linux-crypto@vger.kernel.org
> > Cc: devicetree@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: bhupesh.linux@gmail.com
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/crypto/qcom-qce.txt | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.txt b/Documentation/devicetree/bindings/crypto/qcom-qce.txt
> > index 07ee1b12000b..217b37dbd58a 100644
> > --- a/Documentation/devicetree/bindings/crypto/qcom-qce.txt
> > +++ b/Documentation/devicetree/bindings/crypto/qcom-qce.txt
> > @@ -2,7 +2,11 @@ Qualcomm crypto engine driver
> >
> >  Required properties:
> >
> > -- compatible  : should be "qcom,crypto-v5.1"
> > +- compatible  : Supported versions are:
> > +             - "qcom,crypto-v5.1", for ipq6018
> > +             - "qcom,crypto-v5.4", for sdm845, sm8150
>
> 2 SoCs sharing 1 version doesn't convince me on using version numbers.
> Having 4 versions for 5 SoCs further convinces me you should stick with
> SoC specific compatibles as *everyone* else does (including most QCom
> bindings).

Fair enough. I will add SoC specific compatibles in v2, which should
be out shortly.

Regards,
Bhupesh

> > +             - "qcom,crypto-v5.5", for sm8250
> > +             - "qcom,crypto-v5.6", for sm8350
> >  - reg         : specifies base physical address and size of the registers map
> >  - clocks      : phandle to clock-controller plus clock-specifier pair
> >  - clock-names : "iface" clocks register interface
> > --
> > 2.29.2
> >

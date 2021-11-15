Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F848C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 05:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 685E761BFA
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 05:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhKOFbl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 00:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhKOFb2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 00:31:28 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C837EC061202
        for <linux-crypto@vger.kernel.org>; Sun, 14 Nov 2021 21:28:29 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id g91-20020a9d12e4000000b0055ae68cfc3dso25492280otg.9
        for <linux-crypto@vger.kernel.org>; Sun, 14 Nov 2021 21:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1pCCwFFPZ5wQ1q6Uj5U8eMPTH+2MMD7XkfKBAmWx8+k=;
        b=v1si72HM1cx9QPQtp+dF30SbbjyJljlqUTHHtXcPLqJenPkit7Ic6L2+iESoX+rj5N
         oy98aOq9vRGOeoKaQey0BsUpGB70l1a2vqkUG2P559Y7lBjlzMPsO9tt4bIrwOiT0Asv
         oj/g3FjSU3eXLYYDHQSFdY4SwhX7Z4eQZwLqgyew81x6NqptsV45zfYoExxvcfPRMQ/D
         8CNfbfTwP+WPFtKa9SH8p4e0cMIeyTVYKvIsyWsb3eWh1IR2ukwCH8pm3foIeGPJLdi9
         PorFn/OhFQAWzHm3BAnjbR+7DAiIl/s68hKoYQM27hUQM92TUfIYKqG/MOEHxRB69bfF
         cGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1pCCwFFPZ5wQ1q6Uj5U8eMPTH+2MMD7XkfKBAmWx8+k=;
        b=MUESl21v8fbkipj1M3EpXBoBJIRgPDwoOf2cPaRBY4dr0TdwlG2qKAT/ypOUKEvzJD
         nb1vsGvb1PkuUyuugAMZbxIiVId3NmDXlkx3z2tmhlkqr+zjpKkBPvC0OC54cMOzYYiU
         4owXHWxsHrkFX0Sn1GbMO/eMXO9OnvDUS3R1qrDpuE0e0ONAzyjEm8LdXEd9NasxvRGg
         h1FoYcxOsOqQ76vHcON43siLJkGuPpJZMubnkgtcyG/6KPFT4UPtstiqsUnqGB3D1tS2
         4+G5adNFexS6Y2mi7WGL58EJ+u23Y5MNcCFEjtb/ZmPfEUw46w6smFE8S8jR4beMJaiO
         agMQ==
X-Gm-Message-State: AOAM531651V/lHtd+3INA9f3B4msPsD65lNzX55oO0a2dqf0yPae3cG6
        uMIHMdDdhabsvWY8xft5MFXSzw9FwfyCB94XHu0LiA==
X-Google-Smtp-Source: ABdhPJzXeQQU8uHExB5pbeDnYDw8mfC9u8nDNKgIP/YoZwxq8B9qsATJeHzbHo0Te1D2hs6ie2Xo4GJPGnCINSK9g90=
X-Received: by 2002:a9d:63d2:: with SMTP id e18mr15505274otl.28.1636954109152;
 Sun, 14 Nov 2021 21:28:29 -0800 (PST)
MIME-Version: 1.0
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
 <20211110105922.217895-12-bhupesh.sharma@linaro.org> <3d02334e-d4eb-499e-7523-cd446ad0818f@linaro.org>
In-Reply-To: <3d02334e-d4eb-499e-7523-cd446ad0818f@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Mon, 15 Nov 2021 10:58:17 +0530
Message-ID: <CAH=2Ntwp1_ckv3G8TtdTXU0dVFQJUyx5LpksCABOdPJVQV6ebg@mail.gmail.com>
Subject: Re: [PATCH v5 11/22] dt-bindings: crypto : Add new compatible strings
 for qcom-qce
To:     Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, agross@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        stephan@gerhold.net, Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Vladimir,

On Fri, 12 Nov 2021 at 15:55, Vladimir Zapolskiy
<vladimir.zapolskiy@linaro.org> wrote:
>
> Hi Bhupesh,
>
> On 11/10/21 12:59 PM, Bhupesh Sharma wrote:
> > Newer qcom chips support newer versions of the qce crypto IP, so add
> > soc specific compatible strings for qcom-qce instead of using crypto
> > IP version specific ones.
> >
> > Keep the old strings for backward-compatibility, but mark them as
> > deprecated.
> >
> > Cc: Thara Gopinath <thara.gopinath@linaro.org>
> > Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Reviewed-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > ---
> >   Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 10 ++++++++--
> >   1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> > index efe349e66ae7..77b9f544f32f 100644
> > --- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> > +++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> > @@ -15,7 +15,13 @@ description: |
> >
> >   properties:
> >     compatible:
> > -    const: qcom,crypto-v5.1
> > +    enum:
> > +      - qcom,crypto-v5.1 # Deprecated. Kept only for backward compatibility
> > +      - qcom,ipq6018-qce
> > +      - qcom,sdm845-qce
> > +      - qcom,sm8150-qce
> > +      - qcom,sm8250-qce
> > +      - qcom,sm8350-qce
>
> let me ask you to add at least two more compatibles to the list: qcom,ipq8074-qce
> and qcom,msm8996-qce.

Sure, I will fix it in v6.

Regards,
Bhupesh

> >
> >     reg:
> >       maxItems: 1
> > @@ -68,7 +74,7 @@ examples:
> >     - |
> >       #include <dt-bindings/clock/qcom,gcc-apq8084.h>
> >       crypto-engine@fd45a000 {
> > -        compatible = "qcom,crypto-v5.1";
> > +        compatible = "qcom,ipq6018-qce";
> >           reg = <0xfd45a000 0x6000>;
> >           clocks = <&gcc GCC_CE2_AHB_CLK>,
> >                    <&gcc GCC_CE2_AXI_CLK>,
> >
>
> --
> Best wishes,
> Vladimir

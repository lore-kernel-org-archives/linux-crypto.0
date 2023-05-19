Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7417AC77B7F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 May 2023 10:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjESKfn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 May 2023 06:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbjESKf3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2023 06:35:29 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2519E1BD6
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 03:35:07 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f475366514so20970755e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 03:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684492505; x=1687084505;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kgtk9QjAFcm8bGOS+Euv76czaSdooZrFQsFvOBEa6w8=;
        b=AsOgffUMUzEpsgw5DBeAgbvbHsLem6PXPnqIfe+Rh+tOi+kfnOksgYA1yjfJwxqAWD
         hLIkLw75CNsNBshpgwr/UcstQO5mDE86in1tJXb+1DnjKRiJf24EqhQ57otgMZn6Fyyu
         gDj9KVrbFxZZMkiQWQvxPdVBoj/gcxdxdSu8jUbMF61D9mtCVrgF2ZIHRCnJ7nyEVJzr
         zSmDCJ2K1J+tAsG8shWdQSEedSO/AfFe15yp8l50gWPGYNXWL8iJp1PPtxC112jUX2Cc
         kRIGjRsLtzAExQKXwVafT+QZL7vsXDiqgW2TkW4PEhtESEmj9sCCvbhTdtXwL8dO9bUZ
         VjvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684492505; x=1687084505;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kgtk9QjAFcm8bGOS+Euv76czaSdooZrFQsFvOBEa6w8=;
        b=VB+4+eJ1nmyIzdoit72T/3uZUMsTTcJdF0GQEFX14WYeddo0WE8KoCHBKEqSKGk4VT
         VFyT3ASe7cBBUJ1p1AKWpVE0YTzicgyiCbZMt06cai5lxXEY1bigZa5TKCAexakQcplE
         f+C6NvmliUAVobMfiw1VDwqL3GkUoBZpgrU6cU5gemKwYVOXmKlDN27dz0yc7MG0u5/o
         iY9QZUtJjNWY5kvzAP5ZMVwZAqcC/EbCgVQUfKN0aTQKLzhIxNi9P1j5E3LbL45rGYZw
         wpxrADzt84uJYEAJchVe3rh5GO02eTiE4ZDkDICagF6oJsvVt/tBt0uKm/dzwqnMlHjI
         +GYg==
X-Gm-Message-State: AC+VfDz7gz6fSc1Pzp4CEVrQnGhiZq/Qojhyd2H0dCuWJmZM1VVyky25
        GuuaYZ6rRo0PExuXdJCr7H0H6KbrH1Ye2BNRFc/7UA==
X-Google-Smtp-Source: ACHHUZ5W3yDJ8lPgYu4QIOosFTi8qbzFRCKl8E+s0hkZ3PSKuO4Qjz8uZFNvx4I9sI7CuAIOAGLR11ZPmK72RwmgreI=
X-Received: by 2002:adf:d0cc:0:b0:309:46a4:6378 with SMTP id
 z12-20020adfd0cc000000b0030946a46378mr1407237wrh.12.1684492505006; Fri, 19
 May 2023 03:35:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230405072836.1690248-1-bhupesh.sharma@linaro.org>
 <20230405072836.1690248-10-bhupesh.sharma@linaro.org> <af22628c-e54b-f7e1-16a6-6534f4526cd5@linaro.org>
In-Reply-To: <af22628c-e54b-f7e1-16a6-6534f4526cd5@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Fri, 19 May 2023 16:04:53 +0530
Message-ID: <CAH=2NtyiQ5C9zSgZcHnvvXK42+g4+Ua4h1pcBCPCAtZhnpkyNg@mail.gmail.com>
Subject: Re: [PATCH v6 09/11] arm64: dts: qcom: sm8250: Add Crypto Engine support
To:     Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.linux@gmail.com, krzysztof.kozlowski@linaro.org,
        robh+dt@kernel.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 6 Apr 2023 at 19:29, Konrad Dybcio <konrad.dybcio@linaro.org> wrote:
>
> On 5.04.2023 09:28, Bhupesh Sharma wrote:
> > Add crypto engine (CE) and CE BAM related nodes and definitions to
> > 'sm8250.dtsi'.
> >
> > Co-developed-by and Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > ---
> >  arch/arm64/boot/dts/qcom/sm8250.dtsi | 22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> >
> > diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
> > index 7b78761f2041..2f6b8d4a2d41 100644
> > --- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
> > +++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
> > @@ -2222,6 +2222,28 @@ ufs_mem_phy_lanes: phy@1d87400 {
> >                       };
> >               };
> >
> > +             cryptobam: dma-controller@1dc4000 {
> > +                     compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
> > +                     reg = <0 0x01dc4000 0 0x24000>;
> > +                     interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
> > +                     #dma-cells = <1>;
> > +                     qcom,ee = <0>;
> > +                     qcom,controlled-remotely;
> > +                     iommus = <&apps_smmu 0x594 0x0011>,
> > +                              <&apps_smmu 0x596 0x0011>;
> > +             };
> > +
> > +             crypto: crypto@1dfa000 {
> > +                     compatible = "qcom,sm8250-qce", "qcom,sm8150-qce", "qcom,qce";
> > +                     reg = <0 0x01dfa000 0 0x6000>;
> > +                     dmas = <&cryptobam 4>, <&cryptobam 5>;
> > +                     dma-names = "rx", "tx";
> > +                     iommus = <&apps_smmu 0x594 0x0011>,
> > +                              <&apps_smmu 0x596 0x0011>;
> > +                     interconnects = <&aggre2_noc MASTER_CRYPTO_CORE_0 &mc_virt SLAVE_EBI_CH0>;
> > +                     interconnect-names = "memory";
> Shouldn't we also attach the contexts from qcom_cedev_ns_cb{}?

Sure, I have fixed this in v7. Will share it shortly.

Thanks.

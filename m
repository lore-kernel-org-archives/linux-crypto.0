Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27697C47096
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 03:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AC11613DE
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 03:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFDD3j (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 23:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhFDD3j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 23:29:39 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE22C061761
        for <linux-crypto@vger.kernel.org>; Thu,  3 Jun 2021 20:27:39 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id z3so8460572oib.5
        for <linux-crypto@vger.kernel.org>; Thu, 03 Jun 2021 20:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ofLA5Yth7cNuIGM6YFGLuq5e5gElaG+msVA631CxO2I=;
        b=uM528HoRNzisbbP1Ciydmknx8eMheK6X+d6E3rFSymcflD7mvtYlMX8p+3OZLkxMS+
         aQg4bL5+kY4XKLbALNfehxg67eEFzpu/twKRRtQxlMbHHr1d8iLxJgtbZqXzIZn9wsKA
         jf3J5tPcWgNnTKTOOiB+0QnWDhxeJ+u73zsFnu7dsxibWXvKcdUtnaNKt9atMtxfXEWK
         8fmtPLQ4rr1iYa/JLWs7dWaxw52R/dOpfDtBvlwnc7ut65sMphdq7gntNT6VYsfxuket
         ZeVgNhVGOIjPZ63VSskpHKw3zIabYe8fddOPme9cXw8nlIBLDuZEhlF9WC7PfQ18Q0xI
         fPig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ofLA5Yth7cNuIGM6YFGLuq5e5gElaG+msVA631CxO2I=;
        b=EW2dFGkM98JkDIfhHFnFudpUN+bzZtJxDUeBg/NjNLPBMD6foWWaucH/xcz+VfplxB
         zbFV+5Gu0Y0bsrkeDWFTh6DXusYIHPzgsKT+t3hPX31kTTi3Sgu52awxn23JFmjBkqDD
         vneY4azaFZTlZDLdRClNV4LxC8BJ/2i6IF5Sl49BT67iCmeqZuWV3kdwxMbq6kj8zJ+y
         XKMmlcBs4I/gfqqNeYMi/+qdUKQYLb+f23qtiR6/E38qkvruyNqeV68dHn8tajC7hN4D
         zHkgEqDQNhE6a0q1GhCnY6qPdv0+OU3lJ+kYHaTxEX00oodt1bgVAVMVzZ11NqbsI3Vu
         U4dg==
X-Gm-Message-State: AOAM532VaVDLk642IUOjKKdvCafa4e7AkMGtaqWoiXYWwdfluIb85z36
        OkjsIb6q9EHEggO3eBD0CVunpi3BHuu+zqRRR69DkA==
X-Google-Smtp-Source: ABdhPJxD8+rFjLez4xtP2gnQcSqIZih5Kb5zZR7kQs9ajpSPJ77foKTuFLdY4J+edKcnDerJJr4PzhoV8pQ+xB7PRrg=
X-Received: by 2002:a05:6808:b15:: with SMTP id s21mr592285oij.40.1622777258224;
 Thu, 03 Jun 2021 20:27:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210519143700.27392-1-bhupesh.sharma@linaro.org>
 <20210519143700.27392-2-bhupesh.sharma@linaro.org> <20210521014316.GA2462277@robh.at.kernel.org>
In-Reply-To: <20210521014316.GA2462277@robh.at.kernel.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Fri, 4 Jun 2021 08:57:27 +0530
Message-ID: <CAH=2NtwzFMre_+6LRM_JL+itbG09UuKLtH+Awbv_zK++qns49w@mail.gmail.com>
Subject: Re: [PATCH v3 01/17] dt-bindings: qcom-bam: Convert binding to YAML
To:     Rob Herring <robh@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
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

Hello Rob,

Thanks for the review and sorry for the late reply.

On Fri, 21 May 2021 at 07:13, Rob Herring <robh@kernel.org> wrote:
>
> On Wed, May 19, 2021 at 08:06:44PM +0530, Bhupesh Sharma wrote:
> > Convert Qualcomm BAM DMA devicetree binding to YAML.
> >
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
> >  .../devicetree/bindings/dma/qcom_bam_dma.txt  | 50 ----------
> >  .../devicetree/bindings/dma/qcom_bam_dma.yaml | 91 +++++++++++++++++++
> >  2 files changed, 91 insertions(+), 50 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> >  create mode 100644 Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> > deleted file mode 100644
> > index cf5b9e44432c..000000000000
> > --- a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
> > +++ /dev/null
> > @@ -1,50 +0,0 @@
> > -QCOM BAM DMA controller
> > -
> > -Required properties:
> > -- compatible: must be one of the following:
> > - * "qcom,bam-v1.4.0" for MSM8974, APQ8074 and APQ8084
> > - * "qcom,bam-v1.3.0" for APQ8064, IPQ8064 and MSM8960
> > - * "qcom,bam-v1.7.0" for MSM8916
> > -- reg: Address range for DMA registers
> > -- interrupts: Should contain the one interrupt shared by all channels
> > -- #dma-cells: must be <1>, the cell in the dmas property of the client device
> > -  represents the channel number
> > -- clocks: required clock
> > -- clock-names: must contain "bam_clk" entry
> > -- qcom,ee : indicates the active Execution Environment identifier (0-7) used in
> > -  the secure world.
> > -- qcom,controlled-remotely : optional, indicates that the bam is controlled by
> > -  remote proccessor i.e. execution environment.
> > -- num-channels : optional, indicates supported number of DMA channels in a
> > -  remotely controlled bam.
> > -- qcom,num-ees : optional, indicates supported number of Execution Environments
> > -  in a remotely controlled bam.
> > -
> > -Example:
> > -
> > -     uart-bam: dma@f9984000 = {
> > -             compatible = "qcom,bam-v1.4.0";
> > -             reg = <0xf9984000 0x15000>;
> > -             interrupts = <0 94 0>;
> > -             clocks = <&gcc GCC_BAM_DMA_AHB_CLK>;
> > -             clock-names = "bam_clk";
> > -             #dma-cells = <1>;
> > -             qcom,ee = <0>;
> > -     };
> > -
> > -DMA clients must use the format described in the dma.txt file, using a two cell
> > -specifier for each channel.
> > -
> > -Example:
> > -     serial@f991e000 {
> > -             compatible = "qcom,msm-uart";
> > -             reg = <0xf991e000 0x1000>
> > -                     <0xf9944000 0x19000>;
> > -             interrupts = <0 108 0>;
> > -             clocks = <&gcc GCC_BLSP1_UART2_APPS_CLK>,
> > -                     <&gcc GCC_BLSP1_AHB_CLK>;
> > -             clock-names = "core", "iface";
> > -
> > -             dmas = <&uart-bam 0>, <&uart-bam 1>;
> > -             dma-names = "rx", "tx";
> > -     };
> > diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml b/Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml
> > new file mode 100644
> > index 000000000000..173e4d7508a6
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml
> > @@ -0,0 +1,91 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/dma/qcom_bam_dma.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: QCOM BAM DMA controller binding
> > +
> > +maintainers:
> > +  - Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > +
> > +description: |
> > +  This document defines the binding for the BAM DMA controller
> > +  found on Qualcomm parts.
> > +
> > +allOf:
> > +  - $ref: "dma-controller.yaml#"
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - qcom,bam-v1.4.0
> > +      - qcom,bam-v1.3.0
> > +      - qcom,bam-v1.7.0
>
> Can we keep the SoC association please.

The original bam dma bindings are as per the underlying bam IP
version, so I would prefer that we keep it this way for this series.

Later on I can send a patchset to convert the bam DMA dt-bindings, dts
and driver to work with 'SoC association' instead.

> > +
> > +  reg:
> > +    maxItems: 1
> > +    description: Address range of the DMA registers.
>
> Drop description.

Sure.

> > +
> > +  clocks:
> > +    minItems: 1
> > +    maxItems: 8
> > +
> > +  clock-names:
> > +    const: bam_clk
>
> This is going to fail if you try more than 1 clock.

Right, currently we have one clock, but I can recheck and make fixes in v4.

> > +
> > +  interrupts:
> > +    maxItems: 1
> > +    description: Single interrupt line shared by all channels.
>
> Drop description

Ok.

> > +
> > +  num-channels:
> > +    maxItems: 31
> > +    description: |
> > +      Indicates supported number of DMA channels in a remotely controlled bam.
> > +
> > +  "#dma-cells":
> > +    const: 1
> > +    description: The single cell represents the channel index.
> > +
> > +  qcom,ee:
> > +    $ref: /schemas/types.yaml#/definitions/uint8
> > +    description:
> > +      Indicates the active Execution Environment identifier (0-7)
> > +      used in the secure world.
> > +    enum: [0, 1, 2, 3, 4, 5, 6, 7]
> > +
> > +  qcom,controlled-remotely:
> > +    $ref: /schemas/types.yaml#/definitions/flag
> > +    description:
> > +      Indicates that the bam is controlled by remote proccessor i.e.
> > +      execution environment.
> > +
> > +  qcom,num-ees:
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> > +    description:
> > +      Indicates supported number of Execution Environments in a
> > +      remotely controlled bam.
>
> 0-2^32 is valid?

Oh, got it. Will fix it in v4.

> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +  - clocks
> > +  - clock-names
> > +  - "#dma-cells"
> > +  - qcom,ee
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/clock/qcom,gcc-msm8974.h>
> > +    dma-controller@f9984000 {
> > +        compatible = "qcom,bam-v1.4.0";
> > +        reg = <0xf9984000 0x15000>;
> > +        interrupts = <0 94 0>;
> > +        clocks = <&gcc GCC_BAM_DMA_AHB_CLK>;
> > +        clock-names = "bam_clk";
> > +        #dma-cells = <1>;
> > +        qcom,ee = /bits/ 8 <0>;
> > +    };
> > --
> > 2.31.1

Thanks,
Bhupesh

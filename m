Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1AC9C001DF
	for <linux-crypto@archiver.kernel.org>; Sun, 30 Jul 2023 19:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjG3TP6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 30 Jul 2023 15:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjG3TP6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Jul 2023 15:15:58 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63811709
        for <linux-crypto@vger.kernel.org>; Sun, 30 Jul 2023 12:15:53 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-991da766865so603876866b.0
        for <linux-crypto@vger.kernel.org>; Sun, 30 Jul 2023 12:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690744552; x=1691349352;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bAdDlvNo2vLdfcsDPkJen+iBi4ac4UvVpMaDLLPdBg4=;
        b=N5KWFa365inzuu97p0Hlj4dphVbT6YW8++Knq7ZXcnWyZzQQI5zb708SBazsItYwTs
         LXpt7ztZ1aU1ZYgnlHORxIJ8YVy9nKS+bjQsRcX4reXTAQGSCXnclXT9VFAd3a6UH14t
         HL95/2YSY2m1L2Ai/bIqbP1xOcNFuOE9GMQwCTQFzBGZyAuopL7u6JT/NThigc7Gxjtc
         IKUI6CkPg4A/5q7P7+xlMFFENsOAN67u6q2p+qrm8Fo/Wj56snPiESkmXcmSqlqSQhn6
         RY479HdpB9pYphd0gpJei6BfxDeJxAET4ScdRVFDEwVG9znT8Qig5RlX4ac11nnRglvr
         EtqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690744552; x=1691349352;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bAdDlvNo2vLdfcsDPkJen+iBi4ac4UvVpMaDLLPdBg4=;
        b=O3x7vd0tow0fOO9gZCJF7T3aie/rh7zUbQPpC1E9zC+Q9qW2EZzV984s9qxzwBdyJ0
         ydqXvNruOZmp2GvFa3cBbdVkUV16AAUeg5PVxVvKm7/Jw4ueFLXs/qmy5Yn8ZGvQmtqQ
         YXaBs+AGWui0385AvWD1i3BLwQ0BvK8XcnYhb5+hC22ELRhq5ySQwpKbgJ9iLozOKp6h
         Oo5IWREQZg3nDmnsbHXazA9ui3h5M/i6aMAPYCPnGxkYee3MJTBE+p2q7QvaKeb7t6oQ
         Sze7Fx5HiqL6spBW6cEyk3ZNeOUzdSNgj/bxDjTGmN3+MPs2HtlgMhEf1M2ksnRAejff
         YofQ==
X-Gm-Message-State: ABy/qLZoD/dNZ56DQGmMGwMZ/AEUXpJWGgZM2sXX7z1C56AE2Hnc1pKe
        UDcHrgSdUqJ5cKUqoSVXzXiH1w==
X-Google-Smtp-Source: APBJJlENFI8r0s0dm1vmxCNCtoyiiHZ+kTqoFDnQ/fMkWAclhRP5VUEXkQcU3Cpdq2nz8a5eXAyvtA==
X-Received: by 2002:a17:907:2712:b0:97e:aace:b6bc with SMTP id w18-20020a170907271200b0097eaaceb6bcmr4961797ejk.53.1690744551930;
        Sun, 30 Jul 2023 12:15:51 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.222.183])
        by smtp.gmail.com with ESMTPSA id dk8-20020a170906f0c800b00992f2befcbcsm5006941ejb.180.2023.07.30.12.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Jul 2023 12:15:51 -0700 (PDT)
Message-ID: <8ea4f777-5645-96ae-164f-ff9f7b736eda@linaro.org>
Date:   Sun, 30 Jul 2023 21:15:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH 2/5] dt-bindings: crypto: Add binding for TI MCRC64 driver
Content-Language: en-US
To:     Kamlesh Gurudasani <kamlesh@ti.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20230719-mcrc-upstream-v1-0-dc8798a24c47@ti.com>
 <20230719-mcrc-upstream-v1-2-dc8798a24c47@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230719-mcrc-upstream-v1-2-dc8798a24c47@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 30/07/2023 20:55, Kamlesh Gurudasani wrote:
> Add binding for Texas Instruments MCRC64 driver

A nit, subject: drop second/last, redundant "binding for". The
"dt-bindings" prefix is already stating that these are bindings.

Here and subject: drop driver. Bindings are for hardware.

Neither commit nor bindings in description: field explain what is this
hardware.

> 
> Signed-off-by: Kamlesh Gurudasani <kamlesh@ti.com>
> ---
>  Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml | 42 ++++++++++++++++++++++++++++++++++++++++++
>  MAINTAINERS                                             |  5 +++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml b/Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml
> new file mode 100644
> index 000000000000..1d1e3f87638c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/ti,mcrc64.yaml
> @@ -0,0 +1,42 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/ti,mcrc64.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Texas Instruments MCRC64 bindings

Drop bindings. If you tested your code, you would see a warning, so:

It does not look like you tested the bindings, at least after quick
look. Please run `make dt_binding_check` (see
Documentation/devicetree/bindings/writing-schema.rst for instructions).
Maybe you need to update your dtschema and yamllint.

> +
> +maintainers:
> +  - Kamlesh Gurudasani <kamlesh@ti.com>
> +
> +properties:
> +  compatible:
> +    const: ti,mcrc64

What's this? Part of SoC? Then the compatible is not correct.

> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 1
> +
> +  power-domains:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - power-domains
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    mcrc64: mcrc64@30300000 {

Node names should be generic. See also an explanation and list of
examples (not exhaustive) in DT specification:
https://devicetree-specification.readthedocs.io/en/latest/chapter2-devicetree-basics.html#generic-names-recommendation


> +      compatible = "ti,mcrc64";
> +      reg = <0x00 0x30300000 0x00 0x1000>;
> +      clocks = <&k3_clks 116 0>;
> +      power-domains = <&k3_pds 116 TI_SCI_PD_EXCLUSIVE>;
> +      };

Indentation is messed up.
> 

Best regards,
Krzysztof


Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E02EC678D4
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Mar 2023 09:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjCCJx6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Mar 2023 04:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjCCJx5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Mar 2023 04:53:57 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FDD30EB5
        for <linux-crypto@vger.kernel.org>; Fri,  3 Mar 2023 01:53:50 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id u9so8079121edd.2
        for <linux-crypto@vger.kernel.org>; Fri, 03 Mar 2023 01:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677837229;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BfU2QZq8o37GwsmSTNlf3DbhxAQM4goNkdilqnhVkSA=;
        b=wJ5ey+Ulbdj8SdrY4Gy+p6B6hTrl+rpsR7YCGlZyStFEePOt8zLUNACHVy1hQ0RkR1
         56saZMavOtLnGEpLoIX3Auwl+uV42CRMo8rpneFLh8Fv5sYKMEptMeZSSR6t/cfbqXNw
         /iBrt553A1QIWFeOEYyN43bMDo2HRVQKxhSZ2FrAU+XMl6yJCPbOWmV1aR7bOOakhA2+
         91KV7KjimjMvzQppvtjk+OkIuqKrAHtZl0QTSFsvEgbHe+fotO+wnYcBmusXaHQwS6+J
         i/kTYtNHHwqTF7sCVdxXio/DAoSu5UN10FVdnXhMCeb+bY45PIwt5Dano2J7oPXFigWB
         cfGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677837229;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BfU2QZq8o37GwsmSTNlf3DbhxAQM4goNkdilqnhVkSA=;
        b=tT4pxphptwyBYAWmW2AlQwmf3JL4/m8EzhhBESxaCEaYZPK33HM8OM4TG39bfllywp
         GzmyVkBvbBLSiFNgIMeB2wcbmDLsis2WFRgsbVQRHSX0wk+YIuTtpjRP62XhS/w+Et+Q
         mKFwSlkBP9q2Gvajcb4iHeezdwYDfyeow5dfh7w6eHjaledxGq0VorNgoN95Xc4HznN8
         K7BClmOvC0u4fSs6wqcbAlIgCAZq0M/apw9dY1LeWvE91w85dWose4y4xaGJ8l9K6hzg
         IRW8aog80KIwsROM+qo7KO/TltdGE/NlL8Zdqt2hkiZHY1aJrbRZk5JEeJBYRTLYVmHK
         l9qg==
X-Gm-Message-State: AO0yUKWonW43JuTzLW7GjrF52svKIZjp5hO5hvVQFvSrAKr3Gceg19lo
        0xsu5rggv3IWXzG8ZlfDCaqE8A==
X-Google-Smtp-Source: AK7set9ms3eH4TFT9YSRaBfnqAIhfsByskCFp1zzaguP8QY7uaqTji5lFW0iLhT0rBmNZjVAvDMYRg==
X-Received: by 2002:a05:6402:784:b0:4ab:554:37e9 with SMTP id d4-20020a056402078400b004ab055437e9mr1168393edy.41.1677837228873;
        Fri, 03 Mar 2023 01:53:48 -0800 (PST)
Received: from [192.168.1.20] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id b30-20020a509f21000000b004a21263bbaasm759095edf.49.2023.03.03.01.53.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 01:53:48 -0800 (PST)
Message-ID: <5d10fa17-364c-9d90-c083-f338957631a6@linaro.org>
Date:   Fri, 3 Mar 2023 10:53:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 2/9] dt-bindings: crypto: fsl-sec4: convert to DT schema
Content-Language: en-US
To:     "Peng Fan (OSS)" <peng.fan@oss.nxp.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
        shawnguo@kernel.org, s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, stefan@agner.ch,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peng Fan <peng.fan@nxp.com>
References: <20230301015702.3388458-1-peng.fan@oss.nxp.com>
 <20230301015702.3388458-3-peng.fan@oss.nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230301015702.3388458-3-peng.fan@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 01/03/2023 02:56, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> Convert the fsl-sec4 binding to DT schema

I don't see the removal part of conversion.

> 
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---
>  .../devicetree/bindings/crypto/fsl-sec4.yaml  | 324 ++++++++++++++++++
>  1 file changed, 324 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/fsl-sec4.yaml

Filename matching compatible.

> 
> diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4.yaml b/Documentation/devicetree/bindings/crypto/fsl-sec4.yaml
> new file mode 100644
> index 000000000000..678c8389ef49
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/fsl-sec4.yaml
> @@ -0,0 +1,324 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/fsl-sec4.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NXP SEC4 Crypto Binding

Drop "Binding"

> +
> +description:
> +  CONTENTS
> +    -Overview
> +    -SEC 4 Node
> +    -Job Ring Node
> +    -Run Time Integrity Check (RTIC) Node
> +    -Run Time Integrity Check (RTIC) Memory Node

????

> +  NOTE, the SEC 4 is also known as Freescale's Cryptographic Accelerator
> +  Accelerator and Assurance Module (CAAM).
> +  For information on SEC4 SNVS, ref fsl-sec4-snvs.yaml
> +
> +  =====================================================================
> +  Overview
> +
> +  DESCRIPTION

Reformat it to look like normal text. Drop "====", fix title case.

> +
> +  SEC 4 h/w can process requests from 2 types of sources.
> +  1. DPAA Queue Interface (HW interface between Queue Manager & SEC 4).
> +  2. Job Rings (HW interface between cores & SEC 4 registers).
> +
> +  High Speed Data Path Configuration,
> +
> +  HW interface between QM & SEC 4 and also BM & SEC 4, on DPAA-enabled parts
> +  such as the P4080.  The number of simultaneous dequeues the QI can make is
> +  equal to the number of Descriptor Controller (DECO) engines in a particular
> +  SEC version.  E.g., the SEC 4.0 in the P4080 has 5 DECOs and can thus
> +  dequeue from 5 subportals simultaneously.
> +
> +  Job Ring Data Path Configuration,
> +
> +  Each JR is located on a separate 4k page, they may (or may not) be made visible
> +  in the memory partition devoted to a particular core.  The P4080 has 4 JRs, so
> +  up to 4 JRs can be configured; and all 4 JRs process requests in parallel.
> +
> +maintainers:
> +  - Peng Fan <peng.fan@nxp.com>

Keep the order of properties like in example-schema.

> +
> +properties:
> +  compatible:
> +    enum:
> +      - fsl,sec-v4.0
> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 1
> +
> +  reg:
> +    maxItems: 1
> +
> +  ranges:
> +    description:
> +      A standard property. Specifies the physical address range of the SEC
> +      4.0 register space (-SNVS not included).  A triplet that includes the
> +      child address, parent address, & length.
> +
> +  interrupts:
> +    description:
> +      Specifies the interrupts generated by this device.  The value of the
> +      interrupts property consists of one interrupt specifier. The format
> +      of the specifier is defined by the binding document describing the
> +      node's interrupt parent.
> +    maxItems: 1
> +
> +  clocks:
> +    minItems: 1
> +    maxItems: 4
> +
> +  clock-names:
> +    oneOf:
> +      - items:
> +          - const: mem
> +          - const: aclk
> +          - const: ipg
> +          - const: emi_slow
> +      - items:
> +          - const: aclk
> +          - const: ipg
> +      - items:
> +          - const: ipg
> +          - const: aclk
> +          - const: mem
> +
> +  fsl,sec-era:
> +    description:
> +      Optional. A standard property. Define the 'ERA' of the SEC device.

Drop redundant, free form text - optional.

What is a "standard property"? So all others are non-standard? They
violate standard? What does it mean?

I will actually skip the review as I really do not know if this is new
binding all conversion.

(...)

> +
> +required:
> +  - compatible
> +  - reg
> +
> +unevaluatedProperties: false

additionalProperties instead


Best regards,
Krzysztof


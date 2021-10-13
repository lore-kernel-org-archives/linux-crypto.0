Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8EBCC433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 13:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90C72610CB
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 13:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbhJMNHb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 09:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbhJMNHY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 09:07:24 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB25FC06174E
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 06:05:19 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id u21so8377810lff.8
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 06:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xowPA0KXkDimH5diDPNJR7+P4PZbybslKdAEHgBwaCw=;
        b=s0FRSbCg+aUO1rTNrATLxL+l6IGjLXN7+TMv7tgNoLErDOmqGT4xWn8Nq2zNs5i2w/
         hwbTSI1PehHXFY8S83cprG48o3vRAtSypgkUvfhzp6YOV/IF267y4MCwLBo+5vDWyvqC
         d4xWpeAmaX+GUMLAmCerk7PIMuyz+pIw+KwWkG3Gdtd89570uxLA6J9Il7nWB0NAwXJH
         KK7SQD/V60XnmgKJCe9BVXg3PWsTLliMa3EMExdohHirPOwhbM0vXm8avgYdMHPp5IIX
         uMPBrtUxkB0LxUz5iQJ/bLx18aaaovVXN49vcjjxs2L8mSBu7pmG7fHVo0+74k2UQf4+
         CEBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xowPA0KXkDimH5diDPNJR7+P4PZbybslKdAEHgBwaCw=;
        b=WuIUBurUTbDHi2rB5YcU4EKCLR19VIRTwoVzJvKr/jCYvecIIbx02vimK6ZX40AYq0
         2NvCFR9w91xetUALo/VWuBWgMsvJaKalJpzR/fa70zDwqgZgkzsqSx1mNIRSU7wIbvEQ
         DfwCrRcb/My88WagL2xWSBzXxPDqy35YKoHlg5NKE3SbzGIRKewBV56IvHAPyLuX53fO
         xKw/KQwQ5IXWlVFp4BQ4HynJMEbsJBowkI6NvJoRyOMbrmTl4A8CQxwYlDWlrt67fb3t
         V00dhvIN6h4Ybfk3T/CT6fdt6q2gCGb2ezp/T4SBKZ7736MytYywC65lNBicM8/SsIzp
         eHYg==
X-Gm-Message-State: AOAM533y7BivCTBU5//4Cssa/xxO5LxigRDUTbeEddnKEz+vL31pBVwC
        PvTn1BclpMZ8cUnl/UzK/ntCYDqla9KeNQ==
X-Google-Smtp-Source: ABdhPJwIZLLaMhm3M7J6QiDzYJdWa2mNtm9tk6WbTR9xWYATnnQynUkZYRkYvQjmnu3/QYJxqIxtAQ==
X-Received: by 2002:a05:651c:514:: with SMTP id o20mr37782556ljp.305.1634130318011;
        Wed, 13 Oct 2021 06:05:18 -0700 (PDT)
Received: from [192.168.1.102] (62-248-207-242.elisa-laajakaista.fi. [62.248.207.242])
        by smtp.gmail.com with ESMTPSA id y6sm1327449lfa.122.2021.10.13.06.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 06:05:17 -0700 (PDT)
Subject: Re: [PATCH v4 07/20] dt-bindings: qcom-qce: Convert bindings to yaml
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, agross@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh@kernel.org>
References: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
 <20211013105541.68045-8-bhupesh.sharma@linaro.org>
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Message-ID: <f58d549a-5ce3-a51d-c371-a3ffdc76496d@linaro.org>
Date:   Wed, 13 Oct 2021 16:05:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20211013105541.68045-8-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Bhupesh,

On 10/13/21 1:55 PM, Bhupesh Sharma wrote:
> Convert Qualcomm QCE crypto devicetree binding to YAML.
> 
> Cc: Thara Gopinath <thara.gopinath@linaro.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>   .../devicetree/bindings/crypto/qcom-qce.yaml  | 67 +++++++++++++++++++
>   1 file changed, 67 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> new file mode 100644
> index 000000000000..b7ae873dc943
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> @@ -0,0 +1,67 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/qcom-qce.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm crypto engine driver
> +
> +maintainers:
> +  - Bhupesh Sharma <bhupesh.sharma@linaro.org>
> +
> +description: |
> +  This document defines the binding for the QCE crypto
> +  controller found on Qualcomm parts.
> +
> +properties:
> +  compatible:
> +    const: qcom,crypto-v5.1
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    items:
> +      - description: iface clocks register interface.
> +      - description: bus clocks data transfer interface.
> +      - description: core clocks rest of the crypto block.
> +
> +  clock-names:
> +    items:
> +      - const: iface
> +      - const: bus
> +      - const: core
> +
> +  dmas:
> +    items:
> +      - description: DMA specifiers for tx dma channel.
> +      - description: DMA specifiers for rx dma channel.

Please consider to swap the description lines, so that they'll
be matching the dma-names below and a regular order found in
dts files.

> +
> +  dma-names:
> +    items:
> +      - const: rx
> +      - const: tx
> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - clock-names
> +  - dmas
> +  - dma-names
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/qcom,gcc-apq8084.h>
> +    crypto-engine@fd45a000 {
> +        compatible = "qcom,crypto-v5.1";
> +        reg = <0xfd45a000 0x6000>;
> +        clocks = <&gcc GCC_CE2_AHB_CLK>,
> +                 <&gcc GCC_CE2_AXI_CLK>,
> +                 <&gcc GCC_CE2_CLK>;
> +        clock-names = "iface", "bus", "core";
> +        dmas = <&cryptobam 2>, <&cryptobam 3>;
> +        dma-names = "rx", "tx";
> +    };
> 

--
Best wishes,
Vladimir

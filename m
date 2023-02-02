Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A032C636D4
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Feb 2023 13:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjBBN5f (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Feb 2023 08:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbjBBN5e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2023 08:57:34 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25B07167E
        for <linux-crypto@vger.kernel.org>; Thu,  2 Feb 2023 05:57:32 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id h16so1761679wrz.12
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2023 05:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fQv4EInwan8kcb6xlAJfnG13F2BxITSAq/Y5jRVwQo0=;
        b=x51hm61597wc7e9dh0Zf5RrLS9xoJlkjSd2cuztMK12X4bPW8RWK/L4Mt5Xhq+Ijk+
         1vv/9QOw0MZP6MO1VGukgf/GnKBCISd9zTmCeOKJXKIsrRANmqrhRd0OCqNpUBjLmq/S
         J0DOIAyo8H/DhzmQxMEkJTTsGZCbXc9XEVjNK6SzAkcYzmafm0gApHuex04XGBIu827y
         tsZMcN4KoHOTBYqoupBEt0nuzRnm7uyGL8o0dL9Vl1gsKYBAjIRgWrZfK1HtN0WCyzfI
         N+lvUl4sMO1QLRkeFxDUl15MjdklI5zB7FzMGgpe2uouvKXnU+9XReqhoryvmoNskdla
         K1zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fQv4EInwan8kcb6xlAJfnG13F2BxITSAq/Y5jRVwQo0=;
        b=RN5+29wBVB5soZmR1gpJpMKm7iqUrOq0gAU7iJLa798VrzfrSZL1jY2/CZ3k+/i2wc
         dTFsndT4bWtd3FbvelWADFROzBhYFB6Q66xEUap6Zj4FTHcY2Go5Kid0wk2fAGmKIFle
         Plyki2ZnslfiycSdQeS3hM1w4LrVw+HdRienygimdR4QnMU70Aq/6Ubta5nQQ0/labut
         ZW95dWxugjzNW3Sr6kK+ZugD3+dJSt06BDU9KupEq/Wk15Eq+SUEjzOfbPNu8fBzdMD4
         tbgP5zwF07mDGzndU1GUaf2g071BTc9KZgZGtt9DeCPuUHnEdoq9i7Dm+Vm2JMZCCBnF
         mL9Q==
X-Gm-Message-State: AO0yUKUQcUARIPBSq7Ec9rl2Oqqjxp07ortJRDH3Bt5lc/Ix0bhcQRlI
        C+MVuZW9ZPOZ5mmc+IIKqgE0KQ==
X-Google-Smtp-Source: AK7set+A2VYSe/rRtYkeW/HISsxVTJg51Q8BnDYOun/Cta+g0XP3PniMXBuPCTYNKFMRdGxmjbeiiQ==
X-Received: by 2002:a05:6000:16c4:b0:2bf:ce9a:c19f with SMTP id h4-20020a05600016c400b002bfce9ac19fmr6601726wrf.34.1675346251140;
        Thu, 02 Feb 2023 05:57:31 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id l16-20020adffe90000000b002b8fe58d6desm19351447wrr.62.2023.02.02.05.57.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 05:57:30 -0800 (PST)
Message-ID: <0fc4c509-2db4-0bce-75c6-11835d6987d0@linaro.org>
Date:   Thu, 2 Feb 2023 14:57:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v8 6/9] dt-bindings: qcom-qce: Add new SoC compatible
 strings for qcom-qce
Content-Language: en-US
To:     Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Jordan Crouse <jorcrous@amazon.com>
References: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
 <20230202135036.2635376-7-vladimir.zapolskiy@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230202135036.2635376-7-vladimir.zapolskiy@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 02/02/2023 14:50, Vladimir Zapolskiy wrote:
> From: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> 
> Newer Qualcomm chips support newer versions of the qce crypto IP, so add
> soc specific compatible strings for qcom-qce instead of using crypto
> IP version specific ones.
> 
> Keep the old strings for backward-compatibility, but mark them as
> deprecated.
> 
> Cc: Bjorn Andersson <andersson@kernel.org>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Tested-by: Jordan Crouse <jorcrous@amazon.com>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
> ---
>  .../devicetree/bindings/crypto/qcom-qce.yaml  | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> index a159089e8a6a..4e0b63b85267 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
> @@ -15,7 +15,22 @@ description:
>  
>  properties:
>    compatible:
> -    const: qcom,crypto-v5.1
> +    oneOf:
> +      - const: qcom,crypto-v5.1
> +        deprecated: true
> +        description: Kept only for ABI backward compatibility
> +      - items:

Drop items.

> +          - enum:
> +              - qcom,ipq4019-qce
> +              - qcom,ipq6018-qce
> +              - qcom,ipq8074-qce
> +              - qcom,msm8996-qce
> +              - qcom,sdm845-qce
> +              - qcom,sm8150-qce
> +              - qcom,sm8250-qce
> +              - qcom,sm8350-qce
> +              - qcom,sm8450-qce
> +              - qcom,sm8550-qce

Unfortunately my comments from v6 was not addressed, nor responded to.

We already got a public comment from community that we handle Qualcomm
bindings in a too loose way. I don't think we should be doing this (so
keep ignoring ABI), just for the sanity of cleanup.

It's fine to discuss it with me, but since v6 there was no discussion,
so let's be clear here - NAK on ABI break.

Best regards,
Krzysztof


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08FDC433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Apr 2022 07:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343761AbiDZHUQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Apr 2022 03:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343666AbiDZHUP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Apr 2022 03:20:15 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8FC89CED
        for <linux-crypto@vger.kernel.org>; Tue, 26 Apr 2022 00:17:08 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id d6so16070634ede.8
        for <linux-crypto@vger.kernel.org>; Tue, 26 Apr 2022 00:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=shX4IM4IxXnZAwFkwJE2OgpC7RVVTATTpnGlocR5V84=;
        b=nkwegCQ8EKFVIPs5hZHXdpuhv8bMa7YtQcYyd/qrqIn4Hq2RKrB8ZQdqteOE7+cVh6
         FGpvuTrZzgWr3rd1cUdkI1eWBB+lYlJPS7gZdWeDO9i/PEtl1ea17FvJqh8UpU41Wubj
         fnyRVEUvKUiob7yUIL9tXqvAATdXlSSFwQkuxJ/BCX3d3H2WAx0RWWM1GejeF3A0bn+F
         dnSy9lA82Juycz5a59AOaj0pbHf2AHfBLos0JCLkT9AuB4ONriuURNuZBctckj5pn0Io
         c2f0Q16rnyOjSZCcfAVSIZNzfnwcV1KGB4kuC9xq6oItQ5gZnbbzT+r6zL2Cn0EuST1P
         8dpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=shX4IM4IxXnZAwFkwJE2OgpC7RVVTATTpnGlocR5V84=;
        b=CSOGktMUN/3oAT06y/XntP0mqClZAsua9VYtlXkswZoSzdu8elokTx3WOHDLdcvTu3
         /jyCvy9arfN5Jd5DTfCL7ZCwNu8ElGDD1K4zkRFRPJMQyKVghsCHT/dzNKvUOjfbIxK2
         dIMX80azf++LnXXrMBcUXL4r0LzyYTrIqIQJHkjR7mqNloVI2pbvlMqOHu/FjBUCJzs2
         x0l5RMxPwa+echUuZwRrytrJAAxHaCRqhg3srxWYRHjQ1KAcsXdV84a3UYOyQCkOHD8/
         vC3t74JbFihXH6R9/iP9ij+hsBTVNR4Mtv8mur3UIQ99CXJDnuwx/pSpF6bz7nK/CwyD
         2IHA==
X-Gm-Message-State: AOAM530Sp765oiv+tsTyYXNbodQCPh3Bcb4dTIGimXQcQKfichJ9AxRN
        TNfbUvekZzlZZYuxuH2qm46r8Q==
X-Google-Smtp-Source: ABdhPJzsDgilI6y9JHqYWD8OWuHEuuSPGf6T7DrE8s9gbzU5nzA3PXCrFJQcPnXqIIM0+lzgdBiksQ==
X-Received: by 2002:a05:6402:84a:b0:423:fe99:8c53 with SMTP id b10-20020a056402084a00b00423fe998c53mr22805247edz.195.1650957427148;
        Tue, 26 Apr 2022 00:17:07 -0700 (PDT)
Received: from [192.168.0.244] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id c3-20020a17090654c300b006e4e1a3e9d5sm4507003ejp.144.2022.04.26.00.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 00:17:06 -0700 (PDT)
Message-ID: <262fa922-0564-7dec-9558-b680480d0e67@linaro.org>
Date:   Tue, 26 Apr 2022 09:17:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v6 25/33] dt-bindings: crypto: rockchip: convert to new
 driver bindings
Content-Language: en-US
To:     Corentin Labbe <clabbe@baylibre.com>, heiko@sntech.de,
        herbert@gondor.apana.org.au, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
References: <20220425202119.3566743-1-clabbe@baylibre.com>
 <20220425202119.3566743-26-clabbe@baylibre.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220425202119.3566743-26-clabbe@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 25/04/2022 22:21, Corentin Labbe wrote:
> The latest addition to the rockchip crypto driver need to update the
> driver bindings.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  .../crypto/rockchip,rk3288-crypto.yaml        | 85 +++++++++++++++++--
>  1 file changed, 77 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> index 8a219d439d02..ad604d7e4bc0 100644
> --- a/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> +++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> @@ -13,6 +13,8 @@ properties:
>    compatible:
>      enum:
>        - rockchip,rk3288-crypto
> +      - rockchip,rk3328-crypto
> +      - rockchip,rk3399-crypto
>  
>    reg:
>      maxItems: 1
> @@ -21,21 +23,88 @@ properties:
>      maxItems: 1
>  
>    clocks:
> +    minItems: 3
>      maxItems: 4
>  
>    clock-names:
> -    items:
> -      - const: aclk
> -      - const: hclk
> -      - const: sclk
> -      - const: apb_pclk
> +    minItems: 3
> +    maxItems: 4
>  
>    resets:
> -    maxItems: 1
> +    minItems: 1
> +    maxItems: 3
>  
>    reset-names:
> -    items:
> -      - const: crypto-rst
> +    minItems: 1
> +    maxItems: 3
> +
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: rockchip,rk3288-crypto
> +    then:
> +      properties:
> +        clocks:
> +          minItems: 4
> +        clock-names:
> +          items:
> +            - const: "aclk"

No quotes (here and other places).

Rest looks good.

Best regards,
Krzysztof

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E377C4708B
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Nov 2022 12:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiK0Mo1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Nov 2022 07:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiK0Mo0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Nov 2022 07:44:26 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D226D13F
        for <linux-crypto@vger.kernel.org>; Sun, 27 Nov 2022 04:44:24 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id r12so13549664lfp.1
        for <linux-crypto@vger.kernel.org>; Sun, 27 Nov 2022 04:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B0wTjTX8oc9gsfhtWKd9yy7AK5Y3/IIhH17ZCu5fZx4=;
        b=T/PL1EZcdBp8VeEM1MTO7c2sNbEGNsfFvC9mNUOM5rg1dhvuw49Aw7AGDlZSYcT6T3
         jFHpNBuykUv9RlbpWubxI86pJNYVdnCrZ0/MerOYOcjk0Hkb0tqC2//5aAsDFqTLbdJo
         mz/8WeBpO73qlZ6UwPE/3u9wEYgoxvsP5M6knVNKmL7bH0EgZNu6LiMsiY8YcINwbqbL
         OjIeQ1i+tDaaKpq+DBRU7bIk/0T5OUDXIOQ3XPGz15fhoOXgvMHnwWVr24vOwx9eMwKa
         WBijznVtw8MqvbmeCgoyF1iwH0U1Kq/BvmZLJAmQCiOw/agPQruZ5LTMlZI7nlSjAbKl
         SYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B0wTjTX8oc9gsfhtWKd9yy7AK5Y3/IIhH17ZCu5fZx4=;
        b=w5jLAbkmxRxD7tKZIK3RGRUx5EggSwMngycrgo/muMSLokGoXyWZE2eAQzHl9dQtTn
         2vK0NyY/ZaMyl51vcDqg/mpcz8dPJMaY7EtFxwj5B3rs8+iV8qFWDGUVc26L65MUS0pO
         gSvEtw5jgyIjBaggHFY01M1vG6Cs/GzW1RpRcpneGt9EbWg9L+yWcOnSME3hFviKqpct
         8gx7uhnIf4Y1f4ri+T9R/vEXZQ16cH8U9VpCwEaqDeS4DSknU3LqJNq4lQ0FWRjN7dJJ
         X++zmSxJVvaU1HoxNv9GVffL09WpcIlqUt5Q+Eqp9/Dz23Nv3ys1VXU+9twlaODEhlwu
         JOJg==
X-Gm-Message-State: ANoB5plDgS6yViE3dbgP6rYZwdgV8FeAcu62x5e+8oZo8yQiSiCLyy2V
        GoH0kWwCizxv1HWMCnNHhwlTUw==
X-Google-Smtp-Source: AA0mqf49suwCpWlASIE/0UTr+rlkpTx39rlWSFK+oskELfLcmKeB0DbRwxLGwAPoErfjqYD77rZcOA==
X-Received: by 2002:a05:6512:258b:b0:4b5:c8f:2b59 with SMTP id bf11-20020a056512258b00b004b50c8f2b59mr1812375lfb.536.1669553062933;
        Sun, 27 Nov 2022 04:44:22 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id m9-20020a056512358900b0049468f9e697sm1273347lfr.236.2022.11.27.04.44.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Nov 2022 04:44:22 -0800 (PST)
Message-ID: <a4ea3bd0-b716-5bda-c6c7-cad06e964fa1@linaro.org>
Date:   Sun, 27 Nov 2022 13:44:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 1/4] dt-bindings: crypto: Let STM32 define Ux500 CRYP
To:     Linus Walleij <linus.walleij@linaro.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
References: <20221125223217.2409659-1-linus.walleij@linaro.org>
 <20221125223217.2409659-2-linus.walleij@linaro.org>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221125223217.2409659-2-linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 25/11/2022 23:32, Linus Walleij wrote:
> This adds device tree bindings for the Ux500 CRYP block
> as a compatible in the STM32 CRYP bindings.
> 
> The Ux500 CRYP binding has been used for ages in the kernel
> device tree for Ux500 but was never documented, so fill in
> the gap by making it a sibling of the STM32 CRYP block,
> which is what it is.
> 
> The relationship to the existing STM32 CRYP block is pretty
> obvious when looking at the register map, and I have written
> patches to reuse the STM32 CRYP driver on the Ux500.
> 
> The two properties added are DMA channels and power domain.
> Power domains are a generic SoC feature and the STM32 variant
> also has DMA channels.
> 
> Cc: devicetree@vger.kernel.org
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Lionel Debieve <lionel.debieve@foss.st.com>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Drop the second (new) example.
> ---
>  .../bindings/crypto/st,stm32-cryp.yaml        | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
> index ed23bf94a8e0..6759c5bf3e57 100644
> --- a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
> +++ b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
> @@ -6,12 +6,18 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
>  title: STMicroelectronics STM32 CRYP bindings
>  
> +description: The STM32 CRYP block is built on the CRYP block found in
> +  the STn8820 SoC introduced in 2007, and subsequently used in the U8500
> +  SoC in 2010.
> +
>  maintainers:
>    - Lionel Debieve <lionel.debieve@foss.st.com>
>  
>  properties:
>    compatible:
>      enum:
> +      - st,stn8820-cryp
> +      - stericsson,ux500-cryp
>        - st,stm32f756-cryp
>        - st,stm32mp1-cryp
>  
> @@ -27,6 +33,19 @@ properties:
>    resets:
>      maxItems: 1
>  
> +  dmas:
> +    items:
> +      - description: mem2cryp DMA channel
> +      - description: cryp2mem DMA channel
> +
> +  dma-names:
> +    items:
> +      - const: mem2cryp
> +      - const: cryp2mem

Usually these are called rx/tx, but I understand you are documenting
existing usage from DTS or driver? In such case:

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>



Best regards,
Krzysztof


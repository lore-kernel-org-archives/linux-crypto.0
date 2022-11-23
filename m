Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3561EC43217
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Nov 2022 16:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239036AbiKWQNL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Nov 2022 11:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238875AbiKWQNJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Nov 2022 11:13:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28C26E568;
        Wed, 23 Nov 2022 08:13:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D89A61DEA;
        Wed, 23 Nov 2022 16:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953BFC433D7;
        Wed, 23 Nov 2022 16:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669219987;
        bh=fkTjWBvj8eK0AxwkvvHG9qSe5D21CdW6TK2ghXH+FIA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ds7jJ/VWbrQ9y8JZ/clo3yipZhTq9LfUKAKVRQNXlgmy/pt/crrASGmoEpNkxl99U
         mCfoIX38/fNVPko1LD8lALY5IWMepHpSpx8kENeNSkXxGMU6NpShIAX1ITTYQjUVSV
         /KTa32y6jIZwNDGuSJSTU31bTM+vE3/tFYId3JksmOUGHsW9x4z5O/rie5JYhZy7Hn
         0+2rj2WUVKq3RDgFi5aLpKeVW8mH6+KUvm+OrNRGEpP6pobJvVffihHWvxB/5N6OGj
         O9e1SioZYE5dnefv0Kv9HKU++WcgsbR00LXq/+CR2I/EI9ei+XkWacMh64TVTLmb/q
         FlP1phjivjh5Q==
Message-ID: <73df18a2-b0d6-72de-37bb-17ba84b54b82@kernel.org>
Date:   Wed, 23 Nov 2022 17:13:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1 1/4] dt-bindings: crypto: Let STM32 define Ux500 CRYP
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        devicetree@vger.kernel.org
References: <20221119221219.1232541-1-linus.walleij@linaro.org>
 <20221119221219.1232541-2-linus.walleij@linaro.org>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20221119221219.1232541-2-linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 19/11/2022 23:12, Linus Walleij wrote:
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
> Cc: Lionel Debieve <lionel.debieve@foss.st.com>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> This was previously sent out as an open question but
> nothing happened, now I send it as part of the STM32
> bindings, in a series making the Linux STM32 driver
> use the STM32 driver.
> ---
>  .../bindings/crypto/st,stm32-cryp.yaml        | 32 +++++++++++++++++++
>  1 file changed, 32 insertions(+)

Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC.  It might happen, that command when run on an older
kernel, gives you outdated entries.  Therefore please be sure you base
your patches on recent Linux kernel.


> 
> diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
> index ed23bf94a8e0..69614ab51f81 100644
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
> +
> +  power-domains:
> +    maxItems: 1

Are these all valid for other variants?

> +
>  required:
>    - compatible
>    - reg
> @@ -48,4 +67,17 @@ examples:
>        resets = <&rcc CRYP1_R>;
>      };
>  
> +  - |
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/reset/stericsson,db8500-prcc-reset.h>
> +    #include <dt-bindings/arm/ux500_pm_domains.h>
> +    cryp@a03cb000 {

Drop the example, it's almost the same and difference in one new
property does not warrant a new example.

Best regards,
Krzysztof


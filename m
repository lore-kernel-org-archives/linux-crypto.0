Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD4ECE7A81
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Sep 2023 06:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjIYG47 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Sep 2023 02:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbjIYG46 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Sep 2023 02:56:58 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55D7BF
        for <linux-crypto@vger.kernel.org>; Sun, 24 Sep 2023 23:56:50 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9a65f9147ccso700810966b.1
        for <linux-crypto@vger.kernel.org>; Sun, 24 Sep 2023 23:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695625009; x=1696229809; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L7WPHi+cU40K0cpq2z6xjT+pYbikoqD2eOCtsPV145c=;
        b=KLbiz+eutL0NrzJ10K1QldzNXoSc4ofF5FMGLcVuoHcuFPckAAZA/nMq2qKYfgNreP
         9Hwu5sFeX5rtF4v1IrIwBxgoURdUqvheNqc9Cgz9wZhAXYgu08jbSFGihCMGXGAGxHhf
         l9BDYGRGzlTn/UQDOoF483LY8nY50xyCa7CXavroVJqq8wn+xFRiysx9BJboHn9QabF0
         BS1sWNCEHau/aR7NYpOkBZie+oEonhtfOOfchS2+hEevGCcu4oYJeklYDGO3dXEJOB3C
         ZgwzV3lPUA+ypUVoEx44kzb9snvjPhhdsh4u8OMu384a9JGfG7NBxZ1E3kOdZuKHLCa+
         oC8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695625009; x=1696229809;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L7WPHi+cU40K0cpq2z6xjT+pYbikoqD2eOCtsPV145c=;
        b=ipqr/F1/ZaBkE687D4ElV0xIP624tNPwAPQNzWW5Z2P9X4jZJQN93+2jNlgaMVwufR
         oQ/7rJOmFTFE0Qo0Z8lR2YbRAJZe2tguDDIkH/wj0IUMcYzm8Zt06vNvopA5aBF/rAVg
         zhEONbPInhGtbaX7gMO6K1JUauRlXSJQxPVq6TIT1b9YcM4RWH3MrqqcpP8NMhZyZ/w8
         tLA1issyhSVvezNJ4t+zGpEbgKyIJrCftBRzE/fN9Z4gU9jBD/8NdnlDJfDwpjfFJozk
         bxYiAMxTS/s+k7jWbv6V/Mv3kIVKdi29eja3dcztxtqacS/oy4BEDz9j2o0scIx4uaxC
         zlfw==
X-Gm-Message-State: AOJu0YxZUWPzy4j2KfFeiOueiVJBX/e+vA/KxewtKIBAlGv9J3XWW8Gq
        R5GB/uy2+G9lDZ/FKgoSygcZvA==
X-Google-Smtp-Source: AGHT+IEKMwoW0elwx2fK4G2iKfyxbK5pK6eha13vKmmsNaUrxPXz5brsCWXqrRU8lEak95SeH0I7ew==
X-Received: by 2002:a17:907:272a:b0:9a5:d74a:8b0a with SMTP id d10-20020a170907272a00b009a5d74a8b0amr5195178ejl.12.1695625009489;
        Sun, 24 Sep 2023 23:56:49 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.100])
        by smtp.gmail.com with ESMTPSA id g27-20020a170906349b00b0099bc0daf3d7sm5843290ejb.182.2023.09.24.23.56.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Sep 2023 23:56:48 -0700 (PDT)
Message-ID: <97009cf9-4c90-408d-8c6b-f07ce3dd9263@linaro.org>
Date:   Mon, 25 Sep 2023 08:56:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] dt-bindings: crypto: fsl-imx-sahara: Fix the number
 of irqs
Content-Language: en-US
To:     Fabio Estevam <festevam@gmail.com>, herbert@gondor.apana.org.au
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        conor+dt@kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, Fabio Estevam <festevam@denx.de>
References: <20230924223104.862169-1-festevam@gmail.com>
 <20230924223104.862169-4-festevam@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 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
 D2GYIS41Kv4Isx2dEFh+/Q==
In-Reply-To: <20230924223104.862169-4-festevam@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 25/09/2023 00:31, Fabio Estevam wrote:
> From: Fabio Estevam <festevam@denx.de>
> 
> i.MX27 has only one Sahara interrupt. i.MX53 has two.
> 
> Describe this difference.
> 
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> ---
>  .../bindings/crypto/fsl-imx-sahara.yaml       | 23 ++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
> index 9dbfc15510a8..9d1d9c8f0955 100644
> --- a/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
> +++ b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
> @@ -19,7 +19,10 @@ properties:
>      maxItems: 1
>  
>    interrupts:
> -    maxItems: 1
> +    items:
> +      - description: SAHARA Interrupt for Host 0
> +      - description: SAHARA Interrupt for Host 1
> +    minItems: 1
>  
>    clocks:
>      items:
> @@ -40,6 +43,24 @@ required:
>  
>  additionalProperties: false
>  
> +allOf:

This goes before additionalProperties:.

> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - fsl,imx53-sahara
> +    then:
> +      properties:
> +        interrupts:
> +          minItems: 2
> +          maxItems: 2
> +    else:
> +      properties:
> +        interrupts:
> +          minItems: 1

maxItems is enough.


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof


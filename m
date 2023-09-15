Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F4C6EE6456
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Sep 2023 10:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbjIOKde (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Sep 2023 06:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjIOKdd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Sep 2023 06:33:33 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A3EA8
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 03:33:27 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-99c136ee106so259895466b.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 03:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694774006; x=1695378806; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AHNXmBxDw1apCLxAkHOvDRkSwOFlN5lNz8sn0ic2gIM=;
        b=VPsVL5xRkvbuvEgWP0ER5qiuhLMWxCjPNEeFcFdGl/JkhtMlJaYfpRkkzH6Di2OMNm
         aByN0vvnplJuNI9Ezt322xJasx7pkndsOn1z1DaLi3XC2O38SC3CR/GS0vj2NgG5l5Vw
         gyuVJhFFDBQbP0+COl2imyqZF1HW6D2ZCm2jx8zKl+jSLTKywCrBFC49t70UPkhVpMZI
         AhfTbClL6fjWnptS/eDw0WD3vviUrWcg7PEdavIBlK5txrIjWL5oG2ER9AKPp0/MZA5y
         Jvul2gadtuS+FNmfkwZsCD7oqlPoAKdJJy4gPkS6Fwy3/UTKOOJBcKrSsNhlIwHgUbQ+
         0HPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694774006; x=1695378806;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AHNXmBxDw1apCLxAkHOvDRkSwOFlN5lNz8sn0ic2gIM=;
        b=B3TyoNhOKuifNpn66fEALDfOTSL04zRp9rybYLU55TKFQcOwibcGofYC9uD+1lCGCz
         2cFsCoPQ45lBLRj9/ZKr8zV+SVKzYN9WZoO5SqisQ9xLhhpbP0+R8fiiWRT4ybgLLg1/
         vlwIjjwgG5auwJhCl4anSp4ixKHMAS5RayCGZC7H0CHmJPStg+dvjrUplEOcDET9xwW5
         MSZUGxd540Gy309V6VBte4xw3r4zG1dU+m50I/x7WnLpJqQFJHEJuSc7U8NIJPafBAmT
         7Qcqfb3IPa3gPVXs7JO0CRbZQbdJg0JrCPUMfscb3kWcDX8GEq2m9bidbUErOgJ+jjrH
         qYGQ==
X-Gm-Message-State: AOJu0YzDTwETbxI0zrM81PRQuohv5zcn6g7qa318wdxXiffWTNEoMeLO
        09VUq9Agn6b/k5Wu5qbttQZ9Dw==
X-Google-Smtp-Source: AGHT+IHJvOEsaBTHM8g8l1b4WaIw/WLvZKGU9znyrRyylohvQ/GtYWnnh3DUhsMGba8RbxKv1HP+iw==
X-Received: by 2002:a17:906:18aa:b0:9a5:d657:47e1 with SMTP id c10-20020a17090618aa00b009a5d65747e1mr1032731ejf.43.1694774006100;
        Fri, 15 Sep 2023 03:33:26 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.214.188])
        by smtp.gmail.com with ESMTPSA id n4-20020a170906088400b009928b4e3b9fsm2232224eje.114.2023.09.15.03.33.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Sep 2023 03:33:25 -0700 (PDT)
Message-ID: <726e7f51-ce2c-5ac1-5347-21d6cf40c8c8@linaro.org>
Date:   Fri, 15 Sep 2023 12:33:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 07/10] dt-bindings: rng: add st,rng-lock-conf
Content-Language: en-US
To:     Gatien CHEVALLIER <gatien.chevallier@foss.st.com>,
        Rob Herring <robh@kernel.org>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20230908165120.730867-1-gatien.chevallier@foss.st.com>
 <20230908165120.730867-8-gatien.chevallier@foss.st.com>
 <20230911150958.GA1255978-robh@kernel.org>
 <4819d89b-c2a4-0c75-27e1-d8122827ceca@foss.st.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <4819d89b-c2a4-0c75-27e1-d8122827ceca@foss.st.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 15/09/2023 11:28, Gatien CHEVALLIER wrote:
> Hello Rob,
> 
> On 9/11/23 17:09, Rob Herring wrote:
>> On Fri, Sep 08, 2023 at 06:51:17PM +0200, Gatien Chevallier wrote:
>>> If st,rng-lock-conf is set, the RNG configuration in RNG_CR, RNG_HTCR
>>> and RNG_NSCR will be locked. It is supported starting from the RNG
>>> version present in the STM32MP13
>>
>> This should be squashed into the prior binding patch.
>>
>>>
>>> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
>>> ---
>>>   .../devicetree/bindings/rng/st,stm32-rng.yaml      | 14 ++++++++++++++
>>>   1 file changed, 14 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
>>> index 59abdc85a9fb..0055f14a8e3f 100644
>>> --- a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
>>> +++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
>>> @@ -37,6 +37,20 @@ required:
>>>     - reg
>>>     - clocks
>>>   
>>> +allOf:
>>> +  - if:
>>> +      properties:
>>> +        compatible:
>>> +          contains:
>>> +            enum:
>>> +              - st,stm32mp13-rng
>>> +    then:
>>> +      properties:
>>> +        st,rng-lock-conf:
>>> +          type: boolean
>>> +          description: If set, the RNG configuration in RNG_CR, RNG_HTCR and
>>> +                       RNG_NSCR will be locked.
>>
>> Define the property at the top-level and then restrict its presence in
>> a if/then schema.
>>
> 
> Can you please point me to an example of such case. I can't find a way
> to define at the top-level the property then restrict it to specific
> compatibles.

You can check my slides from the talks about not reaching 10 iterations
of bindings patches.

Or open example-schema (this should be your starting point):
https://elixir.bootlin.com/linux/v5.19/source/Documentation/devicetree/bindings/example-schema.yaml#L212


Also:
https://elixir.bootlin.com/linux/v6.4-rc7/source/Documentation/devicetree/bindings/net/qcom,ipa.yaml#L174
> 
> Else I'd change
> additionalProperties :false to
> unevaluatedProperties: false
> 
> so the definition of the property is seen.

No, why? Definition is there when you move it to the top as asked.

Best regards,
Krzysztof


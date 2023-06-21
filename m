Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8ACEEB64D7
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jun 2023 06:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjFUGk3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Jun 2023 02:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjFUGkP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jun 2023 02:40:15 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1D5E41
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 23:40:14 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-989d03eae11so96969866b.2
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 23:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687329612; x=1689921612;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9949oLksZdjy8Az+Gl4mT3bNK7xXkV+1bNbAiYdMeMU=;
        b=X4JW/wGentX5X6jWe55iAHxs2NuH9xINsbENMRv84UCoi2Csxefpn3NgRW6T/5hwqG
         SzUvyjER6ddpAK66tgEF/Jztj49hzX2328fqQhz/qyZCN/fvBsinZXd2ykyw6JxWU0nl
         //iFwDjM51TcNFXEQs758RyuI3+ffFHbXtjyRbU4Xkrk4sqJLjNgGEU83BqBWdS6MAuv
         n7AaKWiSwh/GdInDqq7ec0ZUa9RtKiZvrPbGLCxQv+WNIKiWVmLGPblE7Ae/CeWtwXGI
         +mA8Vv4mY+cam5RCSnZ3C4YtC4kn+5/5lbBYKqCZMdajUMi65C884xOxIfryS3qDR4u3
         VFaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687329612; x=1689921612;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9949oLksZdjy8Az+Gl4mT3bNK7xXkV+1bNbAiYdMeMU=;
        b=kC6lCnlmOuDfqqSlDL5c6cbA2bmzjmgReaioa2qAsPn0Uu9zz6PvRdt2aV+qGWyJSg
         3usUw8Rfmf+RaUOJTZCP3+AvZuKuy7gOVrejWFudTZrnsuwS8cOllfRpz8Rdgp0SmmGO
         nwgcyJgESnJdTtN4hm7mS2U5dIWlFdQZO3Xqbpet2Bmf9vyXgYY9bGmOarBBIBZ6A+g2
         GOafaM5Fo63yM0LEcnfZK1n5rHM384KLsKfoMbhNAwchZg1keNmaHGqQBFicj0b1Jn8T
         7OJovESxg7F9VMTFsZ6hN5qnYEzjjBc64/iL/0WMbYQsnAHbpvWpwfA4qdou8E++lRVO
         /p+g==
X-Gm-Message-State: AC+VfDyEhJPxynbAqoAh7t/cwfcFpL2IQ7TanT3grTDH/RlN5Fs7C0Zz
        gSr2CSMzcuGWta1UpkRcHn5D6Q==
X-Google-Smtp-Source: ACHHUZ6ObrfThgT2NojmF8WfZ2mmQ6Fno7w71HjfXpQ6Kr2k2PDCjJEcAXwuA/qcB3rEO5Evwd7G7w==
X-Received: by 2002:a17:907:9726:b0:987:788d:7e1f with SMTP id jg38-20020a170907972600b00987788d7e1fmr10904022ejc.77.1687329612568;
        Tue, 20 Jun 2023 23:40:12 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id z19-20020a170906669300b00977c7566ccbsm2546915ejo.164.2023.06.20.23.40.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 23:40:12 -0700 (PDT)
Message-ID: <89143a15-6368-0de3-5d76-a942fe877583@linaro.org>
Date:   Wed, 21 Jun 2023 08:40:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] dt-bindings: crypto: intel,ixp4xx: drop unneeded quotes
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230609140745.65046-1-krzysztof.kozlowski@linaro.org>
 <20230609225442.GA2588193-robh@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230609225442.GA2588193-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/06/2023 00:54, Rob Herring wrote:
> On Fri, Jun 09, 2023 at 04:07:45PM +0200, Krzysztof Kozlowski wrote:
>> Cleanup bindings dropping unneeded quotes. Once all these are fixed,
>> checking for this can be enabled in yamllint.
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> ---
>>  .../devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml         | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> You missed $id and $schema values.
> 
> Within drivers/crypto, there's also:
> 
> diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml b/Documentation/devicetree/bi
> ndings/crypto/amlogic,gxl-crypto.yaml
> index ecf98a9e72b2..948e11ebe4ee 100644
> --- a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> +++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> @@ -19,8 +19,8 @@ properties:
>  
>    interrupts:
>      items:
> -      - description: "Interrupt for flow 0"
> -      - description: "Interrupt for flow 1"
> +      - description: Interrupt for flow 0
> +      - description: Interrupt for flow 1
>  
>    clocks:
>      maxItems: 1
> 
> Can you add this in here. No reason to split this up more that 1 patch 
> per subsystem really. 

I'll add it. I am also fine for you to squash it or take your scripted
changes/commit if you have it ready.

Best regards,
Krzysztof


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 654D7C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jun 2022 09:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350095AbiFAJTN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jun 2022 05:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245604AbiFAJTM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jun 2022 05:19:12 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D9F17A97
        for <linux-crypto@vger.kernel.org>; Wed,  1 Jun 2022 02:19:10 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id rq11so2466469ejc.4
        for <linux-crypto@vger.kernel.org>; Wed, 01 Jun 2022 02:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=w0q7w7agqeVzeJoFI0aW/0pLwg+C1kvsWYmBalugg8Q=;
        b=VixWWPTJ2XezaiMDn6QH/mc8juwDFuC9uioDoU9V+mrWz6fabTxHi48gVF79fLkNZI
         CAEjE4jKF00zgp2R4UuRtTGQ/V2DI9Wa6gfA8F0TkWEPQA58c1oHeIwhZFYibE4CuRTN
         50joB2Zrq8ilMbr0GLmGfkchBBwuKjG/57DOTnBEr0zMiRcYrofNk933/tjhE6RX1A7x
         bLhyouUfCQCxLBhzjHo7kDDau9QgFwxecgC1mSCpMa12H5P+EdtH9vNDg2PcVGvxwDeu
         y3dptNbRzcQ1FMT4qajLIVJTLchACkZhMaHHabSNjF/6TCbkzeoi4pCduF/NGL07I2nF
         x/DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=w0q7w7agqeVzeJoFI0aW/0pLwg+C1kvsWYmBalugg8Q=;
        b=3yIf8dHf/zGGi5HyRRV0LtuTU5RkaQklCUL11P+egl8WkWUSsTUtBpfibXH+3CB0kV
         HP8q8XVuZ6qCJvtgnvZ7Okxpd4feGuYTIqomin2dWUv4TeY8CSCemSrxiqks0qLfKRYZ
         BRvy+TkZxlJHplYZBaIB0WxpJiaaPt1qCutnbgennhTF9uXVH0hZVI6D0GfQPgwO8X9Q
         iWDy07McCZdVZ33/CIHj6EQ4tGAyOkS6Gq886riLwUuXKB1ZmtiRYkCojVhC49bl7tR0
         JLJtLw9VqUnMDk0mJpbL3togTkya9fvXp5G2Um+bB3vNiNaRG9Mwo2WOhdCktsgB4fL+
         Qz+A==
X-Gm-Message-State: AOAM5318imWyj+1sfUkSqgU5z6SXlp995ekl6k+hSTZSsXkNw9CMoA+B
        e261kun3RORJr4nuaT/+mOCXBQ==
X-Google-Smtp-Source: ABdhPJxIz5yKljtZ01n/8e8Iqvz6i01vdsc3Tj+8YIjD1XxI182o5dWwgzHRLoMv1YfZoH7CLyT2yA==
X-Received: by 2002:a17:907:7f20:b0:6fe:f0c8:8e6f with SMTP id qf32-20020a1709077f2000b006fef0c88e6fmr40303647ejc.453.1654075149570;
        Wed, 01 Jun 2022 02:19:09 -0700 (PDT)
Received: from [192.168.0.179] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id u9-20020aa7d889000000b0042b5cf75d6esm630769edq.97.2022.06.01.02.19.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 02:19:09 -0700 (PDT)
Message-ID: <d1ffbc04-0c80-369e-a1dc-e47e50f52340@linaro.org>
Date:   Wed, 1 Jun 2022 11:19:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4/5] dt-bindings: crypto: add documentation for aspeed
 hace
Content-Language: en-US
To:     Neal Liu <neal_liu@aspeedtech.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Johnny Huang <johnny_huang@aspeedtech.com>
Cc:     "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220601054204.1522976-1-neal_liu@aspeedtech.com>
 <20220601054204.1522976-5-neal_liu@aspeedtech.com>
 <dca283db-0b2e-1fc1-bc76-811c4c918fb5@linaro.org>
 <HK0PR06MB3202D6A6C66480BF60ED829080DF9@HK0PR06MB3202.apcprd06.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <HK0PR06MB3202D6A6C66480BF60ED829080DF9@HK0PR06MB3202.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 01/06/2022 10:01, Neal Liu wrote:
>>> +  clocks:
>>> +    maxItems: 1
>>> +
>>> +  clock-names:
>>> +    maxItems: 1
>>
>> You need to list clock names, however usually it does not make sense to have
>> names for just one main device clock.
>>
> I think list clock-names is optional, I'll remove it from required list.

I actually suggest to remove the clock-names property entirely, if is
has one generic entry called "clk" (or "vclk" - the same). Do you
already expect adding here more clocks?


Best regards,
Krzysztof

Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9538DEE4993
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Aug 2023 13:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbjHUNAW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Aug 2023 09:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235141AbjHUNAW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Aug 2023 09:00:22 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E65D9
        for <linux-crypto@vger.kernel.org>; Mon, 21 Aug 2023 06:00:19 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4ff88239785so4867557e87.0
        for <linux-crypto@vger.kernel.org>; Mon, 21 Aug 2023 06:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692622817; x=1693227617;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AXD55IpQ28QwNaboUgeu7XR1+/pauVVuQAUGdvfKMhg=;
        b=Ygwtv8D0TjK96w1FQMJHQ8rfc/KAgYm2J4UHXbbreZl7Y8nTkY/ra4rjcS93cA3Fs7
         jq4EbElhUL7ZEAU1Uo+LVrx7Al+sOKteGStraBhO0JKsk7+LL0B6D/spne7tEl2W8iOL
         TgbbanpvP8PpLWGUBKSkaU9VTQRR636WW3CSDfhvQjfVJ6S8JX3UDgl+zRROFIPvvg8w
         WVehxdeZBKktG5JlhdflMf5dBDfyK7lqLf1IZDZttQbFV/IHKSsD4rMGP4jaIhyMoOAY
         4/AiDaSz2PKz1PoW6tDlu1p387M8GpCNpHCXvoZt0ZZ9SA3lcsoTd/Pdzrbn4riwx5E3
         SO8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692622817; x=1693227617;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AXD55IpQ28QwNaboUgeu7XR1+/pauVVuQAUGdvfKMhg=;
        b=XvowYWgirH0VfEx1VrT2qcRLbGwfJHuUA0jVJl5cNTST7IL2EIvfgdHqmJX2JI0lXo
         Xxojyn3haBosZV7KB3A2AaNQ2X+N3ClV9fXdFTkajtQP5iNli6Veq70fkQiTK4GAubI8
         5/rjUU8fvnA3USO/ivh8btoNX6JMTbIfDKKy4ef+P80ig1nMgd5fAJ0o5pl7VFv9GbpE
         o4tqM5GIVncqDXJYK+dJ0s4/mXBxU5BJusAM1BqUUWCv9LZRGeXBydclGRyh0YFDQz9s
         4c5aMOfPYTtOwfvo7gaF2jmsOROHqniUEx57UeOVxvvv45oWbbwbNj0bWmetJCuvNcGB
         aiEw==
X-Gm-Message-State: AOJu0Yz5R6SiAxCj6qpwj0F52aYM8QNT+FrPfIP2sIZTYHbVudGdhFeF
        46UoEYDmc1lgkRLGs03SQDspDg==
X-Google-Smtp-Source: AGHT+IEso7aKT7I1eVkoH1fesBsxFN+42Ir0Pvzb2Q+oH9fL/5fQI8T3LD4xRCNGC7DIcrEbuBwr3w==
X-Received: by 2002:a05:6512:3d8a:b0:4ff:793f:fbf8 with SMTP id k10-20020a0565123d8a00b004ff793ffbf8mr5838272lfv.51.1692622817567;
        Mon, 21 Aug 2023 06:00:17 -0700 (PDT)
Received: from [192.168.2.107] ([79.115.63.107])
        by smtp.gmail.com with ESMTPSA id b7-20020a170906d10700b00992d122af63sm6495471ejz.89.2023.08.21.06.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Aug 2023 06:00:15 -0700 (PDT)
Message-ID: <697712da-bff9-4621-28ac-9c9f68a76e43@linaro.org>
Date:   Mon, 21 Aug 2023 14:00:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v3 11/50] dt-bindings: crypto: add sam9x7 in Atmel TDES
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Varshini.Rajendran@microchip.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        alexandre.belloni@bootlin.com, claudiu.beznea@microchip.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20230728102442.265820-1-varshini.rajendran@microchip.com>
 <09bd1388-02aa-32c7-319e-d7150a0f3e9c@linaro.org>
 <1ec901d0-44c2-1d28-5976-d93abfffee67@microchip.com>
 <37782447-43c7-50f9-b9b4-5fbca94ce8c6@linaro.org>
 <96033a59-a2ea-c906-a033-84119c5783d7@linaro.org>
 <adeed0b2-e09b-78cf-ebfd-08d3949ca9ea@microchip.com>
 <57e9a9ff-26ed-62d1-91f8-cd5596f1c308@linaro.org>
 <5235260c-8fd6-2b2a-58b9-703191fff526@linaro.org>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <5235260c-8fd6-2b2a-58b9-703191fff526@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 8/21/23 13:10, Krzysztof Kozlowski wrote:
> On 21/08/2023 11:54, Tudor Ambarus wrote:
>>>>>> I am aware that there is no change in the crypto IP used. This patch is
>>>
>>> Actually, recent history showed us that it's not only the IP itself but
>>> its integration into final product that could have an influence on the
>>> behavior.
>>>
>>>>>> to add a SoC specific compatible as expected by writing-bindings
>>>>>> guideline. Maybe a bit more explanation in the commit description might
>>>>>> do the trick.
>>>>>>
>>>>>
>>>>> So you add a compatible that will never be used just to comply with
>>>>> the writing bindings guideline?
>>>>
>>>> How do you know that it is never going to be used? The guideline asks
>>
>> See
>> https://git.kernel.org/pub/scm/linux/kernel/git/at91/linux.git/tree/drivers/crypto/atmel-tdes.c?h=at91-dt#n1120
> 
> What's there? One compatible? How does it prove that it will not be
> used? It only proves that currently it is not used... And anyway this is

Correct, as of now the compatible was not used to determine the hw caps,
the capabilities were retrieved by checking at runtime a version
register. I'm against adding a compatible that will not be used, in this
particular case, defining "microchip,sam9x7-tdes" in the driver but
still solely relying on the runtime version register interrogation.
Unfortunately the commit message does not reveal any intention and from
there these emails changed. Maybe it's just a matter of personal
preference, so I'll stop commenting on this.

> just one implementation in one system. How can you possibly know all
> other possible implementations (other bootloaders/firmwares/systems)?
> One cannot. The guideline is there for specific reason.
> 

I didn't say the guideline is wrong, I just tried to understand how this
particular case is handled.
> 
> 
>>
>>>> for this on purpose, so any future quirks or incompatibilities can be
>>>> easily addressed.
>>>
>>> In this recent case, having a an adapted compatibility string is an
>>> added value.
>>>
>>> And yes, I changed my mind and would like to be systematic now with
>>> at91/microchip DT compatibility strings. Our long history and big legacy
>>> in arm-soc is sometimes difficult to handle, but we're moving little by
>>> little to comply with guidelines.
>>>
>>> My conclusion is that Varshini's addition is the way to go.
>>
>> Ok, fine by me. Then it would be good if one adds compatibles for the
>> previous SoCs as well and add a comment in the drivers that inform
>> readers that the atmel_*_get_cap() methods are used as backup where
>> "atmel,at91sam9g46-" compatibles are used. You'll then have all the
>> previous SoCs have their own dedicated compatibles which will have
>> "atmel,at91sam9g46-" compatible as backup, and "sam9x7" will be the
>> first that will not need the "atmel,at91sam9g46-" backup compatible.
>> In the drivers you'll have 2 flavors of identifying the IP caps, the
>> first one that backups to atmel_*_get_cap(), and a second one where
>> of_device_id data will suffice.
>>
>> If the commit message described how the driver will handle the new
>> compatible, Varshini would have spared us of all these emails exchanged.
> 
> The driver does not have to handle the new compatible, because it is
> independent question. Although if you meant to explicitly say that

As you wish. I retrieve my NACK.

Cheers,
ta
> device is compatible in commit msg, although it is obvious from the
> patch, then sure.
> 
>> Varshini, please update the commit message in the next iteration and
>> describe how the driver will handle the new compatible.
> 
> Best regards,
> Krzysztof
> 

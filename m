Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E867C47088
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Dec 2022 10:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiLCKVv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 3 Dec 2022 05:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLCKVu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Dec 2022 05:21:50 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF347DA4A
        for <linux-crypto@vger.kernel.org>; Sat,  3 Dec 2022 02:21:48 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id n1so8048092ljg.3
        for <linux-crypto@vger.kernel.org>; Sat, 03 Dec 2022 02:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hmgt/iyu02rNPVNn3vYDUjZ04+GCE84QtQpd7vm6pdo=;
        b=KH2AYi5fpuGthg1ngm1jx+9SkH9FDx+tTssv/UjnujQEnEpN1s/jF9xLGeDU9LCKzQ
         br2taW9lq2iZ4ZbkjNlCDMoipETo2kv3XXE3btXdUvF48cbTzOvHKD/LCGqEl5JgVcCv
         bIqQl6aesp3EWu9XIHnOS/t6xM9cfgxG7YMPxYzLTpQROHbWke0LskkTa1vwKVQOo4Mg
         oKXDKgtgQSeVBeLQ213xKjKlAmeVrOMKzaE3Hmb1VfUZflGPBsh+Veb5y5aHQPtSd2gD
         GX1LHOI3hBApAwQD1iXbPgWgVUnNhmCwFLS0cI6wTx17zs/mpBvP7rRoHbn+pm4MOj5+
         Kxfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hmgt/iyu02rNPVNn3vYDUjZ04+GCE84QtQpd7vm6pdo=;
        b=NYpULlndSSEIGullt2aLfEAi5ogN/ljF3bS40zTCBr+XxwzzZn1Veyln9rWYX5+7Oq
         eYMekL8sHCHsotkWTTS83xkzbujtHFWb8n+cYOFjetR9kff2MAkST2JG2ZnIsMZHpszz
         2IwbIofNeE7aA2QzUqwPNDs90KYY8HLe7oMtSlTNcwpTomO3/vezkM7t4b5AuXlOsTcG
         ekASNj5cg3cWHkkH83XwleHZC6AfWcPYDa/gDt3mEXGSGHSTpJF/zBqQnxqZO8e/mGQ6
         4B/7NJgvZ6TVnDQkxFQW9BeXBwq50vaeNG51XHOSGgLp2tjVVSlPBN7jvMLbc7v50I/i
         nmuw==
X-Gm-Message-State: ANoB5pmSuqfkR9v+gVRor9o2Rz4ZHGHqUQVWFtylQ/G/LARi7/9cqxiM
        6RflTjLQzNTCDsOqSzMCYhWXqC96/7w1FUDVbTc=
X-Google-Smtp-Source: AA0mqf4NL6HSNAV5Dnug62cV144G7MGCTZ/rTlGmnPVWCawFZl0BbSvqNC1o0eUdKPmv+P+cINdEZg==
X-Received: by 2002:a05:651c:1590:b0:279:dfe:897a with SMTP id h16-20020a05651c159000b002790dfe897amr24703470ljq.365.1670062906985;
        Sat, 03 Dec 2022 02:21:46 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id m4-20020a056512358400b004b19f766b07sm1005571lfr.91.2022.12.03.02.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Dec 2022 02:21:46 -0800 (PST)
Message-ID: <ee72df94-aa01-9ac1-f74e-fbfa1e71d2a2@linaro.org>
Date:   Sat, 3 Dec 2022 11:21:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 1/3] dt-bindings: RNG: Add Rockchip RNG bindings
To:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Lin Jinhan <troy.lin@rock-chips.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "moderated list:ARM/Rockchip SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC support" 
        <linux-rockchip@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20221128184718.1963353-1-aurelien@aurel32.net>
 <20221128184718.1963353-2-aurelien@aurel32.net>
 <89b16ec5-f9a5-f836-f51a-8325448e4775@linaro.org>
 <Y4pQGRMzILrkRP/2@aurel32.net>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <Y4pQGRMzILrkRP/2@aurel32.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 02/12/2022 20:20, Aurelien Jarno wrote:
> Hi,
> 
> Thanks for your feedback.
> 
> On 2022-11-29 10:24, Krzysztof Kozlowski wrote:
>> On 28/11/2022 19:47, Aurelien Jarno wrote:
>>> Add the RNG bindings for the RK3568 SoC from Rockchip
>>
>> Use subject prefixes matching the subsystem (git log --oneline -- ...),
>> so it is rng, not RNG. Also, you are not adding all-Rockhip RNG but a
>> specific device.
>>
>> Subject: drop second, redundant "bindings".
>>
>>>
>>> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
>>> ---
>>>  .../bindings/rng/rockchip,rk3568-rng.yaml     | 60 +++++++++++++++++++
>>>  1 file changed, 60 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
>>>
>>> diff --git a/Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml b/Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
>>> new file mode 100644
>>> index 000000000000..c2f5ef69cf07
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
>>> @@ -0,0 +1,60 @@
>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/rng/rockchip,rk3568-rng.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: Rockchip TRNG
>>> +
>>> +description: True Random Number Generator for some Rockchip SoCs
>>
>> s/for some Rockchip SoCs/on Rokchip RK3568 SoC/
> 
> My point there is that this driver should also work for other Rockchip
> SoCs like the RK3588, but 1)

Driver maybe less, but bindings might not.

> it support for this SoC is being added and
> not yet available in the Linux kernel 2) it hasn't been tested.
> 
> Should we mark it as RK3568 specific (or rather RK356x) and change that
> once a compatible entry is added for the RK3588?

Describe what you are adding here, not something else.

> 
>>> +
>>> +maintainers:
>>> +  - Aurelien Jarno <aurelien@aurel32.net>
>>> +
>>> +properties:
>>> +  compatible:
>>> +    enum:
>>> +      - rockchip,rk3568-rng
>>> +
>>> +  reg:
>>> +    maxItems: 1
>>> +
>>> +  clocks:
>>> +    items:
>>> +      - description: TRNG clock
>>> +      - description: TRNG AHB clock
>>> +
>>> +  clock-names:
>>> +    items:
>>> +      - const: trng_clk
>>> +      - const: trng_hclk
>>
>> These are too vague names. Everything is a clk in clock-names, so no
>> need usually to add it as name suffix. Give them some descriptive names,
>> e.g. core and ahb.
> 
> Those names are based on <include/dt-bindings/clock/rk3568-cru.h> and

clock-names is not for the actual name of the clock feeding it, but
rather name of input of the device. Reader-friendly.

> other drivers seems to have used those for the names. But I understand
> that broken things could have been merged, so I am fine changing that to
> core and ahb.
> 
>>> +
>>> +  resets:
>>> +    maxItems: 1
>>> +
> 
> Regards
> Aurelien
> 

Best regards,
Krzysztof


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434C5C54EE9
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Sep 2022 17:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbiIVRaW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Sep 2022 13:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbiIVRaN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2022 13:30:13 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6019A9E7
        for <linux-crypto@vger.kernel.org>; Thu, 22 Sep 2022 10:30:09 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id a10so11916487ljq.0
        for <linux-crypto@vger.kernel.org>; Thu, 22 Sep 2022 10:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=3d4XtRz1UVTn9UF6tNTg+CLRSot5BsaX/kpuz1aoWSk=;
        b=gzyjrFUWv6sH5AP1pBpkvTbYf2jzgM5J6nmbzm5OLICG5oHqLOc42PB0JjTtgfVYQz
         BF/uvdqnVUjIG0gUSDXOAGX43nM6ksXQIiY1tSzXR1SMOmRV5qUiDglZFJX41AHE3giu
         tg/8D7PwcQb91U9TFbzIK7dI4g4owsWB+m2N+6yfrX+ZQdJ2gu9iY63t5Yq16lfgOhyE
         0Dh288gd7F5g/9azqxGNWT9Vw9AZd7/KGEigtoukXStyVge9qfZvf9M4unSyF+lhL/Hs
         AjpOOO/Vvn6DR5nNwV7Y3lC+pNxU9oAWVvO2ucAaZXVvRZzPcLjP7UaIuHmIFAASf5QE
         O7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=3d4XtRz1UVTn9UF6tNTg+CLRSot5BsaX/kpuz1aoWSk=;
        b=IF8k7lCJ53g2BKz07dcYwmEq5WUhYyJI5r3JsktEhZWqNNY4CpHiLwjBySC26fV4RT
         +gRkczCwNGHR0sinOXdcp5aINYSS9GR7OZpylIsVXszbpz3PYQ2X4Q2H83Fn6DrKRqus
         QPBTR9xHg8dzN1Whk4FUTWKv7IYt8nNOdkNi0jbV7CF1KPmQFBTAXXJEM3vXVFUdvYnL
         gGITl8E1RbBofZm1RtVuWxXkLqb3hav/G2EWswBWMQX+3jFvuGELDlDr6A4CoWRyFbHY
         okpPjtkmW4FLNSrhYm94un7xRFKSrWXyuBKFPTiHJN0oj25iEb5fDoBLrciOwYtY0/Zu
         l8Sg==
X-Gm-Message-State: ACrzQf2IoI5ObeNyzwne29mXaGj/aFoeiVDZ4UGgjAFiw65WuzpOEOMj
        3WnLhai6qBMtWgkHbew/4EfxQQ==
X-Google-Smtp-Source: AMsMyM6UoHvK8OQptpz3VhwCgTvbTRlcBxKMUrZWJW1n57MxTQw07sco9Ija42Do0y41A8n03+5iNQ==
X-Received: by 2002:a2e:a54c:0:b0:26c:50c6:75c1 with SMTP id e12-20020a2ea54c000000b0026c50c675c1mr1540727ljn.408.1663867807861;
        Thu, 22 Sep 2022 10:30:07 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id h14-20020a05651c124e00b00266af46abccsm1011655ljh.72.2022.09.22.10.30.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 10:30:07 -0700 (PDT)
Message-ID: <14c980cf-314f-811f-98b8-18457625c2d6@linaro.org>
Date:   Thu, 22 Sep 2022 19:30:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v1 1/2] dt-bindings: rng: nuvoton,npcm-rng: Add npcm845
 compatible string
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Tomer Maimon <tmaimon77@gmail.com>, avifishman70@gmail.com,
        tali.perry1@gmail.com, joel@jms.id.au, venture@google.com,
        yuenn@google.com, benjaminfair@google.com, olivia@selenic.com,
        herbert@gondor.apana.org.au, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     openbmc@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20220922142216.17581-1-tmaimon77@gmail.com>
 <20220922142216.17581-2-tmaimon77@gmail.com>
 <29d54940-997a-865a-b9d0-c043a8c9ce99@linaro.org>
In-Reply-To: <29d54940-997a-865a-b9d0-c043a8c9ce99@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22/09/2022 17:08, Krzysztof Kozlowski wrote:
> On 22/09/2022 16:22, Tomer Maimon wrote:
>> Add a compatible string for Nuvoton BMC NPCM845 RNG.
>>
>> Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
>> ---
>>  Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.yaml | 4 +++-
> 
> 
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

And un-acked. Test your patches.

Please run `make dt_binding_check` (see
Documentation/devicetree/bindings/writing-schema.rst for instructions).

Best regards,
Krzysztof


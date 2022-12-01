Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D731C43217
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Dec 2022 09:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiLAJ1k (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Dec 2022 04:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiLAJ1j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2022 04:27:39 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D183C48
        for <linux-crypto@vger.kernel.org>; Thu,  1 Dec 2022 01:27:31 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id b3so1590672lfv.2
        for <linux-crypto@vger.kernel.org>; Thu, 01 Dec 2022 01:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MkZOQIDhzz/ZdyYHDjJhV18ycZ3HPCl9kL7HnUmPXkQ=;
        b=Le4uia54Oxpjs04IgYxInqhcUM1oreQs7cvQXaRwmX077/HQJuZEu3jMGfVNQpJgNE
         Onb/6iYKVkPVgX1O9QlqLwMSALb6UP2BLG4RJ0MpzoFBbTaXp16BFyI/xAzzTDJCO54u
         p8wG0PhdHHVsNDZsKJMP4JghIrx4VBq30/bfQvOELY2/Uqy1uNBJlLasLcC5vADjF3LK
         0WjBC9tgxvhMIvOB3h4wirI458DoFsPvk3YSTsjlWHYIAZgUUg+/yCyAFAwNNpQY5GNA
         YA8K9uUiyI0uNihy8NPgPKdrB5jYqZuOmIM24eZXwb1ZZW38aODbHowKkt+w2wFAzz6B
         BHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MkZOQIDhzz/ZdyYHDjJhV18ycZ3HPCl9kL7HnUmPXkQ=;
        b=OsSd9TWWq0Q6y/8kEsZKstWZnZqhME3Ds++wDyip2HarNBQpoNKD0bUE29s/XAXZ1o
         nZR0TQHAIzogn71mL69lFlykvPxCIMdw+IbVn6JQOhCx+Fx1szPU0D0y4/ePgrNZ3eG1
         Vd8jPFKp31HeeeBe2YlEtgMsNqkUnNW5LpKKSC+G/lM2FGt0nH4tph16vWSOZqPTyj7F
         FGwkT9TKgErWlDqx38k0HIOqx2JY5CIfer+gHGMAV9rHgBdUCSxVqYnZhsQKA95jD/mY
         OC4H1tvOzFIzs8KjZXz0aYMyH+3iwSeBQXMqS5uW7fJbXWnTqgvkyM5YiJasdQOOj0Ud
         0rQQ==
X-Gm-Message-State: ANoB5pmUMrXq3zeCI++oc236ZDjdzRLv8rFdPllgLknYVVbq7SZpf390
        uzA8aGdHGvkf9+afs87lRVpfDA==
X-Google-Smtp-Source: AA0mqf77KMFzjUsPmsFTBJD399USjthemEkZFhPHTyRnqjwDfIM4he7MzkqgIlD6tJlChwLNCC/jKQ==
X-Received: by 2002:a19:6b1a:0:b0:4b4:3313:feaf with SMTP id d26-20020a196b1a000000b004b43313feafmr21542327lfa.365.1669886849819;
        Thu, 01 Dec 2022 01:27:29 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id a25-20020a056512201900b004b4e9580b1asm589093lfb.66.2022.12.01.01.27.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 01:27:28 -0800 (PST)
Message-ID: <2886dd64-435d-1cdb-168d-5851c37dc538@linaro.org>
Date:   Thu, 1 Dec 2022 10:27:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 5/6] dt-bindings: crypto: Add bindings for Starfive crypto
 driver
Content-Language: en-US
To:     JiaJie Ho <jiajie.ho@starfivetech.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
References: <20221130055214.2416888-1-jiajie.ho@starfivetech.com>
 <20221130055214.2416888-6-jiajie.ho@starfivetech.com>
 <8a8f502e-e0ed-d638-0b56-74edcbca2134@linaro.org>
 <aa388c8c99b74436ad556aeb47a5c60a@EXMBX068.cuchost.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <aa388c8c99b74436ad556aeb47a5c60a@EXMBX068.cuchost.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 01/12/2022 10:01, JiaJie Ho wrote:

>>> +
>>> +  enable-side-channel-mitigation:
>>> +    description: Enable side-channel-mitigation feature for AES module.
>>> +        Enabling this feature will affect the speed performance of
>>> +        crypto engine.
>>> +    type: boolean
>>
>> Why exactly this is a hardware (DT) property, not runtime?
>>
> 
> This is a hardware setting provided in StarFive crypto engine only.
> The crypto API doesn't control this setting during runtime and leaving this always on will impact speed performance.
> So, I added this property to allow user to control this in dtb.

Devicetree should not describe policies, so without justification it
does not look like hardware property. Drop.


Best regards,
Krzysztof


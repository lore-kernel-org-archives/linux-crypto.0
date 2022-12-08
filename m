Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137C4C3A5A7
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Dec 2022 09:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiLHJ20 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Dec 2022 04:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiLHJ2R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Dec 2022 04:28:17 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8813E286C4
        for <linux-crypto@vger.kernel.org>; Thu,  8 Dec 2022 01:28:10 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id b3so1159523lfv.2
        for <linux-crypto@vger.kernel.org>; Thu, 08 Dec 2022 01:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jvonNZ8hzOsUtXfMS5jsK8oAXaTdy0VRFUTiOadKcQc=;
        b=h0SV4jEnf3LUyPMrtB7fSs0oyXBjNYnC+wPkJTrEpAUXeX5sXQrly2h9pmV/BaIy6R
         wtqelKyna1vNSa6KpgOzVcTBveTYzc2S67lbmsqmihry8Rub1uAALhMl94mCc+8wYSRJ
         TGMPDgtWtHtj+W7XZmvrbtxNjfh3A6iZ3Js7OJm47H9nJGn70bbwRnzdForlH+YFf6vZ
         uMGjvfiNmEKFuHLplsEo4aYd310onrCycBoGJB2C0dzRwqMPSWFQOLNyKPxj3A/tnnJa
         bwBNmh/BRjTXp6nA+hctAfSA6i37FFHqmeT1ZdXh+9ukwlTZwr1T+PdKCqQfXNMV9fF1
         uCTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jvonNZ8hzOsUtXfMS5jsK8oAXaTdy0VRFUTiOadKcQc=;
        b=jv+upHFMc93sMPRLMnmZxqe+vUeh7gQZsM3vXQ4WRlNp3Q3lLWZxfIrCgMKeqtSQey
         zqn/o2d1wWyRfVH/8dKfXne1LRlCqj1lcyGxp6LvpB5Aiuzo1qHB5PIjgVUfy/4z+g0l
         jlQl25m7OlRflcscDHA2SnGYmZt/qop2Hp++cma9mGkv/xHtnbPQi3CARTKJ8MMcFwmr
         PQnmbH+UBKCHmTNTe/Gw5sd8Q0ZS3xEAH/6m1N88logUFjfcZ6URhhVnRyTSF9Az9yuw
         EUKCnMWNhkcps0gLjtUiVL3yXyobz5X5KwVdQ1utHrMS1DnotGD+sv2flaO0tVrOCT2g
         0ctg==
X-Gm-Message-State: ANoB5pl7cLrSQUmcphclBAqm/dhizss1/7uynkstSs2r52eSC+kl5FAt
        AK5uzCJufiY69a2B8PQV88B+Rg==
X-Google-Smtp-Source: AA0mqf7TNvjfjrF7HrYj9ZQKhyCHR8PdEUqzTgbholw8jlR+OE7FkmeYXQJ4FF00PhAzDPAROjzt2Q==
X-Received: by 2002:a19:760b:0:b0:4b5:67d8:e3c2 with SMTP id c11-20020a19760b000000b004b567d8e3c2mr6935849lff.166.1670491688911;
        Thu, 08 Dec 2022 01:28:08 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id b24-20020ac25638000000b004b57bbaef87sm532100lff.224.2022.12.08.01.28.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 01:28:08 -0800 (PST)
Message-ID: <9c7066e4-fa3f-3dda-b939-04dfdaf73242@linaro.org>
Date:   Thu, 8 Dec 2022 10:28:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 0/6] crypto: starfive: Add driver for cryptographic engine
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
 <e1e9f1d19982493b89ae63f51e00a3bb@EXMBX068.cuchost.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <e1e9f1d19982493b89ae63f51e00a3bb@EXMBX068.cuchost.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 08/12/2022 10:09, JiaJie Ho wrote:
>>
>> The driver has been tested with crypto selftest and additional test.
>>
>> This patch series depends on the following patches:
>> https://patchwork.kernel.org/project/linux-
>> riscv/cover/20221118010627.70576-1-hal.feng@starfivetech.com/
>> https://patchwork.kernel.org/project/linux-
>> riscv/cover/20221118011714.70877-1-hal.feng@starfivetech.com/
>>
>> Jia Jie Ho (6):
>>   crypto: starfive - Add StarFive crypto engine support
>>   crypto: starfive - Add hash and HMAC support
>>   crypto: starfive - Add AES skcipher and aead support
>>   crypto: starfive - Add Public Key algo support
>>   dt-bindings: crypto: Add bindings for Starfive crypto driver
>>   riscv: dts: starfive: Add crypto and DMA node for VisionFive 2
>>
> 
> Hi Herbert/David,
> 
> Could you please help to review and provide comments on this patch series?
> Thank you in advance.

You received some comments so the expectation is to send a v2.

Best regards,
Krzysztof


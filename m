Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97650C47088
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Dec 2022 09:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiLAJ27 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Dec 2022 04:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiLAJ2u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2022 04:28:50 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4283B4E6B2
        for <linux-crypto@vger.kernel.org>; Thu,  1 Dec 2022 01:28:45 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id f13so1575729lfa.6
        for <linux-crypto@vger.kernel.org>; Thu, 01 Dec 2022 01:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jahb+tEShKBR+Ktu0BgJXy8O1SopxAlMcngu6tulhfo=;
        b=wzeuJx6xKm1tNX0R828wgisRm6UYpQssq1gEpjild2BMpZ3jiJEGbZBEyphN32yvVV
         TzR7uzCkl9HBZ5aazB219DCIvHAA3tDilXZHK5QSEnTM1J5GjbxWBHjsU7b8RG3qWgVh
         UuQuyHmJOfwhZTnSm4HJDKTS1uqYIB3z3xDZUcPR3qyTs3/oKBCapWI3kjvAlEpuM/Nb
         TsORs1tXAqJGAaAAuTnb7I8BESvchycQt+GQl8F+jRPvqdX+sBUfX1f/MHStul1Td2kB
         Ne8u+FRMrGYkvUZOMxYIIQ8hyn1GEyeRzpmRLIGs82XQAjSqkMXfrxd7nMtVBVDP0bps
         Uj7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jahb+tEShKBR+Ktu0BgJXy8O1SopxAlMcngu6tulhfo=;
        b=wime7mIsl7eWs/0qmUSFt3yT+G1v4pRPXe/Qgxe0R/gkh8EuJ5ZI297PwO0jxP5L0O
         e9YAUKkk/qvZW3sxrGviDO5fvECMi9lC9q7lpjKj10paMGjPPkA6jKPk6csVKjb49fXw
         IwAlKJEwdZDhcVelXwMHZPuBd2cGvHvkbJeBj8fIvgE5KbaNfD19yaSjOgGYzTsfao0X
         E70tB73koBc3DZ388X9idB80dUbHomehRqZ55/xwoMGe536r+NjqviAzVc3EMMLb+cnl
         zKamc5yt+3P3/YZnv5fsyRv+eAasI1kEFC1Pqrqf1pHPUBDKE6JkNZEU0aKNy0RWc2MN
         fYLg==
X-Gm-Message-State: ANoB5plx9GlusVJb/qRhwifhy1oIKJGE90loAKZQJW5FCFwi10br4a+z
        6PFXzxzEO2HxVPomfnLGkB6M9A==
X-Google-Smtp-Source: AA0mqf4GR2jAPIP63PrEu23oXP2Y1onMJ5uqoMQq16hLdEJ8d7BaYPyYOXgoM7GjnlGgp9qM6QC+XQ==
X-Received: by 2002:ac2:4e0e:0:b0:4b1:7c15:e920 with SMTP id e14-20020ac24e0e000000b004b17c15e920mr25286530lfr.453.1669886924183;
        Thu, 01 Dec 2022 01:28:44 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id o6-20020ac25e26000000b00492e3a8366esm589861lfg.9.2022.12.01.01.28.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 01:28:41 -0800 (PST)
Message-ID: <6028b265-bc8a-3a06-b17c-56aa772a4782@linaro.org>
Date:   Thu, 1 Dec 2022 10:28:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/6] crypto: starfive - Add StarFive crypto engine support
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
 <20221130055214.2416888-2-jiajie.ho@starfivetech.com>
 <aafb1c32-bc00-2db2-edbd-aa4771f33ac7@linaro.org>
 <60ad0da0116044d3a1fe575e9904e22c@EXMBX068.cuchost.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <60ad0da0116044d3a1fe575e9904e22c@EXMBX068.cuchost.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 01/12/2022 07:52, JiaJie Ho wrote:

>>> +
>>> +static inline u32 starfive_sec_read(struct starfive_sec_dev *sdev,
>>> +u32 offset) {
>>> +	return __raw_readl(sdev->io_base + offset);
>>
>> I don't think these read/write wrappers help anyhow...
>>
> 
> These wrappers are used by the crypto primitives in this patch series.
> I'll move these to subsequent patches when they are first used.
> 
> Thank you for spending time reviewing and providing helpful comments
> for this driver.
> 

Just drop the wrappers. I said they do not help and your answer "are
used" does not explain anything. If you insist on keeping them, please
explain what are the benefits except more code and more
indirections/layers making it more difficult to read?

Best regards,
Krzysztof


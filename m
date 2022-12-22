Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF273C4167B
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Dec 2022 09:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbiLVJoC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Dec 2022 04:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbiLVJnk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Dec 2022 04:43:40 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7341227B28
        for <linux-crypto@vger.kernel.org>; Thu, 22 Dec 2022 01:43:34 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id y25so1900041lfa.9
        for <linux-crypto@vger.kernel.org>; Thu, 22 Dec 2022 01:43:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YbnftUr0skysBxQQtBVmUp3dl+iPH1CkZ/Pevi319Z4=;
        b=tu5TQQc2y5XhDDuW5z1bMNpX9zKfROA3s5jKB9G0KQjOJuNM2bcBSmMPCvwgakyl5O
         uL6oS7md17Acf9ENu9PcB0kxW4Coynu1r1eUkQWdVgV1NSRIxpc8r+QvnR4n0GmhSPlz
         NW+6+Un28/jlsP/TVjS202yZFoW38ETk9BCzr60pUDqT+pMNb/+kBEme71AG7oFnBEvB
         tch9duUW2ZeBOftJyGZojAM7ZbJz//uWip1R8Qnald2rMy3Ip6hviGMJJAzxjZLLgMAZ
         cylKCWrrFaG2G1VV7AtoiPrpLACzWpYQOAkWKtkXXDPlXeyJd70fqFc/3+I+7CwnseFK
         ORvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YbnftUr0skysBxQQtBVmUp3dl+iPH1CkZ/Pevi319Z4=;
        b=nPeut9GVIaPxISoGFstSfJUJPOqSgeQ8QaLUPwcH6oerbvHc0MCsaTlNUU+KSNm7m9
         eQxD58eWcNlRFoQiyIuZb5pfBamOfg2o6RIe4rC1LKF8NZ2iX+ovPFQMXVMUcN+G5r9A
         UUuJxRSD105da/noCjsUGauXcUmViWq2fY5PyZy8JcDJ482l99H6JKQfPFwkUhg6RuUp
         9Jry9X1rtXvLAEPAJLYwa08W/pbClYoPMtV2XSf+w4X5z+OPySstJLXzC/anR24IhD7b
         JUH9bB8CRDUPh2UrDlDiwe1MM0UESaWd0y43FpHnTUqgG4Sp484m4/s+LZme932BJzQP
         di9A==
X-Gm-Message-State: AFqh2koaciNLXJchhNqMlcO796pDmOiB7pxaf4Vfc2RKW5Ib9DfXA/Py
        bygd8gbFEA8+VCZL7H1UCRmgEQ==
X-Google-Smtp-Source: AMrXdXtIO/l/UEsk2MV0XgK6wMm0UkQrCvnZKcwe7Ug7pLVDdSRQxWA3YLc4a7ZfaL4xaMUG9Yifzg==
X-Received: by 2002:ac2:4ecd:0:b0:4a4:68b9:6085 with SMTP id p13-20020ac24ecd000000b004a468b96085mr1334382lfr.16.1671702212876;
        Thu, 22 Dec 2022 01:43:32 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id z1-20020a0565120c0100b004b4b600c093sm15902lfu.92.2022.12.22.01.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 01:43:32 -0800 (PST)
Message-ID: <27f1c084-60b4-daeb-0ffe-c0500aecbd49@linaro.org>
Date:   Thu, 22 Dec 2022 10:43:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 2/3] hwrng: starfive - Add TRNG driver for StarFive SoC
Content-Language: en-US
To:     JiaJie Ho <jiajie.ho@starfivetech.com>,
        Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor.dooley@microchip.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
References: <20221221090819.1259443-1-jiajie.ho@starfivetech.com>
 <20221221090819.1259443-3-jiajie.ho@starfivetech.com>
 <05aaa9f8-7a97-51c9-e18a-1c3753f2006b@linaro.org>
 <69dca1be673a40729d750c00d927b437@EXMBX168.cuchost.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <69dca1be673a40729d750c00d927b437@EXMBX168.cuchost.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22/12/2022 10:35, JiaJie Ho wrote:
> 
> 
>> -----Original Message-----
>> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> Sent: Wednesday, December 21, 2022 5:49 PM
>> To: JiaJie Ho <jiajie.ho@starfivetech.com>; Olivia Mackall
>> <olivia@selenic.com>; Herbert Xu <herbert@gondor.apana.org.au>; Rob
>> Herring <robh+dt@kernel.org>; Krzysztof Kozlowski
>> <krzysztof.kozlowski+dt@linaro.org>
>> Cc: Emil Renner Berthing <kernel@esmil.dk>; Conor Dooley
>> <conor.dooley@microchip.com>; linux-crypto@vger.kernel.org;
>> devicetree@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
>> riscv@lists.infradead.org
>> Subject: Re: [PATCH 2/3] hwrng: starfive - Add TRNG driver for StarFive SoC
>>
>> On 21/12/2022 10:08, Jia Jie Ho wrote:
>>> This adds driver support for the hardware random number generator in
>>> Starfive SoCs and adds StarFive TRNG entry to MAINTAINERS.
>>>
>>> Co-developed-by: Jenny Zhang <jenny.zhang@starfivetech.com>
>>> Signed-off-by: Jenny Zhang <jenny.zhang@starfivetech.com>
>>> Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
>>> ---
>>>  MAINTAINERS                            |   6 +
>>>  drivers/char/hw_random/Kconfig         |  11 +
>>>  drivers/char/hw_random/Makefile        |   1 +
>>>  drivers/char/hw_random/starfive-trng.c | 403
>>> +++++++++++++++++++++++++
>>>  4 files changed, 421 insertions(+)
>>>  create mode 100644 drivers/char/hw_random/starfive-trng.c
>>>
>>
>> (...)
>>
>>> +static const struct of_device_id trng_dt_ids[] = {
>>> +	{ .compatible = "starfive,jh7110-trng" },
>>> +	{ }
>>> +};
>>> +MODULE_DEVICE_TABLE(of, trng_dt_ids);
>>> +
>>> +static struct platform_driver starfive_trng_driver = {
>>> +	.probe	= starfive_trng_probe,
>>> +	.driver	= {
>>> +		.name		= "starfive-trng",
>>> +		.pm		= &starfive_trng_pm_ops,
>>> +		.of_match_table	= of_match_ptr(trng_dt_ids),
>>
>> of_match_ptr goes with __maybe_unused. You will have now warnings, so
>> please test more your patches (W=1, sparse, smatch).
>>
> 
> Hi Krzysztof,
> 
> Thanks for reviewing this patch.
> How do I properly handle __maybe_unused functions in this scenario?

The same as in other files. Use `git grep`

> Will it help if I add #define as follows:
> 
> #ifdef CONFIG_PM
> #define STARFIVE_RNG_PM_OPS (&starfive_rng_pm_ops)
> #else
> #define STARFIVE_RNG_PM_OPS NULL
> #endif

I talked only about of_match_ptr(). This is not of_match_ptr and should
have its own syntax (pm_sleep_ptr + static DEFINE_SIMPLE_DEV_PM_OPS)

> 
> static struct platform_driver starfive_trng_driver = {
>         .probe  = starfive_trng_probe,
>         .driver = {
>                 .name           = "starfive-trng",
>                 .pm             = STARFIVE_RNG_PM_OPS,
>                 .of_match_table = of_match_ptr(trng_dt_ids),
>         },
> };
> 
> I did build the patches with the tools mentioned but did not get warnings.
> Do I need a specific version, or have I done something wrong?

You just need proper COMPILE_TEST config with OF disabled.

Best regards,
Krzysztof


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B453FC10F1B
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Dec 2022 09:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbiLUJx1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Dec 2022 04:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbiLUJwn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Dec 2022 04:52:43 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A649123392
        for <linux-crypto@vger.kernel.org>; Wed, 21 Dec 2022 01:49:25 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id g14so15046037ljh.10
        for <linux-crypto@vger.kernel.org>; Wed, 21 Dec 2022 01:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j4pOTa7XD14Zbi1zXxlhwo2uq1WAQLtH0H1dvVBr/wM=;
        b=TatoTF6KDCty9jYvwLHt8LUJBG4EfDHIWY7OIX8gecMCtklkbUY83XvdqNexPWzVHh
         7aHcj6cell6x9syMMMUvBbd8IhMjN1Ix2O2vsj7WocOoSuFZ648iIhqPZhcTYevUeYdq
         6oxyrVV/PxZazRP/iKy3JHVjRKyCE5XANvaaI2OcyddGsO58OUrq7Z5T494E2mOB2uqA
         F1ga1FNHs+RVzr2KiNpV9JxdgiuANgeWGzt978v2rBbuOVX9+jVyPWqwofW5nJEl0mFc
         2/TqloOr9Aav3Y6Y0mHnlbIVWq9I0gPrYXhF+V/yZ9FLrz0NcxH3wTQIHdsKqLB1okOk
         uYDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j4pOTa7XD14Zbi1zXxlhwo2uq1WAQLtH0H1dvVBr/wM=;
        b=Dlx9MBYXeY0S1Pe9KiFG1loVE6Z8YwDI9vP5xuAiB85ZldVb5tenzfxbfUn+TzodAb
         POvtB7nd3YAS8aOmxZrPqktuwfGVpu0YNEeMCtZ4n8Vx1yFXbj3KQcTrvqYwAOF+4/wQ
         a/SuHJbi7ER8oYXa2EeV7OgsBrYScYaTWmiKit3HZPVogkIfpC6cGReFJoephJGqKfOn
         LYUPoy+s7nsJWiVon7blTyy2S28loN+idT6bQyDFgYmqMRduNfXJMl4j4rrm0xqhIBjT
         OHL0Msb2go5kIlVs3t1xqLGW8AVrqEiwPdT0IflhyaobV6PmbF7HvWmfZTx+2zsaIP/S
         3nNQ==
X-Gm-Message-State: AFqh2kqu4VkH6oJphBb4qgxUS4igwVXxBivJBHH+d2KlEBcwgT8Nypc2
        JolTZ2LnTCsWU0+n3UiyU8IW9A==
X-Google-Smtp-Source: AMrXdXssO9jKbgSHpDGsWvD2A8uvCkDgxTfqEYUdI6PAsmQUFbP3WJ19muNo/XTSwSkvzcwBi9mWuw==
X-Received: by 2002:a2e:bc87:0:b0:27f:6978:583f with SMTP id h7-20020a2ebc87000000b0027f6978583fmr419058ljf.44.1671616164053;
        Wed, 21 Dec 2022 01:49:24 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id g5-20020a2eb5c5000000b00279a7266874sm1273754ljn.98.2022.12.21.01.49.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 01:49:23 -0800 (PST)
Message-ID: <05aaa9f8-7a97-51c9-e18a-1c3753f2006b@linaro.org>
Date:   Wed, 21 Dec 2022 10:49:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 2/3] hwrng: starfive - Add TRNG driver for StarFive SoC
Content-Language: en-US
To:     Jia Jie Ho <jiajie.ho@starfivetech.com>,
        Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
References: <20221221090819.1259443-1-jiajie.ho@starfivetech.com>
 <20221221090819.1259443-3-jiajie.ho@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221221090819.1259443-3-jiajie.ho@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 21/12/2022 10:08, Jia Jie Ho wrote:
> This adds driver support for the hardware random number generator in
> Starfive SoCs and adds StarFive TRNG entry to MAINTAINERS.
> 
> Co-developed-by: Jenny Zhang <jenny.zhang@starfivetech.com>
> Signed-off-by: Jenny Zhang <jenny.zhang@starfivetech.com>
> Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
> ---
>  MAINTAINERS                            |   6 +
>  drivers/char/hw_random/Kconfig         |  11 +
>  drivers/char/hw_random/Makefile        |   1 +
>  drivers/char/hw_random/starfive-trng.c | 403 +++++++++++++++++++++++++
>  4 files changed, 421 insertions(+)
>  create mode 100644 drivers/char/hw_random/starfive-trng.c
> 

(...)

> +static const struct of_device_id trng_dt_ids[] = {
> +	{ .compatible = "starfive,jh7110-trng" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, trng_dt_ids);
> +
> +static struct platform_driver starfive_trng_driver = {
> +	.probe	= starfive_trng_probe,
> +	.driver	= {
> +		.name		= "starfive-trng",
> +		.pm		= &starfive_trng_pm_ops,
> +		.of_match_table	= of_match_ptr(trng_dt_ids),

of_match_ptr goes with __maybe_unused. You will have now warnings, so
please test more your patches (W=1, sparse, smatch).

Best regards,
Krzysztof


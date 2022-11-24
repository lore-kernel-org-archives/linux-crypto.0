Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BDDC433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Nov 2022 11:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiKXLCw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Nov 2022 06:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiKXLCu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Nov 2022 06:02:50 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87171BCB0
        for <linux-crypto@vger.kernel.org>; Thu, 24 Nov 2022 03:02:43 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id be13so2017212lfb.4
        for <linux-crypto@vger.kernel.org>; Thu, 24 Nov 2022 03:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nu6pjkXIBFfjqNqFnOUYgw7nMcsD0pE0OGpEOCK7UF8=;
        b=g18UXMLu+HaZr5Vma7hCKLNfw8vE5DtyJQQ/h0wELeQztKUsZinIOYD0Emd571Ttaz
         G8gKTl4Gjfv1qddAZVO3V5bexes47auyNSgRTXKOFA86NLV4OWBnG9IySg8lw/SBqNR2
         6PnX/oZdvF05r2urpn9cDwRFY4lTHRC9NUOphPu+GJomqjVeCR67oNZPdO6U6XYaFViv
         cSLl3JDzwhR0gYG+PpVdE8ZNwH+pw2fU52yOyyPiANnlSXP5ypDsEtRIcm6t9u4lM4mm
         2qK/nbsG3QfaEEb8Qrp6NUkLU/PLhyZ5sjNo2AWS7bXDpvtI76RbrJIFzcVc0Y9wceiN
         bngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nu6pjkXIBFfjqNqFnOUYgw7nMcsD0pE0OGpEOCK7UF8=;
        b=clN0aRcP9ZhBDpAs6E6EVagscRAqfqzkvJszbpTdzNEbeICBzC+Xqx9Xf1zqz7CGOT
         TpFgoqGxu6CRhURdwGMfUNKhVikt5v3kl3LozZdwyoySJ2BneXKl4XkYh0sefAcL/jeN
         izXQJ7W6SyYLkXXnybRo6+bopaYoGDXKSAvUtN6KNiw0p5m9h/vBrp20+01tnNqrq9DH
         wbFLpJIAbuPv0a5wvnzrqlH4H7H475lXFs1gs2UZgSY1ad1qZpz0rHnTJD78uHQYM9lh
         MrRv9wlx0wlaFRAZ+jX+Up5z3OBAxrZdOYxvv6l9FYGEjGwlJfA/8QcXB3ikXZFUJ5/c
         LcEg==
X-Gm-Message-State: ANoB5pl5ZdwtG1DTh0aIZltwCMxba8Jzp46QtuHn3HjBZk8CVe4ek40x
        9SrTo+JylHrG/Cuccq2oSIPfsA==
X-Google-Smtp-Source: AA0mqf467/nJeQnupvv/69oKsa3gmbQrSZGWwkEVDwG8CorBpsO5lNOGph3XKFrZdmNiiKGZ18jCjg==
X-Received: by 2002:a19:7b0f:0:b0:4a2:3bed:2008 with SMTP id w15-20020a197b0f000000b004a23bed2008mr11520699lfc.88.1669287761901;
        Thu, 24 Nov 2022 03:02:41 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id f18-20020a05651c161200b00278e9c0d3a2sm73435ljq.33.2022.11.24.03.02.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 03:02:41 -0800 (PST)
Message-ID: <69540766-4fe8-cc21-f2bc-4ad04643e4b6@linaro.org>
Date:   Thu, 24 Nov 2022 12:02:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] MAINTAINERS: Update email of Tudor Ambarus
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Rob Herring <robh+dt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     herbert@gondor.apana.org.au, krzysztof.kozlowski+dt@linaro.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Mark Brown <broonie@kernel.org>, qyousef@layalina.io,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>, tkhai@ya.ru,
        quic_abhinavk@quicinc.com, vasily.averin@linux.dev,
        baolin.wang@linux.alibaba.com, colin.i.king@gmail.com,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org, linux-mtd@lists.infradead.org,
        pratyush@kernel.org, Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>
References: <20221122125244.175295-1-tudor.ambarus@microchip.com>
 <024e0a68-bb79-4e2e-84f8-f44afb759cdd@app.fastmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <024e0a68-bb79-4e2e-84f8-f44afb759cdd@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22/11/2022 14:15, Arnd Bergmann wrote:
> On Tue, Nov 22, 2022, at 13:52, Tudor Ambarus wrote:
>> My professional email will change and the microchip one will bounce after
>> mid-november of 2022.
>>
>> Update the MAINTAINERS file, the YAML bindings, MODULE_AUTHOR entries and
>> author mentions, and add an entry in the .mailmap file.
>>
>> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> 
> I can take this through the fixes branch of the SoC tree if that
> works for everyone. Alternatively, I can take only the MAINTAINERS
> and .mailmap bits and expect the other changes to get merged
> by the devicetree and crypto maintainers for 6.2.


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof


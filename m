Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B1DC04E69
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Jun 2023 07:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjFXH5f (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Jun 2023 03:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbjFXH5b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Jun 2023 03:57:31 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FC92942
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 00:57:28 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-987c932883bso180214466b.0
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 00:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687593447; x=1690185447;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i6/OKE3tdUs5NzQDJgtLHSJJGNPHgdjozA0WirJWwVM=;
        b=HnqNx/Ebwlv7O4a+MO53LVK8hUXaO2CscKgFVOdXu2ycnMg2hOS0E0CzugfJ3w99Sw
         NTpfcO8m4fcFu7MQn1RVPozmqJTrSYnumv9XZ//sHZFfnfQn38R8rBKcX9/41fMUm++e
         SMm77XYsnipU3YNETrH2NcLRyssL3zI6YmQzliflkWOFkjuhDWQKpw9oHLzSF4yxj1Zb
         0WHuZofFw0RlYyr3v57UovyHHwgejt7TDVz8L41/QVTNC3ruqQIFr/BZIHDOI2RPurVq
         m+m4zKhmQGGpjsiHNqKQ41IzwPemcQfTXtF/FSAXgnXXsxI/R+pb7QaK/NRZMzPQLBf8
         wzzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687593447; x=1690185447;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i6/OKE3tdUs5NzQDJgtLHSJJGNPHgdjozA0WirJWwVM=;
        b=lnD8m1PiNVT3oCj6HHBg9Xo04hnA4eocOe6iJa0RhjMgf6im5IdKNzQnwdWLbIK7qk
         BlgabFhzGoo5pg/bP0xfm5NWJAfgYpfmAMngYn3ccpwzlXVZxyKy26UsfFplCbt6O/V2
         /8gJwXdzB3AebnPbyL9UKwtIANNayaPkxzYzt/+blQxNO+yJ1aYgNSg83twA7TTP58Nk
         QFfvjpoifbNZ+7aBDKGE6d3XOfmFtJAmlD49EpBRRnBd5gM2RmXeWGEQ0n1N96ryjVu3
         YUvnLbKn5CZAiTmpz3w19DIuZumjYPmxYe+d7ii4ozW+gUs9ZVzqhjrY+IWJOf5AKIz5
         TDBQ==
X-Gm-Message-State: AC+VfDxLH1xtXjpvmy2cpd4SnOUEpay1GzH/++hK3aq0T3tCZrkPqRsv
        24EXQD7ypNvn/vPCegIzYIxq2g==
X-Google-Smtp-Source: ACHHUZ7hGHGwi7ptFp7dDRS6Z6+2UNRDyiR5qq+R0zKm3LPTmxEiM/1iXpaTmu/76o0ziH1heFA4BQ==
X-Received: by 2002:a17:906:44c:b0:98e:a54:42e6 with SMTP id e12-20020a170906044c00b0098e0a5442e6mr75957eja.5.1687593447021;
        Sat, 24 Jun 2023 00:57:27 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id q16-20020a170906361000b009893f268b92sm600124ejb.28.2023.06.24.00.57.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jun 2023 00:57:26 -0700 (PDT)
Message-ID: <703ed392-5607-446e-e59a-8b51b6cd0007@linaro.org>
Date:   Sat, 24 Jun 2023 09:57:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 12/45] dt-bindings: reset: atmel,at91sam9260-reset: add
 sam9x7 binding
Content-Language: en-US
To:     Varshini Rajendran <varshini.rajendran@microchip.com>,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        conor+dt@kernel.org, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, claudiu.beznea@microchip.com,
        mturquette@baylibre.com, sboyd@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net, vkoul@kernel.org,
        tglx@linutronix.de, maz@kernel.org, lee@kernel.org,
        ulf.hansson@linaro.org, tudor.ambarus@linaro.org,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linus.walleij@linaro.org, p.zabel@pengutronix.de,
        olivia@selenic.com, a.zummo@towertech.it,
        radu_nicolae.pirea@upb.ro, richard.genoud@gmail.com,
        gregkh@linuxfoundation.org, lgirdwood@gmail.com,
        broonie@kernel.org, wim@linux-watchdog.org, linux@roeck-us.net,
        arnd@arndb.de, olof@lixom.net, soc@kernel.org,
        linux@armlinux.org.uk, sre@kernel.org, jerry.ray@microchip.com,
        horatiu.vultur@microchip.com, durai.manickamkr@microchip.com,
        andrew@lunn.ch, alain.volmat@foss.st.com,
        neil.armstrong@linaro.org, mihai.sain@microchip.com,
        eugen.hristev@collabora.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc:     Hari.PrasathGE@microchip.com, cristian.birsan@microchip.com,
        balamanikandan.gunasundar@microchip.com,
        manikandan.m@microchip.com, dharma.b@microchip.com,
        nayabbasha.sayed@microchip.com, balakrishnan.s@microchip.com
References: <20230623203056.689705-1-varshini.rajendran@microchip.com>
 <20230623203056.689705-13-varshini.rajendran@microchip.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230623203056.689705-13-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23/06/2023 22:30, Varshini Rajendran wrote:
> Add documentation for SAM9X7 reset controller.
> 


A nit, subject: drop second/last, redundant "bindings". The
"dt-bindings" prefix is already stating that these are bindings.

> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> ---
>  .../devicetree/bindings/reset/atmel,at91sam9260-reset.yaml       | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/reset/atmel,at91sam9260-reset.yaml b/Documentation/devicetree/bindings/reset/atmel,at91sam9260-reset.yaml
> index 98465d26949e..593a13c277ab 100644
> --- a/Documentation/devicetree/bindings/reset/atmel,at91sam9260-reset.yaml
> +++ b/Documentation/devicetree/bindings/reset/atmel,at91sam9260-reset.yaml
> @@ -22,6 +22,7 @@ properties:
>                - atmel,at91sam9g45-rstc
>                - atmel,sama5d3-rstc
>                - microchip,sam9x60-rstc
> +              - microchip,sam9x7-rstc

It does not look like you tested the DTS against bindings. Please run
`make dtbs_check` (see
Documentation/devicetree/bindings/writing-schema.rst or
https://www.linaro.org/blog/tips-and-tricks-for-validating-devicetree-sources-with-the-devicetree-schema/
for instructions).


Best regards,
Krzysztof


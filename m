Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EBBC001DC
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Jun 2023 08:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbjFXI0t (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Jun 2023 04:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbjFXI0L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Jun 2023 04:26:11 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9183B2952
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 01:24:37 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-9875c2d949eso192365866b.0
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 01:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687595053; x=1690187053;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gUb+krGwN/aq//L4Czp4P4ZaV1gvYMjmNFcm0YMeIks=;
        b=eYA3UJqMnYNFBT5YZIdndLK6CYo10TAEJUhO1rkDE5wRgXG7Ro1wa+qDplNjiUeBFI
         nBfpUZwFUh5v9V0WrZrJeifCf1f/b6uFDUFZoPQm9zNraIfrLhlrbVS80/F2KZEqy4bP
         7hXfD0f97dggnTdpI+BcBXGROELwxH6n+nxaqPqwOd5nSUDFjPdenNs2GXZVqoCsfhQv
         5/Sak6C33KxreCsmFuTYXzOnBrOxrQzvQIcDIM/M2Ps1qpkZI93NLRAvWZzSKar82V1/
         ccuWAs8GicSYXSdAi7pIE82U6LX24WK5SjWwFbkXh6T0cFvSd7CU0QGDwwXBNlDsqGUb
         tV8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687595053; x=1690187053;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gUb+krGwN/aq//L4Czp4P4ZaV1gvYMjmNFcm0YMeIks=;
        b=LUmImcgc1zKhqQhPugEJB041HeQ78V5YRcd3NSz9TgflKx9UvdDfsU2ZDpRdgDFMPZ
         DxMF7/fCnkrEWzNDnTlgpsg3CC4hxBCY4ThlAx2zhGh4ASh2Q461/6+VgcYGe8dEtvkQ
         qLT+ge/2UQv9M8X/afKDXSQgN1ZDw8GaKEGg1euiuG2+tl0h7p8UXtPV68d5eIimCoV4
         bJj3rg6kAcslf4nCSEAQC8pVcGOzdUvqcAo3Zmw37hZUaPyWw4yWiKavEeeRfD4soMuT
         ATauWY4sSQYCXzKqHVK3oPEMY24T2Lv8OuB+UUaqL4/mMqn8qoaO3/M4C+Wt7hB1hmSC
         7g9Q==
X-Gm-Message-State: AC+VfDzdRQutLpfN7T7lAHWa9hfl5xEqqyonmWAo7YrhDSk17wBZ8/ec
        cfsM2vZ8WjfjBGC3OGjYuwDerg==
X-Google-Smtp-Source: ACHHUZ633G3vozqxhYSlb2/G6s1lR3tDI248WrtY+qSGpfA/pYjsCnzPQDLjOoJSYY1d4qs/oFcuJA==
X-Received: by 2002:a17:906:da84:b0:988:f307:aea7 with SMTP id xh4-20020a170906da8400b00988f307aea7mr14027159ejb.7.1687595052667;
        Sat, 24 Jun 2023 01:24:12 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id c15-20020a170906528f00b0098866a94f14sm610407ejm.125.2023.06.24.01.24.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jun 2023 01:24:12 -0700 (PDT)
Message-ID: <8f231d42-1022-0595-2dc6-24817a7495b4@linaro.org>
Date:   Sat, 24 Jun 2023 10:24:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 22/45] dt-bindings: atmel-smc: add microchip,sam9x7-smc
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
 <20230623203056.689705-23-varshini.rajendran@microchip.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230623203056.689705-23-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23/06/2023 22:30, Varshini Rajendran wrote:
> Add microchip,sam9x7-smc to DT bindings documentation.
> 
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> ---
>  Documentation/devicetree/bindings/mfd/atmel-smc.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/atmel-smc.txt b/Documentation/devicetree/bindings/mfd/atmel-smc.txt
> index 5696d9fcb5dc..1eb2606820a5 100644
> --- a/Documentation/devicetree/bindings/mfd/atmel-smc.txt
> +++ b/Documentation/devicetree/bindings/mfd/atmel-smc.txt
> @@ -10,6 +10,7 @@ Required properties:
>  			"atmel,sama5d3-smc", "syscon"
>  			"atmel,sama5d2-smc", "syscon"
>  			"microchip,sam9x60-smc", "syscon"
> +			"microchip,sam9x7-smc", "syscon"

That's not what your DTS is saying. NAK.

Best regards,
Krzysztof


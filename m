Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65106EB64DD
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Jun 2023 08:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbjFXI1M (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Jun 2023 04:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbjFXI0X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Jun 2023 04:26:23 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3762964
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 01:24:47 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-988c30a540aso159790166b.3
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 01:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687595058; x=1690187058;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dPneVN2rCFPZCWtN2Y3Y7VAYQxdyjaJ8jbh3KeTpdLs=;
        b=ma3NfE6b0iuczvDz33OkA/uVJrxAQ0MAFGHk9u7v1nR8D47ZBhw+gjIKtoDzcuY8wB
         5Pvy2qhRvcmPuwpH6Rnrell8MA5C7ERsiEZcNrkTdp2enRRGz9YPH87CceUiDv5qwK75
         d896yHgKdfHQUS9Eg9eIhEqyw4B9mE251eGpuz04MVFGWKdUuNcFeBoHnIh0QuUcthnS
         eJBnB3dNkPlBOU9M585Rs+CiS0CIFL/3ZSHm5w9+0Ssxpjw/anOhPvtredgrXIbeUSj1
         r9EbwEOwv+nT8pNTwsJJO4EB/ZoVNvunu6EeU/OOohiECV7HuhxnULraB/RzV8f3YdkX
         65nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687595058; x=1690187058;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dPneVN2rCFPZCWtN2Y3Y7VAYQxdyjaJ8jbh3KeTpdLs=;
        b=V1SLD7BlhVCqD26SZtQzgC0zjUpB4S9oPq6L/WjzhIACzZzN0O7pFpmrrTC9tpx7t2
         b2vA/q8yp9OGx/7IY8T6M4Knj8fQp6WWZsWtqKEDAqSAl50njDM/LExQyi4Ht1LLjHva
         U33MqY2qrjn/1blz6WzbZ4MyuE7glM+4qtQVc8+po63ZllDX8objPK2GjgRG8D5TvVdy
         hwR0n/jAMM3tSFu7/3nWSoqri/c+Y8nyUtD/N4Nxgs8gF29tWcZyGYUWo3g0mEH97Wjp
         89keAD2Onm4Ln9sQZEWNFyPTpDbcs36RrArtuKy/rsnRK9ogw5tB4B0bg7vpeCt0+Vcb
         2S2g==
X-Gm-Message-State: AC+VfDzacHhVeOjztIPJapYcrEdIatPAvwldXVgzJtXNjNUPXBT4ONhE
        y7rrj3dvzFB+vjilKAaXmc13lw==
X-Google-Smtp-Source: ACHHUZ6AtPijKbF7bGoaGRTgUD1LMM3LYmmo8YnqmXKrV8jF1gHofaeMAnYGyMfoMbRKzIjPK+/0tw==
X-Received: by 2002:a17:907:980c:b0:988:c24d:3d33 with SMTP id ji12-20020a170907980c00b00988c24d3d33mr13654323ejc.12.1687595057964;
        Sat, 24 Jun 2023 01:24:17 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id i23-20020a50fc17000000b0051c7b5692easm435291edr.7.2023.06.24.01.24.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jun 2023 01:24:17 -0700 (PDT)
Message-ID: <fb79e3d6-7164-2dc6-0d73-c32ff8a1c7f9@linaro.org>
Date:   Sat, 24 Jun 2023 10:24:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 23/45] dt-bindings: atmel-ssc: add microchip,sam9x7-ssc
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
 <20230623203056.689705-24-varshini.rajendran@microchip.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230623203056.689705-24-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23/06/2023 22:30, Varshini Rajendran wrote:
> Add microchip,sam9x7-ssc to DT bindings documentation.
> 
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> ---
>  Documentation/devicetree/bindings/misc/atmel-ssc.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/misc/atmel-ssc.txt b/Documentation/devicetree/bindings/misc/atmel-ssc.txt
> index f9fb412642fe..67c1227a01bd 100644
> --- a/Documentation/devicetree/bindings/misc/atmel-ssc.txt
> +++ b/Documentation/devicetree/bindings/misc/atmel-ssc.txt
> @@ -2,6 +2,7 @@
>  
>  Required properties:
>  - compatible: "atmel,at91rm9200-ssc" or "atmel,at91sam9g45-ssc"
> +	       or "microchip,sam9x7-ssc"

That's not what your DTS is saying. NAK.

Best regards,
Krzysztof


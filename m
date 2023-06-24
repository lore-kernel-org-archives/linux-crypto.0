Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F50AEB64DD
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Jun 2023 08:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbjFXIFB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Jun 2023 04:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbjFXIEh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Jun 2023 04:04:37 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E529297C
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 01:03:55 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-51bec86b9c9so1506207a12.2
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 01:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687593802; x=1690185802;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LafiNXSw+zwzkCcD61tNVkSDk1UzsnZGQNFOHQIckUc=;
        b=E0MlV0GQvGr61TLHUeLUX7K4RKJbbZT+46+KOPXItxfa1kGrSeRn9gXbUtlckJpnM/
         o3h1VNL1amgLqrC/vh909Fc+Le0/1qVQUczndSlbEc3xMr+6MTs4kw5POYSuAFIaWdjB
         KrrlrOhDRofruYCZeeLquI/1Fd9m+fahMOpm/HOuyaOP2ematY8blA6Yno/Qx3OKWFh8
         y/6ktg4Znn4suJdbr1P5vrImzzc1WqhxUY8e+zJ1gasuY2VORMrZmbllh+XGqcpWlj5N
         VP4AzDVW6JgOoAvkfjnNl9bztm0gXUKz8UOQbBiLxtfCVaY9D/QbpumZtHXeNEYd4u7c
         LEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687593802; x=1690185802;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LafiNXSw+zwzkCcD61tNVkSDk1UzsnZGQNFOHQIckUc=;
        b=HQwAz0KrgudzPnIJCZtZSh7LXG7HaQ3huSmOgJz7XjvOAEUettARNSCdAtAskb3qkK
         tYYmOACGWrVmpq39H1o2gTo3CwksVoqwio7D4up5nOEkm5pPtEZc0q46AZjEEfM3E1CM
         l2bM76W3zSnhxLgpd1TcCZ7jJ2DbstMEvxTJaOiHymhskFO4/0x1GfFpV4DoNKXQhk98
         RjZTkU/xAVnyyWIJzKr+n/snE4YPkvqDSgaxNGV35Dk8DVrmhc8UtFINU579paR/ZT5m
         jtyEzE2R830WQcJWcTNiZ9RQ6cMry37ppChd9/rnPWeR0EbjQdDsdeAg09rqjRTFlOv5
         NpeA==
X-Gm-Message-State: AC+VfDwB076Aq2TYTQZmY+Gom6hFC5GC3hv0rSTv9VELpo/+8t2zusUw
        Tz8qVA588Cf9p01pet4s2SN2wA==
X-Google-Smtp-Source: ACHHUZ6C0rvzl2GKbsYXoP7Ohg1Api903AvKgo4IuRCGX/jGRLZS6P8DTOGf+2z7abGrmlBbMBqn+g==
X-Received: by 2002:a17:907:2d28:b0:98d:81c7:f01c with SMTP id gs40-20020a1709072d2800b0098d81c7f01cmr3338161ejc.38.1687593802608;
        Sat, 24 Jun 2023 01:03:22 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id u12-20020a05640207cc00b0051bf998b25fsm407586edy.44.2023.06.24.01.03.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jun 2023 01:03:22 -0700 (PDT)
Message-ID: <f158149a-bc40-b828-9631-ff6ca677504c@linaro.org>
Date:   Sat, 24 Jun 2023 10:03:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 34/45] dt-bindings: watchdog: sama5d4-wdt: add
 compatible for sam9x7-wdt
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
 <20230623203056.689705-35-varshini.rajendran@microchip.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230623203056.689705-35-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23/06/2023 22:30, Varshini Rajendran wrote:
> Add compatible microchip,sam9x7-wdt to DT bindings documentation.
> 
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> ---
>  .../devicetree/bindings/watchdog/atmel,sama5d4-wdt.yaml          | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/atmel,sama5d4-wdt.yaml b/Documentation/devicetree/bindings/watchdog/atmel,sama5d4-wdt.yaml
> index 816f85ee2c77..216e64dfddb2 100644
> --- a/Documentation/devicetree/bindings/watchdog/atmel,sama5d4-wdt.yaml
> +++ b/Documentation/devicetree/bindings/watchdog/atmel,sama5d4-wdt.yaml
> @@ -17,6 +17,7 @@ properties:
>      enum:
>        - atmel,sama5d4-wdt
>        - microchip,sam9x60-wdt
> +      - microchip,sam9x7-wdt
>        - microchip,sama7g5-wdt

Same as in other cases, so just to avoid applying by maintainer: looks
not tested and not working.

Best regards,
Krzysztof


Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B99C001DF
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Jun 2023 08:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbjFXIav (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Jun 2023 04:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbjFXIaU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Jun 2023 04:30:20 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BD34220
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 01:27:12 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9883123260fso151873966b.0
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 01:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687595231; x=1690187231;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gJlPeAcJkflrsYHeqhAxG1xpnKkKctKx9VK4XOcUSNU=;
        b=Kkt2tu0fZVyjdnIT+9aWz+2dC0xTVD3lu4yLwV0kQqZHuhz8Ro07GQdKqy6N1bU9f6
         pQSHbTPMPW6t676hrqq5z5c4/jC1zAayJMvQIsQvygTbtQ1Ast7+Cs+Sp/qYXZDLJHWw
         XBE4dYbEQtIeIRkumTncrrM+RY7bqG5QLJTYAogks8em7F36iQZDlMeHdRvWBibNfJyB
         5GEQ4ZMC7udapD1WxMM6AWpT4cPZ2HWl0da/r/wrXgxUiY6gz4DHtTZ2kx7RHe9LGGjI
         QKd+aWA5QHSnmV6Qgt2UIMZ5Ylb44sRp4CxcC3kLBCXNXnUnEVR8y9x1idlk9Lr31Gd9
         XPIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687595231; x=1690187231;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gJlPeAcJkflrsYHeqhAxG1xpnKkKctKx9VK4XOcUSNU=;
        b=U3DDRj2/p4rLKCwYm48sTucyeVFmVAC2ks4M9+L33U3kERiHtpiO+NA53tVN93R/Gv
         g03Awp+r3KR6ELMWBvFc/O2gM1hRK3eHVIIWpEZmIribE5lla4sLyo5RjUmYUKk/lz8I
         aCfpXQn0QE0j9tUJk33e52T9DUC+2BnLzagQXmkGa/AtqVI0KDAHWtwkC/2Tu7Z7GqSU
         e29LIcAgRIBKnHdzxrogFJA7DAWLyWYBwrsh1927eJeqHUscWYUFGzDyBKOAi7+GjGaG
         475j5Go8xH4Ema2gOY/VoRrupwD4OxrAU/dt8FhMZJAsZUUaLJhwuRk3ppdASBvH2cEX
         NjiQ==
X-Gm-Message-State: AC+VfDx3Ip1trQmvseqi5vMTrl29kLFpOECIO53qO6743Jmwhn0CVhLI
        yWz4i97an8R5PsrYRGbq6zEd8A==
X-Google-Smtp-Source: ACHHUZ5t7epZFC28S4hxtPyy+RCHfLvODV3nPC4aL8/psJFMdpVy5ABk2SDosvlu0zr3308+wJnq2w==
X-Received: by 2002:a17:907:8a03:b0:988:acb4:f63 with SMTP id sc3-20020a1709078a0300b00988acb40f63mr12986422ejc.74.1687595230874;
        Sat, 24 Jun 2023 01:27:10 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id t6-20020a1709060c4600b0098654d3c270sm635400ejf.52.2023.06.24.01.27.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jun 2023 01:27:10 -0700 (PDT)
Message-ID: <caff28bc-8824-f173-99ea-267dd26e5cbc@linaro.org>
Date:   Sat, 24 Jun 2023 10:27:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 17/45] dt-bindings: dmaengine: at_xdmac: add compatible
 with microchip,sam9x7
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
 <20230623203056.689705-18-varshini.rajendran@microchip.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230623203056.689705-18-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23/06/2023 22:30, Varshini Rajendran wrote:
> Add compatible for sam9x7.
> 
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> ---
>  Documentation/devicetree/bindings/dma/atmel-xdma.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/dma/atmel-xdma.txt b/Documentation/devicetree/bindings/dma/atmel-xdma.txt
> index 510b7f25ba24..f672556ea715 100644
> --- a/Documentation/devicetree/bindings/dma/atmel-xdma.txt
> +++ b/Documentation/devicetree/bindings/dma/atmel-xdma.txt
> @@ -2,8 +2,8 @@
>  
>  * XDMA Controller
>  Required properties:
> -- compatible: Should be "atmel,sama5d4-dma", "microchip,sam9x60-dma" or
> -  "microchip,sama7g5-dma".
> +- compatible: Should be "atmel,sama5d4-dma", "microchip,sam9x60-dma",
> +  "microchip,sam9x7-dma" or "microchip,sama7g5-dma".

That's not what your DTS is saying. NAK.

Best regards,
Krzysztof


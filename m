Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D967C001DE
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Jun 2023 08:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbjFXIBJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Jun 2023 04:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbjFXIBF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Jun 2023 04:01:05 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503892D42
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 01:00:48 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-51bdca52424so1556649a12.3
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 01:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687593647; x=1690185647;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VmzapWDzimsSs6oDauhmY7EwCGGpNbBGYW0zDq7Y0g0=;
        b=f5y83YDj2ZiTfv4GVL6XxhbaBiZOx8b2Dlce2BicSyjaKrg3kDy5bYdkvq4WYHDMz1
         Ux3eFKLU2XtW4NjNZu+3nofzPI6tApMEkrFij9agnP/0hLWMMo+HXTmVe4fIFHF7hTae
         SrSbgYuAOfTU+0JPddM5gmK/zaeXnm72JG7Uipl4neBtSGAQLTKpx5MCjVYgls6+G4NE
         H1Ec0eBTsmzlMz3qMbR91RzwyYZWUEUywL/5K07LC2PXw/FMwvaX6+z0Y8njTfC252LU
         Mec49oeKqIlgUkZU2Gfp86uWtTbkzHTzl1xyRp6Iv4f0UPBejvrofeBtdZUrrjTWxCdp
         0zgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687593647; x=1690185647;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VmzapWDzimsSs6oDauhmY7EwCGGpNbBGYW0zDq7Y0g0=;
        b=FMAZvF2eLe+rZQksI0lW8DZpz2FSqh1beXTrWneHjEa9URvwoakS4BnuKPeAoFkmpf
         2m9bSzOiLGzpYVJTluRdY0fRDtJvG5yCZMwTeCtpiSm1xl+Ilz2Tb4U1vvWRONzCvjT2
         rodrAksa8+sS+Oz495wA1XSgVyaKI7rKmypryEyEycL9/ZPML1H2fTzJskyskYzczz/A
         5IwaKz2lahfsFrfcOzrew4DDrS8HcjPnxLuuJfWA7nfHoYE2dRgzFeuEtl4RxVuOSmnX
         VkYhOmUKN7EjoiFi2q2xqUWn6qAtoCJOSMqv0NvRmueatWi+4G6j8LRoJ/yzAR5zaMZ0
         4x8Q==
X-Gm-Message-State: AC+VfDzb+hbQuIrZHQeGxevBU8zUfGXT0fIqrh6De2BFBGM7d1t3Yg/t
        SFay5r9b44hgMUfVNIG6kEGhLw==
X-Google-Smtp-Source: ACHHUZ7m+A1bOO2g0Q0gWubK6hkpG4u9CftsH8A5UeM6HKS2e7gJgZ9D0w88xvVVqU6mCdiqpCRT2Q==
X-Received: by 2002:aa7:d892:0:b0:51b:fc05:a6aa with SMTP id u18-20020aa7d892000000b0051bfc05a6aamr1674326edq.42.1687593646698;
        Sat, 24 Jun 2023 01:00:46 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id b10-20020a05640202ca00b0051a4ab66d92sm410131edx.11.2023.06.24.01.00.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jun 2023 01:00:46 -0700 (PDT)
Message-ID: <f2ba9ca6-ce6e-b012-d43c-f192a6043a42@linaro.org>
Date:   Sat, 24 Jun 2023 10:00:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 18/45] dt-bindings: i2c: at91: Add SAM9X7 compatible
 string
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
 <20230623203056.689705-19-varshini.rajendran@microchip.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230623203056.689705-19-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23/06/2023 22:30, Varshini Rajendran wrote:
> Add compatible string for sam9x7.
> 
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> ---
>  Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml b/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml
> index 6adedd3ec399..440f890e209f 100644
> --- a/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml
> +++ b/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml
> @@ -24,9 +24,11 @@ properties:
>                - atmel,sama5d4-i2c
>                - atmel,sama5d2-i2c
>                - microchip,sam9x60-i2c
> +              - microchip,sam9x7-i2c

Same as in other cases, so just to avoid applying by submaintainer:
looks not tested and not working.


Best regards,
Krzysztof


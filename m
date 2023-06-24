Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E998EB64DD
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Jun 2023 07:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbjFXH4Q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Jun 2023 03:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbjFXH4P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Jun 2023 03:56:15 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745B026A5
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 00:56:13 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-51bece5d935so1663369a12.1
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 00:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687593372; x=1690185372;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tSt2AtZZh3GZpsNl8QTQCKxlNBUmkNMW7h6B51q0Fvg=;
        b=tp25xMDkznV75JI3vdiNAJWl65hzOtE1vIYxwwqhJlEy8/uxyjJc8gmF/4BpROZwMT
         So8ags5GA1qeqt4Tvv428U9zTD3AyFOt9eJl17rkpG9KAF+5CO4JrNvHK7RXC/XAuRr+
         JcopiYDZa1WusC6EfjHKdyFc3XbT1M/q56rklAdlCGENZH4tkQV/QG/JZVau6sqLBXB0
         2dRHekqT/OoGYzPBegRHXQEZ3vSChxxWz73Vul9JkPlhE3sg97lUxnYzd8hlJPIBh9re
         Ua5gz1poF3bWk4vsdRhFLrh3EuQLyNSezyG9xckHLFn7241Ta+EO82c3g+jtHwkNHVWO
         bPSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687593372; x=1690185372;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tSt2AtZZh3GZpsNl8QTQCKxlNBUmkNMW7h6B51q0Fvg=;
        b=Bqqk0yE7dJ1GMP42sLowQYYFyT7qw0uJKbhOXwog/a5pRCe6wk3PCMaERLxxsExtp5
         /C94zFhX317xRY43bosU/KiKeyzvKWzdtjkPyB5yKnD6yTRcCoOoN96J8fxtxhRtYmA3
         8L++AkfbjhyWm+XemGWyzrAglOhBe6a48hEz4askLW1cPzMktgd4kpq35oKzg0ILdfh8
         00vkk+Clcer5xBFaMj25KUSC97lqLh6yckdAIsTevvIacpXUEL59lf27cNWvV9evC/E3
         5GdXHTUHx5QEWX3kN/9VbhsnwSjAKGWOd98y7gAmxZwYEv2idTLYFIA4XqJ7gQv5tBmc
         tnXQ==
X-Gm-Message-State: AC+VfDyZKJVo+DBE+ToptXu3iETUgEuCvkrerahO+N8a9KmpF/OITVZ3
        jv0xyPCOaGIhf7CrM6ugutNW9w==
X-Google-Smtp-Source: ACHHUZ6NF60BoiHF1787mu6pGM6EiBURQ9TKeKNqM6q3ihuvMLTZrjMfALGAKYzmSFnyF+q8mSD8Pw==
X-Received: by 2002:a17:907:970e:b0:98d:470d:6c7e with SMTP id jg14-20020a170907970e00b0098d470d6c7emr5868847ejc.16.1687593371873;
        Sat, 24 Jun 2023 00:56:11 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id fy23-20020a170906b7d700b0098d4ac60c20sm577426ejb.190.2023.06.24.00.56.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jun 2023 00:56:11 -0700 (PDT)
Message-ID: <f2f8cabf-ca4d-c6f3-5561-b24334be89d1@linaro.org>
Date:   Sat, 24 Jun 2023 09:56:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 00/45] Add support for sam9x7 SoC family
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
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230623203056.689705-1-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23/06/2023 22:30, Varshini Rajendran wrote:
> This patch series adds support for the new SoC family - sam9x7.
>  - The device tree, configs and drivers are added
>  - Clock driver for sam9x7 is added
>  - Support for basic peripherals is added
>  - Target board SAM9X75 Curiosity is added

Your CC list is enormous and causes multiple bounces/rejections.

Organize your patchset properly to avoid this.

Best regards,
Krzysztof


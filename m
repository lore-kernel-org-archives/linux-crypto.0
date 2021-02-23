Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF936C433DB
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 20:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 969C564EE8
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 20:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbhBWUoS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Feb 2021 15:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbhBWUoR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Feb 2021 15:44:17 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C23EC061574;
        Tue, 23 Feb 2021 12:43:37 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id v200so1134243pfc.0;
        Tue, 23 Feb 2021 12:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=uXkbv0Al38d94LWcxq8Bj93Z4Ugv3dEG44H3RtuFnOE=;
        b=pGh6RYMlhc6kyjOAOOFIX2Adyc44RM6rHr4ercnal6CoIwhMRDtGuqpp0iGAw2I+oE
         yPtqeGXDtJwtkGXe5j0ZkNOyjegOOz5eqZuqBdwWuqoDwP+qTV+mHHoq2CJSC3JfjNNT
         m0GmnBLzC2bquGACL+8yTOpFB67GFDtRZPqeHZO0JIIfnq/x12utBjt4aF7V8H+7F1At
         1bt6mm2sdzguqyLs0aZ0XOruUv8MK2URT7Ez85OYRK+V+VRA/nMl+vijz04jnIitcQ3w
         STVHAqmCieHuhLcG5Q7IbdX8vjG/9Xw4+56FVIy5o+Jxn/730Z4LZbJkNlA9UHq03bne
         K2zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uXkbv0Al38d94LWcxq8Bj93Z4Ugv3dEG44H3RtuFnOE=;
        b=cvtkELpLTq2w3JO9+cmyVwfo6Lj/smGwDYr31QKqHw6P9rX+KCK8718AlJrKTw+mYi
         HEz1lnpURE/jsLqiI+t78LcYImRSBxjZlAxclBWeFG/gHOXLljURHxIES8oS61YayAZY
         TC5HZIAzGrAUKZ3YaGzcbCpnzr4A2Lx+gyH1hn6gS+v8rt4RHwCu8lMYQoy6XXCmL8wk
         TnylZGVv85Ya9T8LYiyXx3IF9pU1JnARvPsfRk4IaUS/uYq6cuE9GI6sGxrV3mDJ0IvS
         Z0v6mv1JQCqcavK2flM5LTZ+ssYS6ukssfV7TV2SPJsoddtcO6T7xLDms3tIiWZUk/mV
         88UQ==
X-Gm-Message-State: AOAM5329AvEfT1/AzS1JN+LCJYG34FY+DXXplvx9VJDts+Y2xzY6xHGZ
        MRsUizBic3II1XrX0JmeupH+KB6W19I=
X-Google-Smtp-Source: ABdhPJxMoEN5kODw1nN3woclQ/G6kQkJ82g5taD7qVF0A5AoZHkGIaUPm1PUUxn/ivniJNfXuRXT6A==
X-Received: by 2002:a65:458b:: with SMTP id o11mr10437791pgq.416.1614113016209;
        Tue, 23 Feb 2021 12:43:36 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h18sm19373pfo.112.2021.02.23.12.43.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 12:43:35 -0800 (PST)
Subject: Re: [PATCH v3 2/2] hwrng: bcm2835: add reset support
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        =?UTF-8?B?TsOtY29sYXMgRi4gUi4gQS4gUHJhZG8=?= 
        <nfraprado@protonmail.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20210222194510.14004-1-noltari@gmail.com>
 <20210223170006.29558-1-noltari@gmail.com>
 <20210223170006.29558-3-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0efc029f-dbb1-198c-8a1e-6bc85f5cc6ee@gmail.com>
Date:   Tue, 23 Feb 2021 12:43:32 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210223170006.29558-3-noltari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2/23/2021 9:00 AM, Álvaro Fernández Rojas wrote:
> BCM6368 devices need to reset the in order to generate true random numbers.
> This is what BCM6368 produces without a reset:
> root@OpenWrt:/# cat /dev/hwrng | rngtest -c 1000
> rngtest 6.10
> Copyright (c) 2004 by Henrique de Moraes Holschuh
> This is free software; see the source for copying conditions.  There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 0
> rngtest: FIPS 140-2 failures: 1000
> rngtest: FIPS 140-2(2001-10-10) Monobit: 2
> rngtest: FIPS 140-2(2001-10-10) Poker: 1000
> rngtest: FIPS 140-2(2001-10-10) Runs: 1000
> rngtest: FIPS 140-2(2001-10-10) Long run: 30
> rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> rngtest: input channel speed: (min=37.253; avg=320.827; max=635.783)Mibits/s
> rngtest: FIPS tests speed: (min=12.141; avg=15.034; max=16.428)Mibits/s
> rngtest: Program run time: 1336176 microseconds
> cat: write error: Broken pipe
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>  v3: no changes.
>  v2: no changes.
> 
>  drivers/char/hw_random/bcm2835-rng.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
> index 1a7c43b43c6b..1b93a896d8e8 100644
> --- a/drivers/char/hw_random/bcm2835-rng.c
> +++ b/drivers/char/hw_random/bcm2835-rng.c
> @@ -13,6 +13,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/printk.h>
>  #include <linux/clk.h>
> +#include <linux/reset.h>
>  
>  #define RNG_CTRL	0x0
>  #define RNG_STATUS	0x4
> @@ -32,6 +33,7 @@ struct bcm2835_rng_priv {
>  	void __iomem *base;
>  	bool mask_interrupts;
>  	struct clk *clk;
> +	struct reset_control *reset;
>  };
>  
>  static inline struct bcm2835_rng_priv *to_rng_priv(struct hwrng *rng)
> @@ -94,6 +96,10 @@ static int bcm2835_rng_init(struct hwrng *rng)
>  			return ret;
>  	}
>  
> +	ret = reset_control_reset(priv->reset);
> +	if (ret)
> +		return ret;

For symmetry, the remove path should call reset_control_rearm(),
assuming that .reset() is what you want and not .deassert()/assert().
-- 
Florian

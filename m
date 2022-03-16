Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 976ABC433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Mar 2022 08:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354362AbiCPIeF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Mar 2022 04:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354229AbiCPIeE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Mar 2022 04:34:04 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1049E04
        for <linux-crypto@vger.kernel.org>; Wed, 16 Mar 2022 01:32:48 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id x15so1794870wru.13
        for <linux-crypto@vger.kernel.org>; Wed, 16 Mar 2022 01:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=A6OiZGn3W785peW6L2GCeo3dDpI9qLCBqiM06s7mTPA=;
        b=ssOh0xb2Ru1dbF/bzLRWZBYe2BIG06gq7vEpxnb53ljang4uddxWAWBorZj8WHN1k3
         fs5bWg4kWKxDk0MgizjHRUXLDBTzbKWU8MsWNbxa+XxKuRewQYHN9fybcsr6172lEcJ/
         eqQhTAwiX8icMY/8tA2N1UCnJnIYJGGmJsKjFWVusK4FmRfrIUJ8ZvpvS47kk0azHD6j
         Mlyagp2ocQ5IXG67hkkbQU7Hfm9QFNUSYnYHp1nNVCkVNz7F7dMF/ieiiHgOOqSMPPIz
         4r73UvAjT/1mwACaB6BKY+RgXOP4Ho0W08pHbNWTTkMP7XFkOErJQdvSNeThDpZtCNYt
         +zxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=A6OiZGn3W785peW6L2GCeo3dDpI9qLCBqiM06s7mTPA=;
        b=IXT/KhPHNwiAu7lK5Tic8q7i+OuEBeEqc6lfuRKezd+sOdvgOyaF8iJ5aTj/BA+XC2
         tgz8Boo77HUHPdXlGVypP88VGWJbypWK5I1dDwMu9QoLKWjBTnpzokXXrjWN04OjxzQ9
         N0g4onEbo1ooBHYMG/x3nfNXroF9qOj8HteY2jxPuWVIRcjk3qxHZqFhJTigalgBDO5W
         hAf433lLHDLxoZZuBbwNqKRMcsqlM8FZA7YEoArz/c8nKtUTPcVc2/ssHizk6r/MfBaA
         RVGBP4VhaI6Hx9ZPn/5QHocZ5qTvvIJb36gpKaauo8VV+iCztuZPipeQhsKr5l21gftA
         MA4g==
X-Gm-Message-State: AOAM530hTGEUi2Qq3xhMsCQ0J+Wm8nKLs/fQrLqZ+XGTBqSbiUD6HYR3
        +7fCDD4/epbX4+rB6Yc5EshP5g==
X-Google-Smtp-Source: ABdhPJxvgJk0e/K/qRjSL5h/IDJ/hSenc4NVjfdXrDoOyEM77755TZTu3V7g92jAq6W8CsPCiMiasw==
X-Received: by 2002:adf:f9c4:0:b0:203:e021:5eb0 with SMTP id w4-20020adff9c4000000b00203e0215eb0mr1034634wrr.529.1647419566993;
        Wed, 16 Mar 2022 01:32:46 -0700 (PDT)
Received: from [192.168.1.10] (i16-les01-ntr-213-44-230-108.sfr.lns.abo.bbox.fr. [213.44.230.108])
        by smtp.gmail.com with ESMTPSA id z5-20020a05600c0a0500b0037bb8df81a2sm5439026wmp.13.2022.03.16.01.32.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 01:32:46 -0700 (PDT)
Message-ID: <4e4f630e-adbd-79a9-ea04-6f981d40485e@baylibre.com>
Date:   Wed, 16 Mar 2022 09:32:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v8 05/16] hwrng: meson - Don't open-code
 devm_clk_get_optional_enabled()
Content-Language: en-US
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-clk@vger.kernel.org, kernel@pengutronix.de,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
References: <20220314141643.22184-1-u.kleine-koenig@pengutronix.de>
 <20220314141643.22184-6-u.kleine-koenig@pengutronix.de>
From:   Neil Armstrong <narmstrong@baylibre.com>
Organization: Baylibre
In-Reply-To: <20220314141643.22184-6-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 14/03/2022 15:16, Uwe Kleine-König wrote:
> devm_clk_get_enabled() returns a clock prepared and enabled and already
> registers a devm exit handler to disable (and unprepare) the clock.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>   drivers/char/hw_random/meson-rng.c | 20 ++------------------
>   1 file changed, 2 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
> index 8bb30282ca46..06db5a93e257 100644
> --- a/drivers/char/hw_random/meson-rng.c
> +++ b/drivers/char/hw_random/meson-rng.c
> @@ -33,16 +33,10 @@ static int meson_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
>   	return sizeof(u32);
>   }
>   
> -static void meson_rng_clk_disable(void *data)
> -{
> -	clk_disable_unprepare(data);
> -}
> -
>   static int meson_rng_probe(struct platform_device *pdev)
>   {
>   	struct device *dev = &pdev->dev;
>   	struct meson_rng_data *data;
> -	int ret;
>   
>   	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
>   	if (!data)
> @@ -54,20 +48,10 @@ static int meson_rng_probe(struct platform_device *pdev)
>   	if (IS_ERR(data->base))
>   		return PTR_ERR(data->base);
>   
> -	data->core_clk = devm_clk_get_optional(dev, "core");
> +	data->core_clk = devm_clk_get_optional_enabled(dev, "core");
>   	if (IS_ERR(data->core_clk))
>   		return dev_err_probe(dev, PTR_ERR(data->core_clk),
> -				     "Failed to get core clock\n");
> -
> -	if (data->core_clk) {
> -		ret = clk_prepare_enable(data->core_clk);
> -		if (ret)
> -			return ret;
> -		ret = devm_add_action_or_reset(dev, meson_rng_clk_disable,
> -					       data->core_clk);
> -		if (ret)
> -			return ret;
> -	}
> +				     "Failed to get enabled core clock\n");
>   
>   	data->rng.name = pdev->name;
>   	data->rng.read = meson_rng_read;

Acked-by: Neil Armstrong <narmstrong@baylibre.com>

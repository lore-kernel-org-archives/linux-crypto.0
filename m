Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 339A3C7EE23
	for <linux-crypto@archiver.kernel.org>; Fri, 26 May 2023 07:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242147AbjEZHtL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 May 2023 03:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242533AbjEZHtK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 May 2023 03:49:10 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D27134
        for <linux-crypto@vger.kernel.org>; Fri, 26 May 2023 00:49:08 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f6e4554453so2889745e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 26 May 2023 00:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685087346; x=1687679346;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mxX6zZjlTYv+FEpGCsdm1mGnEuSAnfP4zZXHzmmox9g=;
        b=BraIA/chl7+Gd+OY29ymVgA3gbTv9S62ZpSTjWRPwROYoXp/IEgHgvOGuCEkgG8rqG
         FNX/iSq2chwtlY/F5vvgCn6IPzzxd/3H3sIG4y1/qqRNhfJ1N+cgYpKxl4ZBCJErsZ/P
         HV25K5BT/tjIEKsP5hrksSTzdqwOUCsbIj54ygN31an9+OXB3WI/YOnPiXgEOZOaCs3w
         KNQEhQhmK6Hx/jJ9IWJskX4otf8OMNeM45mU24UFBzIqg+8pA5jpnVj/HsrXe9cqvWqr
         Bp1D9nogSqgGOhDcfoPJ1k9XvwXib7VL4/OkkVvZr9zITlJe9anT02j5S2nZXDTnCrVO
         nMYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685087346; x=1687679346;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mxX6zZjlTYv+FEpGCsdm1mGnEuSAnfP4zZXHzmmox9g=;
        b=Zbmmi1wAHx7ast0hs62hvrAp1erqXZpWgp+t8GaPoHxUrNK6WGNfzUJ8kW0c0CkREO
         Dscb/29Hr6YfLJF+d4d73YxyWS00rw0oIBC8i+bE2caxuhn4QT5KscZUbiFI5oGkYrOS
         JQuBBwexVeQehpWbxmOwKbPj4kdhI49Y8S0MOe9Z23TeKBQMGkWznf2CONnXvifr35Hu
         tHZu1C0Q5XyU36OA8pwk7bmG1UtNKTSIEn0PLuKMT7UyI8RPnkf1qh+UQnghpZz475ZP
         zOXpuD3syBtykk68YoRD/RF8yYReCld7JlryvlZzn9IvPwK47D7A28YJj3XnA7QuAXbQ
         9Usg==
X-Gm-Message-State: AC+VfDyMhvK4D6UYLc3nJY6mv0nng/7LaSddNM5K8SHISu53lQ04lzB2
        hhqI+0IHJNpGkz4p2bq/RmncTg==
X-Google-Smtp-Source: ACHHUZ6OZf+EpCgaWY9P5FUG3oeamK1kisguCe1dnOyViW6q7fPuKY1Ei9wGkGFG81DyscwKe2n55g==
X-Received: by 2002:a05:600c:204d:b0:3f6:479:3985 with SMTP id p13-20020a05600c204d00b003f604793985mr695388wmg.23.1685087346540;
        Fri, 26 May 2023 00:49:06 -0700 (PDT)
Received: from [192.168.2.107] ([79.115.63.206])
        by smtp.gmail.com with ESMTPSA id l22-20020a1c7916000000b003f607875e5csm8025837wme.24.2023.05.26.00.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 00:49:05 -0700 (PDT)
Message-ID: <7b74964a-01b0-4628-772d-bdfaf526f609@linaro.org>
Date:   Fri, 26 May 2023 08:49:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] crypto: Switch i2c drivers back to use .probe()
Content-Language: en-US
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
References: <20230525210347.735106-1-u.kleine-koenig@pengutronix.de>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20230525210347.735106-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 5/25/23 22:03, Uwe Kleine-König wrote:
> After commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
> call-back type"), all drivers being converted to .probe_new() and then
> 03c835f498b5 ("i2c: Switch .probe() to not take an id parameter")
> convert back to (the new) .probe() to be able to eventually drop
> .probe_new() from struct i2c_driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>

> ---
>  drivers/crypto/atmel-ecc.c     | 2 +-
>  drivers/crypto/atmel-sha204a.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> index aac64b555204..432beabd79e6 100644
> --- a/drivers/crypto/atmel-ecc.c
> +++ b/drivers/crypto/atmel-ecc.c
> @@ -389,7 +389,7 @@ static struct i2c_driver atmel_ecc_driver = {
>  		.name	= "atmel-ecc",
>  		.of_match_table = of_match_ptr(atmel_ecc_dt_ids),
>  	},
> -	.probe_new	= atmel_ecc_probe,
> +	.probe		= atmel_ecc_probe,
>  	.remove		= atmel_ecc_remove,
>  	.id_table	= atmel_ecc_id,
>  };
> diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
> index 44a185a84760..c77f482d2a97 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -141,7 +141,7 @@ static const struct i2c_device_id atmel_sha204a_id[] = {
>  MODULE_DEVICE_TABLE(i2c, atmel_sha204a_id);
>  
>  static struct i2c_driver atmel_sha204a_driver = {
> -	.probe_new		= atmel_sha204a_probe,
> +	.probe			= atmel_sha204a_probe,
>  	.remove			= atmel_sha204a_remove,
>  	.id_table		= atmel_sha204a_id,
>  
> 
> base-commit: ac9a78681b921877518763ba0e89202254349d1b

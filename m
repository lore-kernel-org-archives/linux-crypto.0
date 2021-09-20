Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86EA6C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Sep 2021 08:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67CB7610A8
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Sep 2021 08:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbhITIRe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Sep 2021 04:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233952AbhITIRe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Sep 2021 04:17:34 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF29FC061574
        for <linux-crypto@vger.kernel.org>; Mon, 20 Sep 2021 01:16:07 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x6so27264997wrv.13
        for <linux-crypto@vger.kernel.org>; Mon, 20 Sep 2021 01:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OjCsG8znUIIxw69JhRvMxK/wK/kMPyWgexeghKjT/KY=;
        b=1Rq60h4DsPfMwnngpHsLJbkprDAZfAnLguNF0Ptl0opKaEVXX21fr0T8ssgutrDsUp
         xzh0OpgrxelOADL5dzEf8bf2/vaqZa+FwmPF13LMxA7dbxgtFni2IxPZigcw1MAIR1gE
         dKhmcM7IQnLMrtYccndKt0Vj87n1D6mCWcGMGnhWnMgYCkxWQ0fxsxl2VhQSiKU5QWJ6
         NoYWR4TLdeifkJz3LkQZEmuv5JaXBoj+h2h/JhOARj3gL2537aL7KRlQY1Fx5R/b7RVC
         CzVJDwdykPhqwyNMK33mO3qyIO51QRTq2yqoRUGxRLwk3nRGcmcjvpIZbOgw9ckoI3hJ
         JONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=OjCsG8znUIIxw69JhRvMxK/wK/kMPyWgexeghKjT/KY=;
        b=0+ikv5J9WlyarWW+/3vFoakn4Cyh8gJnkWFWjeIWHOmvCW54w5j6GPU6dGQy7lqW0T
         edmmHRTV6XQOX89ZqqN67sOUdlHbtT9DU6rh+Yg1JHHgNKT2AIUY+INF/q57vrEc7Smk
         l5/MLl4cZ4A2X5Ivzh0UVhtcjMkvmUJAmOR4TeFuyZJRgRz3mQuFKE7AypkU8IcfnpHN
         9wz8pcnQBrfo3yKK/oYtuzcZAujDxovkrItys18DXy6cTjXxiV+DstTI+bnd4PEekL7N
         C1NSckQOASRi+o4k5Chi68kGARpTO8hfTj1/ZmDf0RF/v7ZzVjsmXSRdF6hgI3h19dBg
         JrlA==
X-Gm-Message-State: AOAM531TNv74JUOQxplINrYPRJRJObELDez+sc1YfymuUgvKqp5P+wZG
        H+OBwFg1i0VO9sM5/tMt3Jujgw==
X-Google-Smtp-Source: ABdhPJw8f5dW8a6oaZDekvZLLte4S7oEas9MqpgR0itNRrUWD/s/TP/g8EY7kME74Xex/QnY1EvZ1w==
X-Received: by 2002:adf:ed92:: with SMTP id c18mr26295941wro.86.1632125766286;
        Mon, 20 Sep 2021 01:16:06 -0700 (PDT)
Received: from [172.20.10.7] ([37.169.24.17])
        by smtp.gmail.com with ESMTPSA id v18sm14264137wml.44.2021.09.20.01.16.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 01:16:05 -0700 (PDT)
Subject: Re: [PATCH v2] hwrng: meson - Improve error handling for core clock
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kevin Hilman <khilman@baylibre.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Jerome Brunet <jbrunet@baylibre.com>
References: <20210920074405.252477-1-u.kleine-koenig@pengutronix.de>
From:   Neil Armstrong <narmstrong@baylibre.com>
Organization: Baylibre
Message-ID: <27b24b0e-7804-0a92-6022-ad828e1a45b5@baylibre.com>
Date:   Mon, 20 Sep 2021 10:16:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920074405.252477-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 20/09/2021 09:44, Uwe Kleine-König wrote:
> -ENOENT (ie. "there is no clock") is fine to ignore for an optional
> clock, other values are not supposed to be ignored and should be
> escalated to the caller (e.g. -EPROBE_DEFER). Ignore -ENOENT by using
> devm_clk_get_optional().
> 
> While touching this code also add an error message for the fatal errors.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> compared to (implicit) v1
> (https://lore.kernel.org/r/20210914142428.57099-1-u.kleine-koenig@pengutronix.de)
> this used dev_err_probe() as suggested by Martin Blumenstingl.
> 
> v1 got a "Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>", I didn't add
> that because of the above change.
> 

Hopefully martin did a better review than me !

Anyway,
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>

Neil

> (Hmm, my setup is broken, the b4 patch signature was done before I added this
> message. I wonder if this will break the signature ...)
> 
> Best regards
> Uwe
> 
>  drivers/char/hw_random/meson-rng.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
> index e446236e81f2..8bb30282ca46 100644
> --- a/drivers/char/hw_random/meson-rng.c
> +++ b/drivers/char/hw_random/meson-rng.c
> @@ -54,9 +54,10 @@ static int meson_rng_probe(struct platform_device *pdev)
>  	if (IS_ERR(data->base))
>  		return PTR_ERR(data->base);
>  
> -	data->core_clk = devm_clk_get(dev, "core");
> +	data->core_clk = devm_clk_get_optional(dev, "core");
>  	if (IS_ERR(data->core_clk))
> -		data->core_clk = NULL;
> +		return dev_err_probe(dev, PTR_ERR(data->core_clk),
> +				     "Failed to get core clock\n");
>  
>  	if (data->core_clk) {
>  		ret = clk_prepare_enable(data->core_clk);
> 
> base-commit: 7d2a07b769330c34b4deabeed939325c77a7ec2f
> 

